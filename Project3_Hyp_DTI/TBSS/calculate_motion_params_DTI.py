# -*- coding: utf-8 -*-
"""
Created on Thu Mar  9 15:57:47 2017

@author: fbeyer

Modified on Mon Jan 06 2020

@author: thieleking
"""

#from compute_fd import compute_fd
import sys
import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

#FUNCTION DEFINITION
def compute_fd(motpars):

    # compute absolute displacement
    dmotpars=np.zeros(motpars.shape)
    
    dmotpars[1:,:]=np.abs(motpars[1:,:] - motpars[:-1,:])
    
    ## convert rotation to displacement on a 50 mm sphere
    ## mcflirt returns rotation in radians
    ## from Jonathan Power:
    ## The conversion is simple - you just want the length of an arc that a rotational
    ## displacement causes at some radius. Circumference is pi*diameter, and we used a 50mm
    ## radius. Multiply that circumference by (degrees/360) or (radians/2*pi) to get the 
    ## length of the arc produced by a rotation.
    
    #SUITABLE for mcflirt-output
    #[0:3]-> rotational parameters
    #[3:6]-> translational paramters
    #SWAP ORDER FOR AFNI
    headradius=50
    disp=dmotpars.copy()
    disp[:,0:3]=np.pi*headradius*2*(disp[:,0:3]/(2*np.pi))
    
    FD=np.sum(disp,1)
    
    return FD

subjects_directory=os.listdir("/data/pt_02161/preprocessed/diffusion/eddy/")
subject_folders=sorted(subjects_directory)
#fname='/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_bl_fu.txt'

#with open(fname, 'r') as f:
    #subjects = [line.strip() for line in f]
 # will automatically close the file after the nested block of code. 


subject_ids=np.array(['      ']*len(subject_folders)) 
subject_tps=np.array(['   ']*len(subject_folders)) 
i=0
for subject in subject_folders:
    temp=subject.split("_")
    subject_ids[i]=temp[0]
    subject_tps[i]=temp[1]
    i+=1


meanFD=np.zeros(shape=np.shape(subject_folders))  
sdFD=np.zeros(shape=np.shape(subject_folders))  
maxFD=np.zeros(shape=np.shape(subject_folders))  



i=0
for folder in subject_folders:  
    print folder
    if folder == 'ADI006_bl':
        i+=1
        continue
    
    mo_params=np.loadtxt('/data/pt_02161/preprocessed/diffusion/eddy/%s/eddy_corrected.eddy_parameters' %(folder))

### This is a text file with one row for each volume in --imain and one column for each parameter. 
### The first six columns correspond to subject movement starting with three translations followed by three rotations. 
### The remaining columns pertain to the EC-induced fields and the number and interpretation of them will depend 
### of which EC model was specified. 

    N=np.shape(mo_params)[0] #number of rows = number of volumes/diffusion directions + b0s
    mo_params_for_computing_fd=np.zeros(shape=(N,6))
    mo_params_for_computing_fd[:,0:3]=mo_params[:,3:6] #put rotational displacement in first three columns
    mo_params_for_computing_fd[:,3:6]=mo_params[:,0:3] #put translational displacement in second three columns
    
    fd = compute_fd(mo_params_for_computing_fd)
    meanFD[i]=np.mean(fd)
    sdFD[i]=np.std(fd)
    maxFD[i]=np.max(fd)
    i+=1
    
    np.savetxt('/data/pt_02161/wd/motion_FD_DWI/FD_%s.txt' %folder, fd)
    print i

df = pd.DataFrame(zip(subject_ids, subject_tps, meanFD, sdFD, maxFD), columns = ["subject_id", "tp", "meanFD", "sdFD", "maxFD"])
df_complete=df.drop(df[(df['subject_id'] == 'ADI006') & (df['tp'] == 'bl')].index)
df_complete.to_csv('/data/pt_02161/wd/motion_FD_DWI/'+"FD_all_subjects.csv", index=False)
