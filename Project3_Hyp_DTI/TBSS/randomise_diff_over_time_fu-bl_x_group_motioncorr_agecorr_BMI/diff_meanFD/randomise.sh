#! /bin/tcsh

### PREREQUISITES: FSL environment

stats_dir="/data/pt_02161/wd/tbss/base/stats"
logfiles="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/logfiles"
subj_list="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_bl_fu.txt"
scripts_dir="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD"

### create logfile for randomise ###
date=$(date)

echo "############################" >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log
echo "########## $date ###########" >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log
echo "############################" >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log

echo "##### run tbss randomise: FU-BL x group motion corrected (diff meanFD) and age corrected and corrected for BMI #####"
echo "##### run tbss randomise: FU-BL x group motion corrected (diff meanFD) and age corrected and corrected for BMI #####" >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log


cd $stats_dir 
randomise -i all_fu-bl_skeletonised_eroded.nii.gz -o diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/two_samples_ttest -d $scripts_dir/design.mat -t $scripts_dir/contrasts.con -n 5000 --T2 -x --uncorrp >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log


## FDR correction ##

##Output from randomise can be fed directly into fdr; use the voxel-based thresholding, uncorrected for multiple comparisons, i.e. a *_vox_p_tstat* image. This images stores values as 1-p rather than p (where p is the p-value from 0 to 1). That is, 1 is most significant in a 1-p image (and it is arranged this way to make display and thresholding simple). Therefore fdr needs to know that it is a 1-p image. Thus an example would be:
## where the input image, grot_vox_p_tstat1, contains 1-p values, as output by randomise. Note that the name of this image should be changed to whatever you have called your image.

echo "##### run fdr correction with q=0.05, two_samples_ttest_tfce_p_tstat1 #####"
echo "##### run fdr correction with q=0.05, two_samples_ttest_tfce_p_tstat1 #####" >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log

fdr -i diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/two_samples_ttest_tfce_p_tstat1 --oneminusp -q 0.05 -a diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/fdr_adj_two_samples_ttest_tfce_p_tstat1 --othresh=diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/fdr_thresh_two_samples_ttest_tfce_p_tstat1 -v >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log

## The output from fdr gives you a p-value threshold (not a 1-p value) that can be applied to the p-values, as well as a thresholded image, thresh_grot_vox_p_tstat1, where all non-significant voxels are given a value of 1-p=0 and significant voxels still contain the original 1-p values. 
 


echo "##### run fdr correction with q=0.05, two_samples_ttest_tfce_p_tstat2 #####"
echo "##### run fdr correction with q=0.05, two_samples_ttest_tfce_p_tstat2 #####" >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log

fdr -i diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/two_samples_ttest_tfce_p_tstat2 --oneminusp -q 0.05 -a diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/fdr_adj_two_samples_ttest_tfce_p_tstat2 --othresh=diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/fdr_thresh_two_samples_ttest_tfce_p_tstat2 -v >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log



# # echo "##### run fdr correction with q=0.05, two_samples_ttest_vox_p_tstat1 #####"
# # echo "##### run fdr correction with q=0.05, two_samples_ttest_vox_p_tstat1 #####" >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log
# # 
# # fdr -i diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/two_samples_ttest_vox_p_tstat1 --oneminusp -q 0.05 -a diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/fdr_adj_two_samples_ttest_vox_p_tstat1 --othresh=diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/fdr_thresh_two_samples_ttest_vox_p_tstat1 -v >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log
# # 
# # echo "##### run fdr correction with q=0.05, two_samples_ttest_vox_p_tstat2 #####"
# # echo "##### run fdr correction with q=0.05, two_samples_ttest_vox_p_tstat2 #####" >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log
# # 
# # fdr -i diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/two_samples_ttest_vox_p_tstat2 --oneminusp -q 0.05 -a diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/fdr_adj_two_samples_ttest_vox_p_tstat2 --othresh=diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI/diff_meanFD/fdr_thresh_two_samples_ttest_vox_p_tstat2 -v >> $logfiles/randomise_diff_over_time_fu-bl_x_group_motioncorr_agecorr_BMI.log

