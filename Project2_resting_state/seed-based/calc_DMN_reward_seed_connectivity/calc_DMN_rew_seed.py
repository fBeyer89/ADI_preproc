#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 24 12:42:39 2019

@author: fbeyer
"""

#import from nipype and other packages
import numpy as np
import pandas as pd
import os
import sys
from nipype.pipeline.engine import MapNode, Node, Workflow
import nipype.interfaces.io as nio
from nipype.interfaces.utility import Function
import nipype.interfaces.utility as util
import nipype.interfaces.freesurfer as fs


#import from functions (should be in the same folder as labelpropagation.py)
from ants_registration import create_ants_registration_pipeline
from calc_connectivity_nilearn_LabelsMasker import calc_connectivity_LabelsMasker
###############################################################################
#THIS SCRIPT calculate connectivity of Rew/DMN from FS Desikan-Killiany &
#subcortical segmentaion

# Specify the location of the preprocessed functional data
data_dir="/data/pt_02161/preprocessed/"
#Specify the working directory
working_dir="/data/pt_02161/wd"
standard_brain='/data/p_life_results/2017_beyer_rs_BMI/BMI_RSN_analysis/scripts/network_identification/MNI/MNI_brain_resampled.nii.gz'
out_dir="/data/pt_02161/Results/Project2_resting_state/connectivity/"
fs_dir="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer/"
   
###################################   
#initialize workflow    
calc_Rew_DMN_seed = Workflow(name='calc_Rew_DMN_seed')   
calc_Rew_DMN_seed.base_dir = working_dir + '/' 
calc_Rew_DMN_seed.config['execution']['crashdump_dir'] = calc_Rew_DMN_seed.base_dir + "/crash_files"

###################################   
#List of subjects with rs- fMRI
###################################   
slist="/data/pt_02161/Analysis/Preprocessing/qa/rs_qa/all_ADI_for_rsqc.txt"                 
with open(slist, 'r') as f:
    subjects = [line.strip() for line in f]
    
#subjects=subjects[1:2]
#print subjects

identitynode = Node(util.IdentityInterface(fields=['subject']),
                name='identitynode')
identitynode.iterables = ('subject', subjects)

#Use correct subject ID from long timepoint for bbregister
def change_subject_id(subject):
    import re
    [subj,ses]=re.split("_", subject)

    new_subject_id=subject+'.long.'+subj              
    return new_subject_id

change_subject_id=Node(util.Function(input_names=["subject"],
          output_names=["new_subject_id"],
          function = change_subject_id), name="change_subject_id")

###################################   
#Load functional MRI data
###################################   

info = dict(
       rest=[['/resting/transform_ts/','subject','/rest2anat.nii.gz']], 
       ica_aroma=[['/resting/aroma/','subject','/denoised_func_data_nonaggr.nii.gz']],
       rest_cc=[['/resting/aroma/','subject','/highpass_compcor/rest_denoised_highpassed.nii']],
       rest_cc_gsr=[['/resting/aroma/','subject','/highpass_compcor_gsr/rest_denoised_highpassed.nii']],
       mask_file=[['/resting/transform_ts/','subject','/combined_brain_mask.nii.gz']],
       ants_affine=[['/structural/','subject','/transform0GenericAffine.mat']],
       ants_warp=[['/structural/','subject','/transform1Warp.nii.gz']]       
       )   
datasource = Node(
    interface=nio.DataGrabber(infields=['subject'], outfields=[ 'rest','ica_aroma','rest_cc','rest_cc_gsr']),
    name='datasource')
datasource.inputs.base_directory = data_dir
datasource.inputs.template = '%s%s%s' #MODIFY according to your datastructure.
datasource.inputs.template_args = info
datasource.inputs.sort_filelist = True   

def mklist(rest, ica_aroma, rest_cc, rest_cc_gsr):
    return [rest, ica_aroma, rest_cc, rest_cc_gsr]

make_list = Node(util.Function(input_names = ['rest', 'ica_aroma', 'rest_cc', 'rest_cc_gsr'],
                                output_names = ['rest_list'],
                                function = mklist),
                    name='make_list') 
    
###################################   
#Load FS segmentation data
###################################   
  
fs_import = Node(interface=nio.FreeSurferSource(), name = 'fs_import')
fs_import.inputs.subjects_dir=fs_dir

def get_aseg(in_list):
    l=[x for x in in_list if 'aparc+aseg.mgz' in x]
    return l[0]
get_correct_aseg=Node(util.Function(
        input_names=['in_list'],
        output_names=['out_aseg'],
        function=get_aseg), name="get_correct_aseg")

convert=Node(fs.MRIConvert(), name="convert")
convert.inputs.out_type="niigz"    

###################################   
#Get specified ROI and merge left/right hemisphere
###################################   
extract_Nacc= Node(fs.Binarize(out_type='nii.gz', binary_file='Nacc.nii.gz'),
                name='extract_Nacc')
extract_Nacc.inputs.match=[26,58]


extract_PCC= Node(fs.Binarize(out_type='nii.gz', binary_file='PCC.nii.gz'),
                name='extract_PCC')
extract_PCC.inputs.match=[1025,2025] 

###################################   
#Make list of both ROIs for FC calculation
###################################   
def mklist_roi(nacc,pcc):
    return [nacc,pcc]

make_list_roi = Node(util.Function(input_names = ['nacc','pcc'],
                                output_names = ['roi_list'],
                                function = mklist_roi),
                    name='make_list_roi') 

###################################   
#Calculate FC for both ROIs and different preprocessings
###################################  
calc_connectivity=Node(util.Function(
        input_names=['in_file', 'mask_file','label_file','in_names','label_names'],
        output_names=['res_files'],
        function=calc_connectivity_LabelsMasker), name="calc_connectivity")
calc_connectivity.inputs.in_names=['min','aroma','cc','cc_gsr']
calc_connectivity.inputs.label_names=['nacc','pcc']

###################################   
#Transform FC (raw, r-to-z-transformed) into MNI space
###################################  
ants_registration=create_ants_registration_pipeline()
ants_registration.inputs.inputnode.ref=standard_brain 


###################################   
#Sink to store files with name replacements
###################################  
sink = Node(nio.DataSink(parameterization=True,base_directory=out_dir,
substitutions=[('_subject_', ''),
               ('_ants_reg10','PCC_cc'),
               ('_ants_reg11','PCC_cc_z'),
               ('_ants_reg12','Nacc_gsr'),
               ('_ants_reg13','Nacc_gsr_z'),
               ('_ants_reg14','PCC_gsr'),
               ('_ants_reg15','PCC_gsr_z'),
               ('_ants_reg0','Nacc_min'),
               ('_ants_reg1','Nacc_min_z'),
               ('_ants_reg2','PCC_min'),
               ('_ants_reg3','PCC_min_z'),   
               ('_ants_reg4','Nacc_aroma'),
               ('_ants_reg5','Nacc_aroma_z'),               
               ('_ants_reg6','PCC_aroma'),
               ('_ants_reg7','PCC_aroma_z'),
               ('_ants_reg8','Nacc_cc'),
               ('_ants_reg9','Nacc_cc_z'),
               ]),
name='sink')

    
###################################   
#Connect workflow and run
###################################  
calc_Rew_DMN_seed.connect([
(datasource, make_list, [('rest', 'rest'),
                         ('ica_aroma', 'ica_aroma'),
                         ('rest_cc', 'rest_cc'),
                         ('rest_cc_gsr', 'rest_cc_gsr')]),
(identitynode, datasource, [('subject', 'subject')]),
(identitynode, change_subject_id, [('subject', 'subject')]),
(change_subject_id, fs_import, [('new_subject_id', 'subject_id')]),
(fs_import, get_correct_aseg, [('aparc_aseg', 'in_list')]),
(get_correct_aseg, convert,[('out_aseg', 'in_file')]),
(convert, extract_Nacc, [('out_file', 'in_file')]),
(convert, extract_PCC, [('out_file', 'in_file')]),
(extract_Nacc, make_list_roi, [('binary_file','nacc')]),
(extract_PCC, make_list_roi, [('binary_file', 'pcc')]),
(make_list_roi, calc_connectivity, [('roi_list','label_file')]),
(datasource, calc_connectivity, [('mask_file','mask_file')]),
(make_list, calc_connectivity, [('rest_list','in_file')]),
(datasource, ants_registration, [('ants_affine', 'inputnode.ants_affine')] ),
(datasource, ants_registration, [('ants_warp', 'inputnode.ants_warp')]),
(calc_connectivity, ants_registration, [('res_files', 'inputnode.func')]),
(ants_registration, sink, [('outputnode.func_MNI', 'calc_DMN_reward_seed_connectivity')])
])


calc_Rew_DMN_seed.run(plugin='MultiProc') 
