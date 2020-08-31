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
from nilearn_sc_SpheresMasker import calc_sc_sphere
###############################################################################
#THIS SCRIPT calculate connectivity of DMN from Power coordinates

# Specify the location of the preprocessed functional data
data_dir="/data/pt_02161/preprocessed/"
#Specify the working directory
working_dir="/data/pt_02161/wd"


#list of subjects to be run
slist="/data/pt_02161/Analysis/Preprocessing/qa/rs_qa/all_ADI_for_rsqc.txt"
                   
standard_brain='/data/p_life_results/2017_beyer_rs_BMI/BMI_RSN_analysis/scripts/network_identification/MNI/MNI_brain_resampled.nii.gz'
out_dir="/data/pt_02161/Results/Project2_resting_state/connectivity/"

with open(slist, 'r') as f:
    subjects = [line.strip() for line in f]

#get DMN coordinates to calculate average DMN connectivity
coords_file=pd.read_csv("/data/pt_02161/Analysis/Project2_resting_state/seed-based/Neuron_consensus_264_Power_2011.csv",  delimiter=",", header=1)    
DMN_coords=[]
Sal_coords=[]
for i in np.arange(0,len(coords_file)):
    if coords_file['Suggested System'][i]=="Default mode":
        t=coords_file.iloc[i,6:9]
        t=tuple(t)
        DMN_coords.append(t)
    if coords_file['Suggested System'][i]=="Salience":
        t=coords_file.iloc[i,6:9]
        t=tuple(t)
        Sal_coords.append(t)    
coords_labels_DMN=np.array([np.arange(0,len(DMN_coords))])       
coords_labels_Sal=np.array([np.arange(0,len(Sal_coords))])         
 ###################################   
#initialize workflow    
calc_DMN = Workflow(name='calc_DMN')   
calc_DMN.base_dir = working_dir + '/' 
calc_DMN.config['execution']['crashdump_dir'] = calc_DMN.base_dir + "/crash_files"

#first load functional data transformed to MNI space 
#We evaluated QC-FC relationships within two commonly-used whole-brain networks, the first consisting of spherical nodes distributed across the brain (Power et al., 2011) and the second comprising an areal parcellation of the cerebral cortex (Gordon et al., 2016). For each network, the mean time series for each node was calculated from the denoised residual data, and the pairwise Pearson correlation coefficient between node time series was used as the network edge weight (Biswal et al., 1995). For each edge, we then computed the correlation between the weight of that edge and the mean relative RMS motion. To eliminate the potential influence of demographic factors, QC-FC relationships were calculated as partial correlations that accounted for participant age and sex. We thus obtained, for each de-noising pipeline, a distribution of QC-FC correlations.
info = dict(
       rest=[['/resting/rest2MNI/','subject','/min_preproc/rest2anat_trans.nii']], 
       ica_aroma=[['/resting/rest2MNI/','subject','/aroma/denoised_func_data_nonaggr_trans.nii']],
       rest_cc=[['/resting/rest2MNI/','subject','/cc/rest_denoised_highpassed_trans.nii']],
       rest_cc_gsr=[['/resting/rest2MNI/','subject','/gsr/rest_denoised_highpassed_trans.nii']],
       )   
datasource = Node(
    interface=nio.DataGrabber(infields=['subject'], outfields=[ 'rest','ica_aroma','rest_cc','rest_cc_gsr']),
    name='datasource')
datasource.inputs.base_directory = data_dir
datasource.inputs.template = '%s%s%s' #MODIFY according to your datastructure.
datasource.inputs.template_args = info
datasource.inputs.sort_filelist = True   
datasource.iterables=[("subject",subjects)]

def mklist(rest, ica_aroma, rest_cc, rest_cc_gsr):
    return [rest, ica_aroma, rest_cc, rest_cc_gsr]

make_list = Node(util.Function(input_names = ['rest', 'ica_aroma', 'rest_cc', 'rest_cc_gsr'],
                                output_names = ['rest_list'],
                                function = mklist),
                    name='make_list') 
       
# Create the sca_MNI_coords Node, as output nifti file 
ts_conn = Node(util.Function(input_names = ['in_file', 'coords',
                                                'coords_labels',
                                                'radius'],
                                output_names = ['fn','all_fn_m'],
                                function = calc_sc_sphere),
                    name='ts_conn') 
ts_conn.inputs.coords=DMN_coords
ts_conn.inputs.coords_labels=coords_labels_DMN#, coords_labels_Sal])]
ts_conn.inputs.radius = 5 #5mm sphere because 10mm sphere causes overlap.

#sink to store files
sink = Node(nio.DataSink(parameterization=True,base_directory=out_dir,
substitutions=[('_subject_', '')]),
name='sink')

calc_DMN.connect([
(datasource, make_list, [('rest', 'rest'),
                         ('ica_aroma', 'ica_aroma'),
                         ('rest_cc', 'rest_cc'),
                         ('rest_cc_gsr', 'rest_cc_gsr')]),
(make_list, ts_conn, [('rest_list', 'in_file')]),
(ts_conn, sink, [('fn', 'PowerDMNconn.@vals')]),
(ts_conn, sink, [('all_fn_m', 'PowerDMNconn.@matrices')])
])


calc_DMN.run(plugin='MultiProc') 
