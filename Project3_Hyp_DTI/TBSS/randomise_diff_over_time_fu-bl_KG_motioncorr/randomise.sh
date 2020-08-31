#! /bin/tcsh

### PREREQUISITES: FSL environment

stats_dir="/data/pt_02161/wd/tbss/base/stats"
logfiles="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/logfiles"
scripts_dir="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/randomise_diff_over_time_fu-bl_KG_motioncorr"

### create logfile for randomise ###
date=$(date)

echo "############################" >> $logfiles/randomise_diff_over_time_fu-bl_KG_motioncorr.log
echo "########## $date ###########" >> $logfiles/randomise_diff_over_time_fu-bl_KG_motioncorr.log
echo "############################" >> $logfiles/randomise_diff_over_time_fu-bl_KG_motioncorr.log


# echo "##### calculate FA differences FU-BL for each subject, KG separately #####"
# echo "##### calculate FA differences FU-BL for each subject, KG separately   #####" >> $logfiles/randomise_diff_over_time_fu-bl_KG_motioncorr.log
# 
# fslmaths $stats_dir/all_fu_KG_skeletonised.nii.gz -sub $stats_dir/all_bl_KG_skeletonised.nii.gz $stats_dir/all_fu-bl_KG_skeletonised.nii.gz >> $logfiles/randomise_diff_over_time_fu-bl_KG_motioncorr.log
# 
# echo "#### apply mean_FA_mask_eroded_twice on all_fu-bl_KG_skeletonised #####"
# echo "#### apply mean_FA_mask_eroded_twice on all_fu-bl_KG_skeletonised #####" >> $logfiles/randomise_diff_over_time_fu-bl_KG_motioncorr.log
# 
# fslmaths $stats_dir/all_fu-bl_KG_skeletonised.nii.gz -mas $stats_dir/mean_FA_mask_eroded_twice.nii.gz $stats_dir/all_fu-bl_KG_skeletonised_eroded.nii.gz >> $logfiles/randomise_diff_over_time_fu-bl_KG_motioncorr.log

echo "##### run tbss randomise: FU-BL in KG, motion corrected (diff meanFD) #####"
echo "##### run tbss randomise: FU-BL in KG, motion corrected (diff meanFD) #####" >> $logfiles/randomise_diff_over_time_fu-bl_KG_motioncorr.log


cd $stats_dir 
randomise -i $stats_dir/all_fu-bl_KG_skeletonised_eroded.nii.gz -o diff_over_time_fu-bl_KG_motioncorr/one_sample_ttest -d $scripts_dir/design.mat -t $scripts_dir/contrasts.con -n 5000 --T2 -x --uncorrp >> $logfiles/randomise_diff_over_time_fu-bl_KG_motioncorr.log
