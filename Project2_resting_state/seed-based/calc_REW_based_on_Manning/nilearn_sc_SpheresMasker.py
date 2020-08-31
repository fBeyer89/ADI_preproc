def calc_sc_sphere(in_file, coords, coords_labels ,radius):
                      
    from nilearn.input_data import NiftiMasker,  NiftiSpheresMasker
    from nilearn.connectome import ConnectivityMeasure
    from nilearn import plotting
    import matplotlib.pyplot as plt
    import numpy as np
    import os   
    
    # probabilistic seed regions, 4d nifti file &  corresponding labels
    coords = coords
    coords_labels = coords_labels
    
    # extract time series from coords 
    seed_masker = NiftiSpheresMasker(coords, allow_overlap=True, radius = radius,
                                     standardize=True,
                                     memory='nilearn_cache', 
                                     memory_level=5, verbose=5)

    ndiagonal=np.shape(coords_labels)[1]*(np.shape(coords_labels)[1]-1)/2
    print(ndiagonal)
    connvals=np.zeros(shape=(1,len(in_file))) 
    all_fn_m=[]        
    for i in np.arange(0,len(in_file)):
        #print in_file[i]
        seed_time_series = seed_masker.fit_transform(in_file[i])   
        
        #debug check
        #plt.plot(seed_time_series[1:5])
        #plt.title('all')
        #plt.show()
        # check if length of coords_labels is equal to number of seed time series 
        # (dependend on number of coordinate sets given with "coords") 
        # break if not equal
        if np.shape(coords_labels)[1] == seed_time_series.shape[1]:
            
            #corr_maps_dict = dict.fromkeys(coords_labels)
    
            flat_connectivity=ConnectivityMeasure(kind='correlation',vectorize=True, discard_diagonal=True)
            flat_conns = flat_connectivity.fit_transform([seed_time_series])[0] 
            print(np.mean(flat_conns))
                
            
            connectivity_measure = ConnectivityMeasure(kind='correlation')
            correlation_matrix = connectivity_measure.fit_transform([seed_time_series])[0]        
            #plot the matrix just for fun
            fig = plt.figure(figsize=(10, 7))
            fig.add_subplot(1,1,1)
            plotting.plot_matrix(correlation_matrix, vmin=-1., vmax=1., colorbar=True,
                     title='Power correlation matrix')

            fn_m=os.getcwd()+'/connmatrix_%i.png' %(i)
            plt.savefig(fn_m)
            all_fn_m.append(fn_m)
            
            #average connectivity of all DMN nodes
            connvals[0,i]=np.mean(flat_conns)
        else :
            print("#####################################################################################")
            print("#####################################################################################")
            print("Number of labels in prob_masks_labels and volumes in prob_masks does not match!!!!!!!")
            print("#####################################################################################")
            print("#####################################################################################") 
    fn=os.getcwd()+'/connvals_DMN.txt'
    np.savetxt(fn, connvals,  delimiter=',', header="meanDMN_min,meanDMN_aroma,meanDMN_cc,meanDMN_cc_gsr", newline='\n', fmt='%.5f')
    return fn, all_fn_m
            
   
