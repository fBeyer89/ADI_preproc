#!/bin/bash

##EXTRACT THE MD of the hypothalamus (correcting for third ventricle)

subjdir="/data/pt_02161/preprocessed/hypothalamus/"

free_dir="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer/"

filename="test.txt"

wd="/data/pt_02161/wd/extract_MD"

#for side in re li
#do
#echo "${side}"

#echo "SIC" "MD_median_thirdventricle_hyp_${side}_ss" "MD_mean_thirdventricle_hyp_${side}_ss" "MD_std_thirdventricle_hyp_${side}_ss" "MD_median_thirdventricle_${side}" "MD_mean_thirdventricle_${side}" "MD_std_thirdventricle_${side}" >> ${filename}

for subj in ADI014
do
for tp in fu
do 
mkdir -p ${wd}/${subj}/${tp}
mkdir -p ${subjdir}/${subj}/${tp}


##binarize the third ventricle mask
#convert mgz to nii
mri_convert -it mgz -i ${free_dir}/${subj}_${tp}.long.${subj}/mri/aseg.mgz -ot nii -o ${wd}/${subj}/${tp}/${subj}_aseg.nii.gz

#take the roi as a mask
fslmaths ${wd}/${subj}/${tp}/${subj}_aseg.nii.gz -uthr 14 -thr 14 -bin ${wd}/${subj}/${tp}/${subj}_thirdventricle.nii.gz

##combine transforms from MD to longitudinal timepoint

#unzip source
gunzip -f /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__FA.nii.gz

lta_convert --inreg /data/pt_02161/preprocessed/diffusion/dti/${subj}_${tp}/fa2anat.dat  --outlta /data/pt_02161/preprocessed/diffusion/dti/${subj}_${tp}/fa2anat.lta -src /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__FA.nii -trg /data/p_02161/ADI_studie/BIDS/derivatives/freesurfer/${subj}_${tp}/mri/norm.mgz

mri_concatenate_lta /data/pt_02161/preprocessed/diffusion/dti/${subj}_${tp}/fa2anat.lta /data/p_02161/ADI_studie/BIDS/derivatives/freesurfer/${subj}_${tp}.long.${subj}/mri/transforms/${subj}_${tp}_to_${subj}_${tp}.long.${subj}.lta ${wd}/${subj}/${tp}/${subj}_lta_final


#convert the cross-sectional MD/FA maps to the longitudinal timepoint.
mri_convert -at ${wd}/${subj}/${tp}/${subj}_lta_final /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__MD.nii ${wd}/${subj}/${tp}/${subj}_MD_${tp}.nii
mri_convert -at ${wd}/${subj}/${tp}/${subj}_lta_final /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__FA.nii ${wd}/${subj}/${tp}/${subj}_FA_${tp}.nii

#get average MD in third ventricle
a="`fslstats ${wd}/${subj}/${tp}/${subj}_MD_${tp}.nii -k ${wd}/${subj}/${tp}/${subj}_thirdventricle.nii.gz  -p 50 -m -s`"

set -- ${a}
echo ${2}

b="`fslstats ${wd}/${subj}/${tp}/${subj}_MD_${tp}.nii -u ${2} -k /data/pt_life_hypothalamus_segmentation/segmentation/Subjects/${subj}/hypoth/${subj}_hyp_${side}_swapped_RAS.nii.gz -p 50 -m -s`" #-V

#echo $subj $a >> ${filename_v}
#echo $subj $b >> ${filename_h}

#rm -rf /data/pt_life_hypothalamus_segmentation/segmentation/Subjects/${subj}/hypoth/DWI_newpreprocessing/Third_ventricle

gzip /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__FA.nii
rm -rf /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__FA.nii

done 
done

