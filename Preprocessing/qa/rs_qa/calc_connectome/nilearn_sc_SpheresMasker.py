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
    seed_masker = NiftiSpheresMasker(coords, radius = radius,
                                     standardize=True,
                                     memory='nilearn_cache', 
                                     memory_level=5, verbose=5)

    ndiagonal=np.shape(coords_labels)[1]*(np.shape(coords_labels)[1]-1)/2
    connvals=np.zeros(shape=(int(ndiagonal),len(in_file)))  
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
    
            connectivity_measure = ConnectivityMeasure(kind='correlation')
            correlation_matrix = connectivity_measure.fit_transform([seed_time_series])[0]        
    
            #extract values from upper triangle exclusing diagonal
            connvals[:,i]=correlation_matrix[np.triu_indices(seed_time_series.shape[1], k = 1)]
            
            #plot the matrices and save them
            connectivity_measure = ConnectivityMeasure(kind='correlation')
            correlation_matrix = connectivity_measure.fit_transform([seed_time_series])[0]        
            
            
            fig = plt.figure(figsize=(10, 7))
            fig.add_subplot(1,1,1)
            plotting.plot_matrix(correlation_matrix, vmin=-1., vmax=1., colorbar=True,
                     title='')

            fn_m=os.getcwd()+'/connmatrix_%i.png' %(i)
            plt.savefig(fn_m)
            all_fn_m.append(fn_m)
        else :
            print("#####################################################################################")
            print("#####################################################################################")
            print("Number of labels in prob_masks_labels and volumes in prob_masks does not match!!!!!!!")
            print("#####################################################################################")
            print("#####################################################################################") 
    fn=os.getcwd()+'/connvals.txt'
    np.savetxt(fn, connvals,  delimiter=',', header="connvals_min,connvals_aroma,connvals_cc,connvals_cc_gsr", newline='\n', fmt='%.5f')
    return  fn, all_fn_m
            
   
