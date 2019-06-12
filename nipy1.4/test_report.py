# -*- coding: utf-8 -*-
"""
Created on Tue Apr  2 14:06:57 2019

@author: fbeyer
"""

import nibabel as nb
import numpy as np
import math
from matplotlib.figure import Figure
from matplotlib.backends.backend_pdf import FigureCanvasPdf as FigureCanvas
import matplotlib.pyplot as plt
from pylab import cm

figsize=(11.7,8.3)

def _calc_rows_columns(ratio, n_images):
    rows = 1
    for _ in range(100):
        columns = math.floor(ratio * rows)
        total = rows * columns
        if total > n_images:
            break

        columns = math.ceil(ratio * rows)
        total = rows * columns
        if total > n_images:
            break
        rows += 1
    return rows, columns

nifti_file="/data/p_02030/BIDS/sub-338395e/ses-bl/anat/sub-338395e_ses-bl_FLAIR.nii.gz"
image_type="flair"
if isinstance(nifti_file,str):
    nii = nb.load(nifti_file)
    mean_data = nii.get_data()
elif isinstance(nifti_file, unicode):
    nii = nb.load(nifti_file)
    mean_data = nii.get_data()
else:
    mean_data = nifti_file

if image_type=='flair':
        n_images = mean_data.shape[0]
        step=8
        range_plot=np.arange(108,n_images,step)   
        row, col = _calc_rows_columns(figsize[0]/figsize[1], (n_images-16)/step)
        #z-direction in flair image is in y-dimension
elif image_type=='t1':
    n_images=mean_data.shape[2]
    step=4
    range_plot=np.arange(0,n_images-56,step)
    row, col = _calc_rows_columns(figsize[0]/figsize[1], (n_images-56)/step)
    #z-direction is in z-dimension
else:
    n_images=mean_data.shape[2]
    print n_images
    step=1
    row, col = _calc_rows_columns(figsize[0]/figsize[1], n_images/step)
    print row
    print col
    range_plot=np.arange(0,n_images,step)
  
ind=0
print range_plot
for image in range_plot:
    data_mask = np.logical_not(np.isnan(mean_data))
    if image_type=="flair":
        plt.imshow(mean_data[1:216,1:220,image].T, vmin=np.percentile(mean_data[data_mask], 0.5), 
                  vmax=np.percentile(mean_data[data_mask],99.5), 
                  cmap=cm.Greys_r, interpolation='nearest', origin='lower')  # @UndefinedVariable
        plt.show()