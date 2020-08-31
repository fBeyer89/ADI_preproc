def calc_connectivity_LabelsMasker(in_file, mask_file, label_file, in_names, label_names):
                      
    from nilearn.input_data import NiftiMasker, NiftiLabelsMasker
    from nilearn.connectome import ConnectivityMeasure
    from nilearn import plotting
    import matplotlib.pyplot as plt
    import numpy as np
    import os   
    
    res_files=[]
    
    for i in np.arange(0,len(in_file)):
    
        for j in np.arange(0,len(label_file)):
            masker = NiftiLabelsMasker(labels_img=label_file[j], standardize=True,
                                   memory='nilearn_cache', verbose=5)
        
            # Here we go from nifti files to the signal time series in a numpy
            # array. Note how we give confounds to be regressed out during signal
            # extraction
            time_series = masker.fit_transform(in_file[i])
            
                 
            brain_masker = NiftiMasker(
                mask_img=mask_file,
                smoothing_fwhm=None,
                #detrend=True, 
                standardize=True,
                #low_pass=0.1, high_pass=0.01, t_r=2.,
                memory='nilearn_cache', memory_level=1, verbose=0)
            
            ##########################################################################
            # Then we extract the brain-wide voxel-wise time series while regressing
            # out the confounds as before
            brain_time_series = brain_masker.fit_transform(in_file[i])
            
            
            
            seed_to_voxel_correlations = (np.dot(brain_time_series.T, time_series) /
                                      time_series.shape[0]
                                      )
            seed_to_voxel_correlations_img = brain_masker.inverse_transform(
            seed_to_voxel_correlations.T)
            
            cwd=os.getcwd()
            seed_to_voxel_correlations_img.to_filename(cwd + '/' +label_names[j]+'_'+in_names[i]+'_seed_correlation.nii.gz')   
            res_files.append(cwd + '/' +label_names[j]+'_'+in_names[i]+'_seed_correlation.nii.gz')
            ##########################################################################
            # Fisher-z transformation and save nifti
            # --------------------------------------
            # Finally, we can Fisher-z transform the data to achieve a normal distribution.
            # The transformed array can now have values more extreme than +/- 1.
            seed_to_voxel_correlations_fisher_z = np.arctanh(seed_to_voxel_correlations)
            
            
            # Finally, we can tranform the correlation array back to a Nifti image
            # object, that we can save.
            seed_to_voxel_correlations_fisher_z_img = brain_masker.inverse_transform(
                seed_to_voxel_correlations_fisher_z.T)
            
            
            
            seed_to_voxel_correlations_fisher_z_img.to_filename(cwd + '/' +label_names[j]+'_'+in_names[i]+'_seed_correlation_z.nii.gz')   
        
            res_files.append(cwd + '/' +label_names[j]+'_'+in_names[i]+'_seed_correlation_z.nii.gz' )
    return res_files
            
   
