# -*- coding: utf-8 -*-
"""
Created on Sat Aug 11 13:13:53 2018

@author: Rui Zhang
"""
'''
Commands use during diffusion-weighted images preprocessing
=========================================================================
Warp commands dwidenoise & mrdegibbs from MRTrix3.0; eddy-openmp from FSL
-------------------------------------------------------------------------
for unkonwn reason they are not included after loading relavant interface
'''
from nipype import Node, Workflow
from dwi_corr_util import (MRdegibbs, DWIdenoise)
from nipype.interfaces import fsl
from nipype.interfaces import utility as util
import os


def create_distortion_correct():
    # fsl output type
    fsl.FSLCommand.set_default_output_type('NIFTI_GZ')
    # initiate workflow
    distor_correct = Workflow(name='distor_correct')
    # input node
    inputnode = Node(util.IdentityInterface(fields=[
        'dwi',
        'dwi_ap',
        'dwi_pa',
        'bvals',
        'bvecs'
    ]),
        name='inputnode')
    # output node
    outputnode = Node(util.IdentityInterface(fields=[
        'bo_brain',
        "bo_brainmask",
        'noise',
        'dwi_denoised',
        "dwi_unringed",
        "dwi_appa",
        "topup_bo",
        "topup_corr",
        "topup_field",
        "topup_fieldcoef",
        "eddy_corr",
        "rotated_bvecs",
        "total_movement_rms",
	    "outlier_report",
        "cnr_maps",
        "residuals",
        "shell_params",
        "eddy_params"
    ]),
        name='outputnode')

    # to define the path in the current directory
    __location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__)))

    ''
    # noise reduction on all images
    ''
    denoise = Node(DWIdenoise(noise='noise.nii.gz'), name="denoise")
    ''
    
    #remove . from filename
    
    #### prepare fieldmap ####
    # split first magnitude image from mag input
    split = Node(fsl.ExtractROI(t_min=0,  t_size=1),    name='split')
    fmap_coreg.connect(inputnode, 'mag', split, 'in_file')
    
    # strip magnitude image and erode even further
    bet = Node(fsl.BET(frac=0.5,    mask=True),    name='bet')
    fmap_coreg.connect(split,'roi_file', bet,'in_file')   
    erode = Node(fsl.maths.ErodeImage(kernel_shape='sphere',    kernel_size=3,    args=''),    name='erode')
    fmap_coreg.connect(bet,'out_file', erode, 'in_file')
    
    # prepare fieldmap
    prep_fmap = Node(fsl.epi.PrepareFieldmap(),    name='prep_fmap')
    fmap_coreg.connect([(erode, prep_fmap, [('out_file', 'in_magnitude')]),   
                                            (inputnode, prep_fmap, [('phase', 'in_phase'),('te_diff', 'delta_TE')]),
                                            (prep_fmap, outputnode, [('out_fieldmap','fmap')])
    ])

    #divide by 2pi
    
    # skullstrip process using bet
    # mean of all b0 unwarped images
    maths = Node(fsl.ImageMaths(op_string='-Tmean'), name="maths")

    # create a brain mask from the b0 unwarped
    bet = Node(interface=fsl.BET(), name='bet')
    bet.inputs.mask = True
    bet.inputs.frac = 0.2
    bet.inputs.robust = True

    # eddy motion correction
    indx = os.path.join(__location__, 'index.txt')
    eddy = Node(fsl.epi.Eddy(), name="eddy")
    eddy.inputs.num_threads = 16 ## total number of CPUs to use
    eddy.inputs.repol = True
    eddy.inputs.in_acqp = acqparams
    eddy.inputs.in_index = indx
    eddy.inputs.cnr_maps=True
    eddy.inputs.residuals=True
    eddy.inputs.dont_peas=True
    #from the eddy user guide
    #we have single shell data and dispersed acquisition of B0 images.
    #But, if one has a data set with a single shell (i.e. a single non-zero shell) 
    #and the assumption of no movement between the first b=0 and the first 
    #diffusion weighted image is true it can be better to avoid that uncertainty. 
    #And in that case it may be better to turn off peas by setting the 
    #--dont_peas flag. 


    ''
    # connect the nodes
    ''
    distor_correct.connect([

        (merger, topup, [("merged_file", "in_file")]),
        (topup, outputnode, [('out_corrected', 'topup_bo')]),
        (topup, outputnode, [('out_fieldcoef', 'topup_fieldcoef')]),
        (topup, outputnode, [('out_field', 'topup_field')]),
        (topup, maths, [('out_corrected', 'in_file')]),
        (maths, outputnode, [('out_file', 'dwi_appa')]),
        (maths, bet, [("out_file", "in_file")]),
        (bet, outputnode, [("mask_file", "bo_brainmask")]),
        (bet, outputnode, [("out_file", "bo_brain")]),
        (bet, eddy, [("mask_file", "in_mask")]),
        (inputnode, eddy, [("bvecs", "in_bvec")]),
        (inputnode, eddy, [("bvals", "in_bval")]),
        (topup, eddy, [("out_fieldcoef", "in_topup_fieldcoef")]),
        (topup, eddy, [("out_movpar", "in_topup_movpar")]),
        (inputnode, denoise, [('dwi', 'in_file')]),
        (denoise, outputnode, [('out_file', 'dwi_denoised')]),
        (denoise, eddy, [("out_file", "in_file")]),
        (eddy, outputnode, [("out_corrected", "eddy_corr")]),
        (eddy, outputnode, [("out_parameter", "eddy_params")]),
        (eddy, outputnode, [("out_rotated_bvecs", "rotated_bvecs")]),
        (eddy, outputnode, [("out_movement_rms", "total_movement_rms")]),
        (eddy, outputnode, [("out_shell_alignment_parameters", "shell_params")]),
        (eddy, outputnode, [("out_outlier_report", "outlier_report")]),
        (eddy, outputnode, [("out_cnr_maps", "cnr_maps")]),
        (eddy, outputnode, [("out_residuals", "residuals")])

        
        ]) 
                             
                             
    return distor_correct
