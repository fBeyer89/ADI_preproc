#! /bin/tcsh
### PREREQUISITES: FSL environment

# statsdir="/data/pt_02161/wd/tbss/base/stats/"
statsdir="/data/pt_02161/wd/tbss/base_bl_fu2/stats/"
logfiles="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/logfiles/"

date=$(date)
echo "############################" >> $logfiles/tbss.log
echo "########## $date ###########" >> $logfiles/tbss.log
echo "############################" >> $logfiles/tbss.log

# echo "#### erode mean fa remove skull leftovers twice #####"
# echo "#### erode mean fa remove skull leftovers twice #####" >> $logfiles/tbss.log
# 
# fslmaths $statsdir/mean_FA.nii.gz -fillh -nan -ero $statsdir/mean_FA_eroded.nii.gz >> $logfiles/tbss.log
# fslmaths $statsdir/mean_FA_eroded.nii.gz -nan -ero $statsdir/mean_FA_eroded_twice.nii.gz >> $logfiles/tbss.log


echo "#### erode mean fa mask to remove skull leftovers #####"
echo "#### erode mean fa mask to remove skull leftovers #####" >> $logfiles/tbss.log

fslmaths $statsdir/mean_FA_mask.nii.gz -fillh -nan -ero $statsdir/mean_FA_mask_eroded.nii.gz >> $logfiles/tbss.log

echo "#### erode mean fa mask to remove skull leftovers ! a second time !#####"
echo "#### erode mean fa mask to remove skull leftovers ! a second time !#####" >> $logfiles/tbss.log

fslmaths $statsdir/mean_FA_mask_eroded.nii.gz -nan -ero $statsdir/mean_FA_mask_eroded_twice.nii.gz >> $logfiles/tbss.log


echo "#### apply mean_FA_mask_eroded_twice on mean_FA_skeleton_mask #####"
echo "#### apply mean_FA_mask_eroded_twice on mean_FA_skeleton_mask #####" >> $logfiles/tbss.log

fslmaths $statsdir/mean_FA_skeleton_mask.nii.gz -mas $statsdir/mean_FA_mask_eroded_twice.nii.gz $statsdir/mean_FA_skeleton_mask_eroded.nii.gz >> $logfiles/tbss.log

