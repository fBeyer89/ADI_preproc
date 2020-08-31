#! /bin/tcsh

### PREREQUISITES: FSL environment

stats_dir="/data/pt_02161/wd/tbss/base/stats/"
logfiles="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/logfiles/"
subj_list="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_bl_fu.txt"
scripts_dir="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/randomise_diff_over_time_fu-bl_x_group/"

### create logfile for randomise ###
date=$(date)

echo "############################" >> $logfiles/randomise.log
echo "########## $date ###########" >> $logfiles/randomise.log
echo "############################" >> $logfiles/randomise.log


# echo "##### calculate FA differences FU-BL for each subject #####"
# echo "##### calculate FA differences FU-BL for each subject  #####" >> $logfiles/randomise.log
# 
# fslmaths $stats_dir/all_fu_skeletonised.nii.gz -sub $stats_dir/all_bl_skeletonised.nii.gz $stats_dir/all_fu-bl_skeletonised.nii.gz >> $logfiles/randomise.log
# 
# echo "#### apply mean_FA_mask_eroded_twice on all_fu-bl_skeletonised #####"
# echo "#### apply mean_FA_mask_eroded_twice on all_fu-bl_skeletonised #####" >> $logfiles/randomise.log
# 
# fslmaths $stats_dir/all_fu-bl_skeletonised.nii.gz -mas $stats_dir/mean_FA_mask_eroded_twice.nii.gz $stats_dir/all_fu-bl_skeletonised_eroded.nii.gz >> $logfiles/randomise.log

echo "##### run tbss randomise: FU-BL x group #####"
echo "##### run tbss randomise: FU-BL x group #####" >> $logfiles/randomise.log


cd $stats_dir 
randomise -i all_fu-bl_skeletonised_eroded.nii.gz -o diff_over_time_fu-bl_x_group/one_sample_ttest -d $scripts_dir/design.mat -t $scripts_dir/contrasts.con -n 1000 --T2 -x --uncorrp >> $logfiles/randomise.log
