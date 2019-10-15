#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue May 21 10:16:37 2019
#eddy quality control
@author: fbeyer
"""
from nipype import Node, Workflow, Function
from nipype.interfaces import fsl
from nipype.interfaces.utility import IdentityInterface
import nipype.interfaces.freesurfer as fs
import nipype.interfaces.afni as afni
import nipype.interfaces.utility as util
import nipype.interfaces.io as nio    
from utils import make_the_plot, calc_frame_displacement, get_aseg, plot_fft
import numpy as np 
import nibabel as nb
import matplotlib
import matplotlib.pyplot as plt
import pandas as pd




def create_rs_qc(subjectlist):
    # main workflow for extended qc of diffusion/rsfmri data
    # fsl output type
    fsl.FSLCommand.set_default_output_type('NIFTI_GZ')
    # some hard coded things
    fd_thres=0.2
    tr=2.3

    # Specify the location of the preprocessed data    
    data_dir="/data/pt_02161/wd/hcp_prep/resting/"
    working_dir="/data/pt_02161/wd/" #MODIFY
    freesurfer_dir="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer/"
   
    qc = Workflow(name="qc")
    qc.base_dir = working_dir + '/' 
    qc.config['execution']['crashdump_dir'] = qc.base_dir + "/crash_files"
    
    #first get all data needed
    identitynode = Node(util.IdentityInterface(fields=['subject']),
                    name='identitynode')
    identitynode.iterables = ('subject', subjectlist)
    
    
    #Use correct subject ID from long timepoint for bbregister
    def change_subject_id(subject):
        import re
        [subj,ses]=re.split("_", subject)
    
        new_subject_id=subject+'.long.'+subj              
        return new_subject_id

    change_subject_id=Node(util.Function(input_names=["subject"],
              output_names=["new_subject_id"],
              function = change_subject_id), name="change_subject_id")
    

    info = dict(
       func=[['smoothing/','_subject_','subj','/smooth/rest2anat_maths_smooth.nii']],
       ica_aroma=[['','_subject_','subj','/ica_aroma/out/denoised_func_data_nonaggr.nii.gz']],
       ica_aroma_aggr=[['','_subject_','subj','/ica_aroma/out/denoised_func_data_aggr.nii.gz']],
       func_compcor_gsr=[['denoise/','_subject_','subj','/filternoise/mapflow/_filternoise0/rest2anat_denoised.nii.gz']],
       func_compcor=[['denoise/','_subject_','subj','/filternoise/mapflow/_filternoise1/rest2anat_denoised.nii.gz']],
       dvars=[['transform_timeseries/','_subject_','subj','/dvars/rest2anat_dvars.tsv']],
       motpars=[['/motion_correction/','_subject_','subj','/mcflirt/rest_realigned.nii.gz.par']],
       brainmask=[['transform_timeseries/','_subject_','subj','/resample_brain/T1_brain_mask_lowres.nii.gz']])  
    
    ds_rs = Node(
    interface=nio.DataGrabber(infields=['subj'], outfields=['func', 'dvars','motpars','brainmask']),
    name='ds_rs')    
    ds_rs.inputs.base_directory = data_dir
    ds_rs.inputs.template = '%s%s%s%s' 
    ds_rs.inputs.template_args = info
    ds_rs.inputs.sort_filelist = True   

    get_fs=Node(nio.FreeSurferSource(), name="get_fs")
    get_fs.inputs.subjects_dir=freesurfer_dir
    
    
    get_correct_aseg=Node (util.Function(
            input_names=['in_list'],
            output_names=['out_aseg'],
            function=get_aseg), name="get_correct_aseg")
    
    convert=Node(fs.MRIConvert(), name="convert")
    convert.inputs.out_type="niigz"
    
    downsample= Node(afni.Resample(resample_mode='NN',
        outputtype='NIFTI_GZ',
        out_file='aparcaseg_lowres.nii.gz'),
        name = 'downsample')
        
    
    
    
    calc_fd = Node(util.Function(
            input_names=['realignment_parameters_file', 'parameter_source'],
            output_names=['FD_power','fn'],
            function=calc_frame_displacement), name="calc_fd")
    calc_fd.inputs.parameter_source='FSL'
    
    outliers = Node(afni.OutlierCount(fraction=True, out_file='outliers.out'),
                       name='outliers', mem_gb=1 * 2.5)
    
    bigplot = Node(util.Function(
        input_names=['func_min', 'ica_aroma', 'ica_aroma_aggr','func_cc_gsr', 'func_cc', 'seg', 'tr', 'fd_thres', 'outliers', 'dvars', 'fd', 'subj','outfile'],
        output_names=['fn', 'dataframe'],
        function=make_the_plot), name="bigplot")
    bigplot.inputs.tr=tr
    bigplot.inputs.fd_thres=fd_thres
    bigplot.inputs.outfile="summary_fmriplot.png"
    
    fftplot= Node(util.Function(
        input_names=['fn_pd', 'tr'],
        output_names=['fn'],
        function=plot_fft), name="fftplot")
    fftplot.inputs.tr=tr

    
    datasink =Node(name="datasink", interface=nio.DataSink())
    datasink.inputs.base_directory="/data/pt_02161/preprocessed/resting/"
    datasink.inputs.substitutions=[('_subject_', '')]
    
    qc.connect([(identitynode, change_subject_id, [('subject', 'subject')]),
                (change_subject_id, get_fs, [('new_subject_id', 'subject_id')]),
                (identitynode, ds_rs, [('subject', 'subj')]),
                (identitynode, bigplot, [('subject', 'subj')]),
                (get_fs, get_correct_aseg, [('aparc_aseg', 'in_list')]),
                (get_correct_aseg, convert,[('out_aseg', 'in_file')]),
                (convert, downsample, [('out_file', 'in_file')]),
                (ds_rs, downsample, [('func', 'master')]),
                (downsample, bigplot, [('out_file', 'seg')]),
                (ds_rs, calc_fd, [('motpars', 'realignment_parameters_file')]),
                (ds_rs, bigplot, [('func', 'func_min')]),
                (ds_rs, bigplot, [('ica_aroma', 'ica_aroma')]),
                (ds_rs, bigplot, [('ica_aroma_aggr', 'ica_aroma_aggr')]),
                (ds_rs, bigplot, [('func_compcor_gsr', 'func_cc_gsr')]),
                (ds_rs, bigplot, [('func_compcor', 'func_cc')]),
                (ds_rs, bigplot, [('dvars', 'dvars')]),
                (calc_fd, bigplot, [('FD_power', 'fd')]),
                (ds_rs, outliers, [('func', 'in_file')]),
                (ds_rs, outliers, [('brainmask', 'mask')]),
                (outliers, bigplot, [('out_file', 'outliers')]),
                (bigplot, datasink, [('fn','detailedQA.@bigplot')]),  
                (bigplot, fftplot, [('dataframe', 'fn_pd')]),
                (bigplot, datasink, [('dataframe', 'detailedQA.metrics.@dataframe')]),
                (fftplot, datasink, [('fn', 'detailedQA.fftplot.@fft')]),
                (calc_fd, datasink, [('fn', 'detailedQA.metrics.@fd')])
                ])    


    qc.run(plugin="MultiProc", plugin_args={"n_procs" : 16, "non_daemon" : True})
    

 
    return qc



slist="/data/pt_02161/Analysis/Preprocessing/qa/rs_qa/all_ADI_for_rsqc.txt"
                   
with open(slist, 'r') as f:
    subjects = [line.strip() for line in f]

subjects=['ADI046_bl']    
qc=create_rs_qc(subjects)


#resting-state QC of those without FS edits:
#'ADI005_fu2','ADI007_bl', 'ADI014_fu', 'ADI014_fu2','ADI016_fu','ADI016_fu2', \
#       'ADI020_bl','ADI020_fu','ADI020_fu2','ADI036_fu', \
#       'ADI046_fu','ADI046_fu2','ADI049_fu','ADI049_fu2','ADI050_fu2', \
#       'ADI053_fu','ADI061_bl','ADI061_fu','ADI061_fu2', \
#       'ADI062_bl','ADI062_fu','ADI064_fu','ADI064_fu2', \
#       'ADI082_fu2','ADI087_bl','ADI088_fu2','ADI093_fu','ADI095_fu', \
#       'ADI111_bl','ADI111_fu','ADI111_fu2','ADI124_bl','ADI124_fu','ADI139_bl','ADI140_fu','ADI140_fu2'
  
#aroma did not run 'ADI053_fu2', 'ADI046_bl', 'ADI140_bl'
##'ADI003_fu2'

#the first with manual edits
#'ADI003_fu','ADI004_fu2','ADI006_bl','ADI006_fu2','ADI006_fu', \
#   'ADI008_bl','ADI009_bl','ADI009_fu','ADI013_bl','ADI013_fu','ADI025_bl', \
#   'ADI025_fu','ADI026_bl','ADI029_fu','ADI029_fu2','ADI036_bl','ADI036_fu2', \
#   'ADI041_fu','ADI045_bl','ADI045_fu','ADI045_fu2','ADI047_fu','ADI047_fu2', \
#   'ADI048_bl','ADI048_fu','ADI048_fu2','ADI062_fu2','ADI064_bl','ADI068_bl', \
#   'ADI068_fu','ADI068_fu2','ADI069_bl', 'ADI069_fu'
##the second with manual edits
#['ADI072_bl','ADI072_fu','ADI072_fu2','ADI080_bl','ADI082_fu','ADI082_fu2', \
# 'ADI087_fu','ADI087_fu2','ADI088_fu','ADI089_bl','ADI091_fu','ADI097_bl', \
# 'ADI097_fu','ADI097_fu2','ADI102_bl','ADI102_fu','ADI107_bl','ADI107_fu', \
# 'ADI118_bl','ADI124_fu2','ADI136_bl'] 

