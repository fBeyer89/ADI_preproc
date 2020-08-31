#! /bin/sh

# usage: tbss_long path2Data subjectNames
# e.g.: tbss_long ~/dataPath s01 s02 s03 s04
# expects a folder in dataPath called "origData"
# "origData" should contain the data (FA-volumes) for all subjects and timepoints
# this script will create a TBSS folder in the dataPath
#

# the standard FSL dti-commands (eddy current correctoin and dtifit) have
# to be performed prior to the execution of this script
# smoothing before running dtifit can be performed e.g. with fslmaths -fmedian

 
# dataPath
#	- origData
#			-s01_FA_TP1.nii.gz
#			-s01_FA_TP2.nii.gz
#			-s02_FA_TP1.nii.gz
#			-s02_FA_TP2.nii.gz
#			...

# set halfregPath=`dirname $0`
# set dataPath=$argv[1]
# shift
# set subj=($argv)

## set own directories:

origData="/data/pt_02161/wd/tbss/fa"
halfway_dir="/data/pt_02161/wd/tbss/halfway"
base_dir="/data/pt_02161/wd/tbss/base"
subj_list="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_bl_fu.txt"
logfiles="/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/logfiles/"

# mkdir $dataPath/TBSS
# mkdir $dataPath/TBSS/data
# mkdir $dataPath/TBSS/TP1
# mkdir $dataPath/TBSS/TP2
# 
# cd $dataPath

# calculate halfway image and calculate base images (1 per subject)
# foreach s ($subj)
date=$(date)
echo "############################" >> $logfiles/halfway_registration.log
echo "########## $date ###########" >> $logfiles/halfway_registration.log
echo "############################" >> $logfiles/halfway_registration.log

#echo "############################" >> $logfiles/tbss.log
#echo "########## $date ###########" >> $logfiles/tbss.log
#echo "############################" >> $logfiles/tbss.log

for s in ADI020 #`cat $subj_list`
do
echo "##### # calculate halfway image and calculate base images for Subject $s #####"
echo "##### # calculate halfway image and calculate base images for Subject $s #####" >> $logfiles/halfway_registration.log
# 	cp $dataPath/origData/${s}* $dataPath/TBSS/data/ 
 	sh halfreg.sh $origData/${s}_FA_bl.nii.gz $origData/${s}_FA_fu.nii.gz $halfway_dir/${s}_FA_bl_halfway.nii.gz $halfway_dir/${s}_FA_fu_halfway.nii.gz 
 	rm mat1 mat2 halfmat1 halfmat2
 	fslmaths $halfway_dir/${s}_FA_bl_halfway.nii.gz -add $halfway_dir/${s}_FA_fu_halfway.nii.gz -div 2 $base_dir/${s}_FA_base.nii.gz >> $logfiles/halfway_registration.log
 done
 
for s in ADI020 #`cat $subj_list`
do
echo "##### rename halfway to make tbss_non_FA-conform for Subject $s #####"
        # rename halfway to make tbss_non_FA-conform
 	cp $halfway_dir/${s}_FA_bl_halfway.nii.gz $base_dir/bl/${s}_FA_base.nii.gz
 	cp $halfway_dir/${s}_FA_fu_halfway.nii.gz $base_dir/fu/${s}_FA_base.nii.gz
 done

#echo "##### run regular tbss routine #####"
#echo "##### run regular tbss routine #####" >> $logfiles/tbss.log
## run regular tbss routine
#cd $base_dir 
#tbss_1_preproc *.nii.gz >> $logfiles/tbss.log
#tbss_2_reg -T >> $logfiles/tbss.log
#tbss_3_postreg -S >> $logfiles/tbss.log
#tbss_4_prestats 0.2 >> $logfiles/tbss.log

#echo "##### run tbss with halfway warping #####"
#echo "##### run tbss with halfway warping #####"  >> $logfiles/tbss.log
## run tbss with halfway warping
#tbss_non_FA bl >> $logfiles/tbss.log
#tbss_non_FA fu >> $logfiles/tbss.log
