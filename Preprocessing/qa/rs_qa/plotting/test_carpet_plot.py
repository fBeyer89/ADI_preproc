#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 24 15:12:01 2019

@author: fbeyer
"""

from niworkflows.viz.plots import plot_carpet, confoundplot
import numpy as np
import nibabel as nb
import matplotlib
matplotlib.use('TkAgg')
func_min="/data/pt_02161/wd/hcp_prep/resting/transform_timeseries/_subject_ADI003_fu/merge/rest2anat.nii.gz"
seg="/data/pt_02161/wd/qc/_subject_ADI003_fu/downsample/aparcaseg_lowres.nii.gz"
seg_file=nb.load(seg)
seg_data=seg_file.get_data()


lut=np.zeros((2036,),dtype="int")
lut[2]=2 #WM
lut[7]=2 #WM
lut[41]=2 #WM
lut[46]=2 #WM
lut[251:255]=2 #WM
lut[4]=3 #CSF
lut[43]=3 #CSF
lut[14]=3 #CSF
lut[1000:2035]=1 #cortical areas
lut[17:18]=1 #cortical areas
lut[53:54]=1 #cortical areas
lut[47]=4 # cerebellum
lut[8]=4 # cerebellum


[ax0, ax1], gs=plot_carpet(func_min, seg_data, lut=lut, tr=2)

matplotlib.pyplot.show()