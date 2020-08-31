#! /bin/tcsh

### PREREQUISITES: FSL environment

stats_dir="/data/pt_02161/wd/tbss/base/stats"
logfiles="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/logfiles"
scripts_dir="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr"

### create logfile for randomise ###
date=$(date)

echo "############################" >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log
echo "########## $date ###########" >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log
echo "############################" >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log


# echo "##### calculate FA differences FU-BL for each subject, IG separately #####"
# echo "##### calculate FA differences FU-BL for each subject, IG separately   #####" >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log
# 
# fslmaths $stats_dir/all_fu_IG_skeletonised.nii.gz -sub $stats_dir/all_bl_IG_skeletonised.nii.gz $stats_dir/all_fu-bl_IG_skeletonised.nii.gz >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log
# 
# echo "#### apply mean_FA_mask_eroded_twice on all_fu-bl_IG_skeletonised #####"
# echo "#### apply mean_FA_mask_eroded_twice on all_fu-bl_IG_skeletonised #####" >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log
# 
# fslmaths $stats_dir/all_fu-bl_IG_skeletonised.nii.gz -mas $stats_dir/mean_FA_mask_eroded_twice.nii.gz $stats_dir/all_fu-bl_IG_skeletonised_eroded.nii.gz >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log

# echo "##### run tbss randomise: FU-BL in IG, motion corrected (diff meanFD) and age corrected  #####"
# echo "##### run tbss randomise: FU-BL in IG, motion corrected (diff meanFD) and age corrected  #####" >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log
# 

cd $stats_dir 
randomise -i $stats_dir/all_fu-bl_IG_skeletonised_eroded.nii.gz -o diff_over_time_fu-bl_IG_motioncorr_agecorr/one_sample_ttest -d $scripts_dir/design.mat -t $scripts_dir/contrasts.con -n 5000 --T2 -x --uncorrp >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log

echo "##### run fdr correction with q=0.05, one_sample_ttest_tfce_p_tstat1 #####"
echo "##### run fdr correction with q=0.05, one_sample_ttest_tfce_p_tstat1 #####" >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log

fdr -i diff_over_time_fu-bl_IG_motioncorr_agecorr/one_sample_ttest_tfce_p_tstat1 --oneminusp -q 0.05 -a diff_over_time_fu-bl_IG_motioncorr_agecorr/fdr_adj_one_sample_ttest_tfce_p_tstat1 --othresh=diff_over_time_fu-bl_IG_motioncorr_agecorr/fdr_thresh_one_sample_ttest_tfce_p_tstat1 -v >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log

echo "##### run fdr correction with q=0.05, one_sample_ttest_tfce_p_tstat2 #####"
echo "##### run fdr correction with q=0.05, one_sample_ttest_tfce_p_tstat2 #####" >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log


fdr -i diff_over_time_fu-bl_IG_motioncorr_agecorr/one_sample_ttest_tfce_p_tstat2 --oneminusp -q 0.05 -a diff_over_time_fu-bl_IG_motioncorr_agecorr/fdr_adj_one_sample_ttest_tfce_p_tstat2 --othresh=diff_over_time_fu-bl_IG_motioncorr_agecorr/fdr_thresh_one_sample_ttest_tfce_p_tstat2 -v >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log


echo "##### run fdr correction with q=0.05, one_sample_ttest_vox_p_tstat1 #####"
echo "##### run fdr correction with q=0.05, one_sample_ttest_vox_p_tstat1 #####" >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log

fdr -i diff_over_time_fu-bl_IG_motioncorr_agecorr/one_sample_ttest_vox_p_tstat1 --oneminusp -q 0.05 -a diff_over_time_fu-bl_IG_motioncorr_agecorr/fdr_adj_one_sample_ttest_vox_p_tstat1 --othresh=diff_over_time_fu-bl_IG_motioncorr_agecorr/fdr_thresh_one_sample_ttest_vox_p_tstat1 -v >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log

echo "##### run fdr correction with q=0.05, one_sample_ttest_vox_p_tstat2 #####"
echo "##### run fdr correction with q=0.05, one_sample_ttest_vox_p_tstat2 #####" >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log


fdr -i diff_over_time_fu-bl_IG_motioncorr_agecorr/one_sample_ttest_vox_p_tstat2 --oneminusp -q 0.05 -a diff_over_time_fu-bl_IG_motioncorr_agecorr/fdr_adj_one_sample_ttest_vox_p_tstat2 --othresh=diff_over_time_fu-bl_IG_motioncorr_agecorr/fdr_thresh_one_sample_ttest_vox_p_tstat2 -v >> $logfiles/randomise_diff_over_time_fu-bl_IG_motioncorr_agecorr.log

