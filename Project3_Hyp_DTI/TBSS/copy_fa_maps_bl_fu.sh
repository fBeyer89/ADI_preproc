#! /bin/bash


# subj_list="subjects_bl_fu.txt"
subj_list="subjects_bl_fu_fu2.txt"
orig_dir="/data/pt_02161/preprocessed/diffusion/dti"
tbss_dir="/data/pt_02161/wd/tbss/fa"


for subj in ` cat $subj_list`
do

# cp $orig_dir/$subj*_bl/dtifit_FA.nii.gz $tbss_dir/${subj}_FA_bl.nii.gz 
# cp $orig_dir/$subj*_fu/dtifit_FA.nii.gz $tbss_dir/${subj}_FA_fu.nii.gz 
cp $orig_dir/$subj*_fu2/dtifit_FA.nii.gz $tbss_dir/${subj}_FA_fu2.nii.gz 


done
