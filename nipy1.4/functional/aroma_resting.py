# -*- coding: utf-8 -*-
"""
Created on Mon Feb  9 12:26:20 2015

@author: fbeyer
"""

from nipype.pipeline.engine import Node, Workflow
import nipype.interfaces.utility as util
import nipype.interfaces.io as nio
import nipype.interfaces.fsl as fsl
import nipype.interfaces.afni as afni
from strip_rois import strip_rois_func
from moco import create_moco_pipeline
from transform_timeseries import create_transform_pipeline
from smoothing import create_smoothing_pipeline
from ants_registration import create_ants_registration_pipeline
from fieldmap_coreg import create_fmap_coreg_pipeline


'''
Main workflow for resting state preprocessing.
====================================================
Performs basic preprocessing and AROMA-based denoising 
1) removal of 4 initial volumes
2) distortion correction based on fieldmaps
3) realignment of volumes to first MCFLIRT
5) co-registration to structural
6) combine transform from functional to anatomical space
7) normalize intensity and spatial smoothing
8) ICA AROMA
9) removal of CompCor components from WM + CSF, highpass filtering
10) registration to MNI space 
'''
def create_resting():

    # main workflow
    func_preproc = Workflow(name='resting')
    
    inputnode=Node(util.IdentityInterface(fields=
    ['subject_id',
    'out_dir',
    'freesurfer_dir',
    'func',
    'rs_ap',
    'rs_pa',
    'anat_head',
    'anat_brain',
    'anat_brain_mask',
    'vol_to_remove', 
    'TR',
    'highpass_freq',
    'epi_resolution',
    'echo_space', 
    'pe_dir'     
    ]),
    name='inputnode')   
           
    # node to remove first volumes
    remove_vol = Node(util.Function(input_names=['in_file','t_min'],
    output_names=["out_file"],
    function=strip_rois_func),
    name='remove_vol')
       
    # workflow for motion correction
    moco=create_moco_pipeline()
    # workflow for fieldmap correction and coregistration
    
    fmap_coreg=create_fmap_coreg_pipeline()
    
    # workflow for applying transformations to timeseries
    transform_ts = create_transform_pipeline()
     
    #reorient to std
    reorient2std=Node(fsl.Reorient2Std(), name="reorient2std")
    #mean intensity normalization
    meanintensnorm = Node(fsl.ImageMaths(op_string= '-ing 10000'), name='meanintensnorm')
    
    smoothing = create_smoothing_pipeline() 
    smoothing.inputs.inputnode.fwhm=fwhm_smoothing
    
    
    # Anat > Standard
    # register high-resolution to standard template - ###flirt## (as preparation for fnirt)
    flirt_prep = Node(fsl.FLIRT(cost_func='mutualinfo', interp='trilinear'), name='flirt_prep')
    flirt_prep.inputs.reference=standard_brain
    flirt_prep.inputs.interp='trilinear'
    flirt_prep.inputs.dof=12   
   
    fnirt=Node(fsl.FNIRT(), name='fnirt')
    fnirt.inputs.ref_file=standard_brain
    fnirt.inputs.field_file=True
    fnirt.inputs.fieldcoeff_file=True
    
    
    aroma_prep.connect([   
    (reorient2std, flirt,  [('out_file', 'reference')]), 
    (betfunctional, flirt, [('out_file', 'in_file')]),  
    (reorient2std, flirt_prep,  [('out_file', 'in_file')]),    
    (flirt_prep, fnirt,    [('out_matrix_file', 'affine_file')]),          
    (reorient2std,fnirt, [('out_file', 'in_file')]),
    ])

    
    AROMA
    
    
    #outputnode
    outputnode=Node(util.IdentityInterface(fields=['par','rms','mean_epi','tsnr','stddev_file', 'fmap','unwarped_mean_epi2fmap',
                                                   'coregistered_epi2fmap', 'fmap_fullwarp', 'epi2anat', 'epi2anat_mat',
                                                   'epi2anat_dat','epi2anat_mincost','full_transform_ts','realigned_ts',
                                                   'full_transform_mean', 'resamp_brain', 'resamp_brain_mask','detrended_epi',
                                                   'dvars_file']),
    name='outputnode')  
        
    # connections
    func_preproc.connect([
    
    #remove the first volumes    
    (inputnode, remove_vol, [('func', 'in_file')]),
    (inputnode, remove_vol, [('vol_to_remove', 't_min')]),
    (inputnode, moco, [('anat_brain_mask', 'inputnode.brainmask')]),
    #align volumes and motion correction
    (remove_vol, moco, [('out_file', 'inputnode.epi')]),
    
    #prepare field map 
    (inputnode, fmap_coreg,[('subject_id','inputnode.fs_subject_id'),
                            ('rs_ap', 'inputnode.ap'),
                            ('rs_pa', 'inputnode.pa'),
                            ('freesurfer_dir','inputnode.fs_subjects_dir'),                             
                            ('echo_space','inputnode.echo_space'),
                            ('pe_dir','inputnode.pe_dir'),
                            ('anat_head', 'inputnode.anat_head'),
                            ('anat_brain', 'inputnode.anat_brain')
                            ]),
    (moco, fmap_coreg, [('outputnode.epi_mean', 'inputnode.epi_mean')]),
    #transform ts
    (remove_vol, transform_ts, [('out_file', 'inputnode.orig_ts')]),
    (inputnode, transform_ts, [('anat_head', 'inputnode.anat_head')]),
    (inputnode, transform_ts, [('anat_brain_mask', 'inputnode.brain_mask')]),
    (inputnode, transform_ts, [('epi_resolution','inputnode.resolution')]),
    (moco, transform_ts, [('outputnode.mat_moco', 'inputnode.mat_moco')]),
    (fmap_coreg, transform_ts, [('outputnode.fmap_fullwarp', 'inputnode.fullwarp')]),
    (transform_ts, meanintensnorm, [('in_file', 'in_file')]),
    (meanintensnorm, smoothing,  [('out_file', 'inputnode.ts_transformed')]),
    ##all the output
    (moco, outputnode, [#('outputnode.epi_moco', 'realign.@realigned_ts'),
    ('outputnode.par_moco', 'par'),
    ('outputnode.rms_moco', 'rms'),
    ('outputnode.epi_moco', 'realigned_ts'),
    ('outputnode.epi_mean', 'mean_epi'),
    ('outputnode.tsnr_file', 'tsnr'),
    ('outputnode.stddev_file', 'stddev'),
    ]),
    (fmap_coreg, outputnode, [('outputnode.fmap','fmap'),
    ('outputnode.unwarped_mean_epi2fmap', 'unwarped_mean_epi2fmap'),
    ('outputnode.epi2fmap', 'coregistered_epi2fmap'),
    ('outputnode.fmap_fullwarp', 'fmap_fullwarp'),
    ('outputnode.epi2anat', 'epi2anat'),
    ('outputnode.epi2anat_mat', 'epi2anat_mat'),
    ('outputnode.epi2anat_dat', 'epi2anat_dat'),
    ('outputnode.epi2anat_mincost', 'epi2anat_mincost')
    ]),
    (transform_ts, outputnode, [('outputnode.trans_ts', 'full_transform_ts'),
    ('outputnode.trans_ts_mean', 'full_transform_mean'),
    ('outputnode.resamp_brain', 'resamp_brain'),
    ('outputnode.brain_mask_resamp', 'resamp_brain_mask'),
    ('outputnode.out_dvars', 'dvars_file')]),
    (detrend, outputnode, [('out_file','detrended_epi')])
    ])
    
    
    return func_preproc
