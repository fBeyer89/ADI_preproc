#!/bin/bash


#update recons for all subjects with corrections
for subj in 
do
recon-all -make all -subjid $subj
done
