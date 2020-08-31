#! /bin/tcsh

### PREREQUISITES: FSL environment

# stats_dir="/data/pt_02161/wd/tbss/base/stats"
stats_dir="/data/pt_02161/wd/tbss/base_bl_fu2/stats"
logfiles="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/logfiles"
subj_list="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_IG_for_randomise_incl_fu2.txt"
scripts_dir="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/"

### create logfile for randomise ###
date=$(date)

echo "############################" >> $logfiles/split_IG_KG.log
echo "########## $date ###########" >> $logfiles/split_IG_KG.log
echo "############################" >> $logfiles/split_IG_KG.log

echo "############################" >> $logfiles/split_IG_KG.log
echo "########## BL + FU2 ###########" >> $logfiles/split_IG_KG.log
echo "############################" >> $logfiles/split_IG_KG.log

echo "######split all_bl_skeletonised#######" >> $logfiles/split_IG_KG.log
mkdir -p $stats_dir/all_bl_skeletonised/
fslsplit $stats_dir/all_bl_skeletonised.nii.gz $stats_dir/all_bl_skeletonised/ -t >> $logfiles/split_IG_KG.log

# echo "######split all_fu_skeletonised#######" >> $logfiles/split_IG_KG.log
# mkdir -p $stats_dir/all_fu_skeletonised/
# fslsplit $stats_dir/all_fu_skeletonised.nii.gz $stats_dir/all_fu_skeletonised/ -t >> $logfiles/split_IG_KG.log

echo "######split all_fu2_skeletonised#######" >> $logfiles/split_IG_KG.log
mkdir -p $stats_dir/all_fu2_skeletonised/
fslsplit $stats_dir/all_fu2_skeletonised.nii.gz $stats_dir/all_fu2_skeletonised/ -t >> $logfiles/split_IG_KG.log

mkdir -p $stats_dir/all_bl_skeletonised/IG
mkdir -p $stats_dir/all_bl_skeletonised/KG
# mkdir -p $stats_dir/all_fu_skeletonised/IG
# mkdir -p $stats_dir/all_fu_skeletonised/KG
mkdir -p $stats_dir/all_fu2_skeletonised/IG
mkdir -p $stats_dir/all_fu2_skeletonised/KG

#### bl and fu ####
# IG=(00 01 02 04 05 08 09 10 11 12 17 19 21 27)
# KG=(03 06 07 13 14 15 16 18 20 22 23 24 25 26)

#### bl and fu2#####
IG=(00 01 03 05 06 07 08 09 14 19)
KG=(02 04 10 11 12 13 15 16 17 18)

echo "###### copy into group folders IG + KG #######" >> $logfiles/split_IG_KG.log
cd $stats_dir/all_bl_skeletonised
# for no in 00 01 02 04 05 08 09 10 11 12 17 19 21 27
for no in 00 01 03 05 06 07 08 09 14 19
do
mv 00$no.nii.gz IG/
done

# for no in 03 06 07 13 14 15 16 18 20 22 23 24 25 26
for no in 02 04 10 11 12 13 15 16 17 18
do
mv 00$no.nii.gz KG/
done

# cd $stats_dir/all_fu_skeletonised
cd $stats_dir/all_fu2_skeletonised
# for no in 00 01 02 04 05 08 09 10 11 12 17 19 21 27
for no in 00 01 03 05 06 07 08 09 14 19
do
mv 00$no.nii.gz IG/
done

# for no in 03 06 07 13 14 15 16 18 20 22 23 24 25 26
for no in 02 04 10 11 12 13 15 16 17 18
do
mv 00$no.nii.gz KG/
done

echo "###### merge into new 4D volumes #######" >> $logfiles/split_IG_KG.log
fslmerge -t $stats_dir/all_bl_IG_skeletonised.nii.gz $stats_dir/all_bl_skeletonised/IG/* >> $logfiles/split_IG_KG.log
fslmerge -t $stats_dir/all_bl_KG_skeletonised.nii.gz $stats_dir/all_bl_skeletonised/KG/* >> $logfiles/split_IG_KG.log
# fslmerge -t $stats_dir/all_fu_IG_skeletonised.nii.gz $stats_dir/all_fu_skeletonised/IG/* >> $logfiles/split_IG_KG.log
# fslmerge -t $stats_dir/all_fu_KG_skeletonised.nii.gz $stats_dir/all_fu_skeletonised/KG/* >> $logfiles/split_IG_KG.log
fslmerge -t $stats_dir/all_fu2_IG_skeletonised.nii.gz $stats_dir/all_fu2_skeletonised/IG/* >> $logfiles/split_IG_KG.log
fslmerge -t $stats_dir/all_fu2_KG_skeletonised.nii.gz $stats_dir/all_fu2_skeletonised/KG/* >> $logfiles/split_IG_KG.log

rm -fr $stats_dir/all_bl_skeletonised
# rm -fr $stats_dir/all_fu_skeletonised
rm -fr $stats_dir/all_fu2_skeletonised
