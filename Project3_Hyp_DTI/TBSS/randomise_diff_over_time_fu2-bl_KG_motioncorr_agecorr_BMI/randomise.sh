#! /bin/tcsh

### PREREQUISITES: FSL environment

stats_dir="/data/pt_02161/wd/tbss/base_bl_fu2/stats"
logfiles="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/logfiles"
scripts_dir="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI"

### create logfile for randomise ###
date=$(date)

echo "############################" >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log
echo "########## $date ###########" >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log
echo "############################" >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log


echo "##### calculate FA differences FU2-BL for each subject, KG separately #####"
echo "##### calculate FA differences FU2-BL for each subject, KG separately   #####" >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log

fslmaths $stats_dir/all_fu2_KG_skeletonised.nii.gz -sub $stats_dir/all_bl_KG_skeletonised.nii.gz $stats_dir/all_fu2-bl_KG_skeletonised.nii.gz >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log

echo "#### apply mean_FA_mask_eroded_twice on all_fu2-bl_KG_skeletonised #####"
echo "#### apply mean_FA_mask_eroded_twice on all_fu2-bl_KG_skeletonised #####" >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log

fslmaths $stats_dir/all_fu2-bl_KG_skeletonised.nii.gz -mas $stats_dir/mean_FA_mask_eroded_twice.nii.gz $stats_dir/all_fu2-bl_KG_skeletonised_eroded.nii.gz >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log

echo "##### run tbss randomise: FU2-BL in KG, motion corrected (diff meanFD) and age corrected and BMI corrected #####"
echo "##### run tbss randomise: FU2-BL in KG, motion corrected (diff meanFD) and age corrected and BMI corrected #####" >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log


cd $stats_dir 
randomise -i $stats_dir/all_fu2-bl_KG_skeletonised_eroded.nii.gz -o diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI/one_sample_ttest -d $scripts_dir/design.mat -t $scripts_dir/contrasts.con -n 5000 --T2 -x --uncorrp >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log

echo "##### run fdr correction with q=0.05, one_sample_ttest_tfce_p_tstat1 #####"
echo "##### run fdr correction with q=0.05, one_sample_ttest_tfce_p_tstat1 #####" >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log

fdr -i diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI/one_sample_ttest_tfce_p_tstat1 --oneminusp -q 0.05 -a diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI/fdr_adj_one_sample_ttest_tfce_p_tstat1 --othresh=diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI/fdr_thresh_one_sample_ttest_tfce_p_tstat1 -v >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log

echo "##### run fdr correction with q=0.05, one_sample_ttest_tfce_p_tstat2 #####"
echo "##### run fdr correction with q=0.05, one_sample_ttest_tfce_p_tstat2 #####" >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log


fdr -i diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI/one_sample_ttest_tfce_p_tstat2 --oneminusp -q 0.05 -a diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI/fdr_adj_one_sample_ttest_tfce_p_tstat2 --othresh=diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI/fdr_thresh_one_sample_ttest_tfce_p_tstat2 -v >> $logfiles/randomise_diff_over_time_fu2-bl_KG_motioncorr_agecorr_BMI.log


