#!/bin/bash

##EXTRACT THE MD of the hypothalamus
#including only voxels with intensities lower than the mean of third ventricle)


free_dir="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer/"

filename_hyp="/data/pt_02161/preprocessed/hypothalamus/results/hyp_md.txt"
filename_ventr="/data/pt_02161/preprocessed/hypothalamus/results/ventr_md.txt"

subjdir="/data/pt_02161/preprocessed/hypothalamus/preprocessing/extractMD/"

echo "SIC" "tp" "MD_median_hyp_re" "MD_mean_hyp_re" "MD_std_hyp_re" "MD_median_hyp_li" "MD_mean_hyp_li" "MD_std_hyp_li" >> ${filename_hyp}

echo "SIC" "tp" "MD_median_thirdventricle" "MD_mean_thirdventricle" "MD_std_thirdventricle" >> ${filename_vent}




for subj in ADI014
do
for tp in fu
do 

mkdir -p ${subjdir}/${subj}/${tp}


##binarize the third ventricle mask
#convert mgz to nii
mri_convert -it mgz -i ${free_dir}/${subj}_${tp}.long.${subj}/mri/aseg.mgz -ot nii -o ${subjdir}/${subj}/${tp}/${subj}_aseg.nii.gz

#take the roi as a mask
fslmaths ${subjdir}/${subj}/${tp}/${subj}_aseg.nii.gz -uthr 14 -thr 14 -bin ${subjdir}/${subj}/${tp}/${subj}_thirdventricle.nii.gz

##combine transforms from MD to longitudinal timepoint

#unzip source
echo /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__FA.nii.gz
gunzip -f /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__FA.nii.gz
gunzip -f /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__MD.nii.gz

lta_convert --inreg /data/pt_02161/preprocessed/diffusion/dti/${subj}_${tp}/fa2anat.dat  --outlta /data/pt_02161/preprocessed/diffusion/dti/${subj}_${tp}/fa2anat.lta -src /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__FA.nii -trg /data/p_02161/ADI_studie/BIDS/derivatives/freesurfer/${subj}_${tp}/mri/norm.mgz

mri_concatenate_lta /data/pt_02161/preprocessed/diffusion/dti/${subj}_${tp}/fa2anat.lta /data/p_02161/ADI_studie/BIDS/derivatives/freesurfer/${subj}_${tp}.long.${subj}/mri/transforms/${subj}_${tp}_to_${subj}_${tp}.long.${subj}.lta ${subjdir}/${subj}/${tp}/${subj}_lta_final


#convert the cross-sectional MD/FA maps to the longitudinal timepoint.
mri_convert -at ${subjdir}/${subj}/${tp}/${subj}_lta_final /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__MD.nii ${subjdir}/${subj}/${tp}/${subj}_MD_${tp}.nii
mri_convert -at ${subjdir}/${subj}/${tp}/${subj}_lta_final /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__FA.nii ${subjdir}/${subj}/${tp}/${subj}_FA_${tp}.nii

#get average MD in third ventricle
a="`fslstats ${subjdir}/${subj}/${tp}/${subj}_MD_${tp}.nii -k ${subjdir}/${subj}/${tp}/${subj}_thirdventricle.nii.gz  -p 50 -m -s`"

set -- ${a}
echo "threshold of ventricle: ${2}"

echo $subj ${tp} $a >> ${filename_ventr}

hyp_re="`fslstats ${subjdir}/${subj}/${tp}/${subj}_MD_${tp}.nii -u ${2} -k /data/pt_02161/preprocessed/hypothalamus/preprocessing/staple/out_label/re_${subj}_${tp}/_${subj}_${tp}/_${subj}_${tp}/staple/hyp_re.nii.gz -p 50 -m -s`" #-V

hyp_li="`fslstats ${subjdir}/${subj}/${tp}/${subj}_MD_${tp}.nii -u ${2} -k /data/pt_02161/preprocessed/hypothalamus/preprocessing/staple/out_label/li_${subj}_${tp}/_${subj}_${tp}/_${subj}_${tp}/staple/hyp_li.nii.gz -p 50 -m -s`" #-V

echo $subj ${tp} $hyp_re $hyp_li >> ${filename_hyp}

gzip /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__FA.nii
rm -rf /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__FA.nii
gzip /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__MD.nii
rm -rf /data/pt_02161/wd/hcp_prep/dwi_preproc/_subject_${subj}_${tp}/dti/dtifit__MD.nii
done 
done

