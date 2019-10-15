#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 13 08:53:54 2019

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
from nilearn_sc_SpheresMasker import calc_sc_sphere
###############################################################################
#THIS SCRIPT calculate connectomes for QC-FC analysis

# Specify the location of the preprocessed functional data
data_dir="/data/pt_02161/preprocessed/"
#Specify the working directory
working_dir="/data/pt_02161/wd"


#list of subjects to be run
slist="/data/pt_02161/Analysis/Preprocessing/qa/rs_qa/all_ADI_for_rsqc.txt"
                   
standard_brain='/data/p_life_results/2017_beyer_rs_BMI/BMI_RSN_analysis/scripts/network_identification/MNI/MNI_brain_resampled.nii.gz'
out_dir="/data/pt_02161/preprocessed/resting/"

with open(slist, 'r') as f:
    subjects = [line.strip() for line in f]

#subjects=['ADI013_fu2']
 
#264 MNI coordinates to calculate functional connectome from
coords_file=pd.read_csv("/data/pt_02161/Analysis/Preprocessing/qa/rs_qa/calc_connectome/Power_264nodes_MNI.csv",  delimiter=",", header=1)    
coords=[]
for i in np.arange(0,len(coords_file)):
    t=coords_file.iloc[i,1:]
    t=tuple(t)
    coords.append(t)
    
coords_labels=np.array([np.arange(0,len(coords_file))])
 ###################################   
#initialize workflow    
calc_connectome = Workflow(name='calc_connectome')   
calc_connectome.base_dir = working_dir + '/' 
calc_connectome.config['execution']['crashdump_dir'] = calc_connectome.base_dir + "/crash_files"


#first load functional data + transform parameters to MNI space 
#We evaluated QC-FC relationships within two commonly-used whole-brain networks, the first consisting of spherical nodes distributed across the brain (Power et al., 2011) and the second comprising an areal parcellation of the cerebral cortex (Gordon et al., 2016). For each network, the mean time series for each node was calculated from the denoised residual data, and the pairwise Pearson correlation coefficient between node time series was used as the network edge weight (Biswal et al., 1995). For each edge, we then computed the correlation between the weight of that edge and the mean relative RMS motion. To eliminate the potential influence of demographic factors, QC-FC relationships were calculated as partial correlations that accounted for participant age and sex. We thus obtained, for each de-noising pipeline, a distribution of QC-FC correlations.
info = dict(
       rest_cc=[['/resting/aroma/','subject','/highpass_compcor/rest_denoised_highpassed.nii']], 
       rest_cc_gsr=[['/resting/aroma/','subject','/highpass_compcor_gsr/rest_denoised_highpassed.nii']], 
       rest=[['/resting/transform_ts/','subject','/rest2anat.nii.gz']],
       ica_aroma=[['/resting/aroma/','subject','/denoised_func_data_nonaggr.nii.gz']],
       ants_affine=[['/structural/','subject','/transform0GenericAffine.mat']],
       ants_warp=[['/structural/','subject','/transform1Warp.nii.gz']]
       )   

datasource = Node(
    interface=nio.DataGrabber(infields=['subject'], outfields=['rest_cc', 'rest_cc_gsr', 'rest', 'ica_aroma', 'ants_affine', 'ants_warp']),
    name='datasource')
datasource.inputs.base_directory = data_dir
datasource.inputs.template = '%s%s%s' #MODIFY according to your datastructure.
datasource.inputs.template_args = info
datasource.inputs.sort_filelist = True   
datasource.iterables=[("subject", subjects)]

def mklist(rest, ica_aroma, rest_cc, rest_cc_gsr):
    return [rest, ica_aroma, rest_cc, rest_cc_gsr]

make_list = Node(util.Function(input_names = ['rest', 'ica_aroma', 'rest_cc', 'rest_cc_gsr'],
                                output_names = ['rest_list'],
                                function = mklist),
                    name='make_list') 
       
#workflow to tranform functional images to to MNI space
ants_registration=create_ants_registration_pipeline()
ants_registration.inputs.inputnode.ref=standard_brain 
    

# Create the sca_MNI_coords Node, as output nifti file 
ts_conn = Node(util.Function(input_names = ['in_file', 'coords',
                                                'coords_labels',
                                                'radius'],
                                output_names = ['all_fn_m', 'fn'],
                                function = calc_sc_sphere),
                    name='ts_conn') 
ts_conn.inputs.coords = coords
ts_conn.inputs.coords_labels = coords_labels
ts_conn.inputs.radius = 5 #5mm sphere because 10mm sphere causes overlap.

#sink to store files
sink = Node(nio.DataSink(parameterization=True,base_directory=out_dir,
substitutions=[('_subject_', ''),
               ('_ants_reg0', 'min_preproc'),
               ('_ants_reg1', 'aroma'),
               ('_ants_reg2', 'cc'),
               ('_ants_reg3', 'gsr')]),
name='sink')

calc_connectome.connect([
(datasource, make_list, [('rest', 'rest'),
                         ('rest_cc', 'rest_cc'),
                         ('rest_cc_gsr', 'rest_cc_gsr'),
                         ('ica_aroma', 'ica_aroma')]),
(make_list, ants_registration, [('rest_list', 'inputnode.func')]),
(datasource, ants_registration, [('ants_affine', 'inputnode.ants_affine')] ),
(datasource, ants_registration, [('ants_warp', 'inputnode.ants_warp')]),
(ants_registration, ts_conn, [('outputnode.func_MNI', 'in_file')]),
(ts_conn, sink, [('fn', 'detailedQA/Power264conn.@connvals')]),
(ts_conn, sink, [('all_fn_m', 'detailedQA/Power264conn.@connmats')]),
(ants_registration, sink, [('outputnode.func_MNI', 'rest2MNI')])
])


calc_connectome.run(plugin='MultiProc') 
    
