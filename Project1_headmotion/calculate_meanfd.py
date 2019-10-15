#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Aug  1 10:23:56 2019
Calculate mean and max FD for ADI Study
@author: fbeyer
"""

import numpy as N
import pandas as pd
import os,sys
import matplotlib.pyplot as plt

#FUNCTION DEFINITION
def compute_fd(motpars,func):

    # compute absolute displacement
    dmotpars=N.zeros(motpars.shape)
    
    dmotpars[1:,:]=N.abs(motpars[1:,:] - motpars[:-1,:])
    
    print "analysis type = %s" %func
    # convert rotation to displacement on a 50 mm sphere
    # mcflirt returns rotation in radians
    # from Jonathan Power:
    #The conversion is simple - you just want the length of an arc that a rotational
    # displacement causes at some radius. Circumference is pi*diameter, and we used a 5
    # 0 mm radius. Multiply that circumference by (degrees/360) or (radians/2*pi) to get the 
    # length of the arc produced by a rotation.
    
    #SUITABLE for mcflirt/3dvolreg-output
    #[0:3]-> rotational parameters
    #[3:6]-> translational paramters
    #SWAP ORDER FOR MATLAB
    headradius=50
    disp=dmotpars.copy()
    if func=='fsl':
        disp[:,0:3]=N.pi*headradius*2*(disp[:,0:3]/(2*N.pi))#rotation in radians, default: register to middle volume
    elif func=='afni':
        disp[:,0:3]=N.pi*headradius*2*(disp[:,0:3]/(360))#rotation in degree, default: registration to first subbrick (https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dvolreg.html)
    elif func=='mat':
        disp[:,3:6]=N.pi*headradius*2*(disp[:,3:6]/(360))#rotation in degree, default: register to mean
    else: print "undefined preprocessing type"
    FD=N.sum(disp,1)
    
    return FD

#FOR A list of subjects
adi=pd.read_csv("/data/pt_02161/Results/Project1_headmotion/results/subjects_rs.csv")
subjects_list=adi['x']
func="fsl" #select preprocessing type: afni, fsl or mat for MATLAB
#with open(subjects_file, 'r') as f:
#    subjects_list = [line.strip() for line in f]
#subjects_list = filter(None,subjects_list)

#Array to store the mean and max FD values for all subjects and timepoints
summaryFD=N.zeros(shape=(N.size(subjects_list),6))
i=0
for subj in subjects_list:
    j=0
    for tp in ['bl','fu','fu2']:
        #LOAD THE FILE
        fname='/data/pt_02161/wd/hcp_prep/resting/motion_correction/_subject_%s_%s/mcflirt/rest_realigned.nii.gz.par' %(subj,tp)
        print fname
        if os.path.isfile(fname):
            motpars=N.loadtxt(fname)

            #
            #COMPUTE FD
            FD=compute_fd(motpars,func)
                
            #CALCULATE mean and max FD
            meanFD=N.mean(FD)
            maxFD=N.max(FD)
            
            #return min and max FD
            print meanFD
            print maxFD
            
            summaryFD[i,j+0]=meanFD
            summaryFD[i,j+1]=maxFD
        j+=2
    i+=1
print summaryFD
N.savetxt('/data/pt_02161/Results/Project1_headmotion/results/summary_FDvals.csv',summaryFD, delimiter=",")