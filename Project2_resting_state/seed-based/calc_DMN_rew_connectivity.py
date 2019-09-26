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
import nipype.interfaces.fsl as fsl


###############################################################################
#THIS SCRIPT
# Specify the location of the preprocessed functional data
data_dir="/data/pt_02161/preprocessed/"
#Specify the working directory
working_dir="/data/pt_02161/wd"


#list of subjects to be run
#slist="subjectlisthere"
                   
standard_brain='/data/p_life_results/2017_beyer_rs_BMI/BMI_RSN_analysis/scripts/network_identification/MNI/MNI_brain_resampled.nii.gz'
out_dir="/data/pt_02161/preprocessed/resting/connectivity/"

#with open(slist, 'r') as f:
#    subjects = [line.strip() for line in f]
  
subjects=['ADI003_fu2','ADI003_fu','ADI004_fu2','ADI006_bl','ADI006_fu2', \
          'ADI006_fu','ADI008_bl','ADI009_bl','ADI009_fu','ADI013_bl', \
          'ADI013_fu','ADI025_bl','ADI025_fu','ADI026_bl', \
          'ADI029_fu','ADI029_fu2','ADI036_bl','ADI036_fu2','ADI041_fu', \
          'ADI045_bl','ADI045_fu','ADI045_fu2','ADI047_fu','ADI047_fu2', \
          'ADI048_bl','ADI048_fu','ADI048_fu2','ADI062_fu2','ADI064_bl', \
          'ADI068_bl','ADI068_fu','ADI068_fu2', 'ADI069_bl', 'ADI069_fu', \
          'ADI072_bl','ADI072_fu','ADI080_bl', \
          'ADI082_fu2','ADI087_fu','ADI087_fu2','ADI088_fu','ADI089_bl', \
          'ADI091_fu','ADI097_bl','ADI097_fu','ADI097_fu2','ADI102_bl', \
          'ADI102_fu','ADI107_bl','ADI107_fu','ADI118_bl','ADI124_fu2','ADI136_bl']
 
#initialize workflow    
calc_melodic = Workflow(name='calc_melodic')   
calc_melodic.base_dir = working_dir + '/' 
calc_melodic.config['execution']['crashdump_dir'] = calc_melodic.base_dir + "/crash_files"

fmni=[] 
for subj in subjects:
    fmni.append('/data/pt_02161/wd/calc_connectome/ants_registration/_subject_%s/ants_reg/mapflow/_ants_reg2/rest_denoised_highpassed_trans.nii' %(subj))

melodic = Node(fsl.model.MELODIC(approach = 'tica'), name="melodic")
melodic.inputs.in_files=fmni
melodic.inputs.mask="/data/p_life_results/2017_beyer_rs_BMI/BMI_RSN_analysis/scripts/network_identification/MNI/MNI_resampled_brain_mask.nii"


#sink to store files
sink = Node(nio.DataSink(parameterization=True,base_directory=out_dir,
substitutions=[('_subject_', '')]),
name='sink')

calc_melodic.connect([
(melodic, sink, [('out_dir', 'out_dir')]),

])


calc_melodic.run(plugin='MultiProc') 
    
