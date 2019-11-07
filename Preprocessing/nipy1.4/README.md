# preproc_ADI

### Preprocessing pipelines for the ADI study

Based on the implementation of HCP pipelines for nipype (https://github.com/beOn/hcpre). Code is shared on https://github.com/fBeyer89/ADI_preproc.
`run_workflow_hcplike.py` runs the workflow defined in workflow.py. This incorporates different preprocessing blocks, which are specified in the subfolders `functional`,`structural` and `diffusion`, as well as in `interfaces.py` and `bids_conversion.py`.

To run it:
python run_workflow_hcplike.py --run -n 8 --config conf_for_ADI.conf

conf_for_ADI.conf: configuration file where only ID of participant (subjects = ['ADIXXX_XX'] should be changed.

Uses software packages:
MRICRON AFNI --version '19.1.05' ANTSENV --version '2.3.1' FSL --version '6.0.1' FREESURFER --version '6.0.0p1'

Uses python 2.7.15 with packages: (conda environment can be built from agewell_env.2.yml)

| package | version |
| ------- | -------|
|bids-validator|1.2.3|
|nibabel|2.2.0|
|nipy|0.4.1|
|nipype|1.2.0|
|nitime|0.7|
|pandas|0.23.4|
|pydicom|1.2.2|
|python|2.7.15|
|nilearn|0.5.2|                     
|niworkflows|0.8.0|                
|numpy|1.13.1|              
|pydicom|1.2.2|                
|scikit-image|0.14.2|    
|scikit-learn|0.19.0|       
|scipy|0.19.1|     
|seaborn|0.7.1|


working directory is defined in "run_workflow_hcplike.py", ll.76: working_dir="/data/pt_02161/wd" (don't change, unless directory is full)
The preprocessing is implemented similar to the HCP pipelines.

#### Preprocessing steps and outputs:

+ BIDS conversion: bring raw imaging data into BIDS format > /data/p_02161/ADI_studie/BIDS/

+ Structural preprocessing:  Freesurfer v.6.0.0rc1 + registration to MNI152 1mm space (ANTS)

**Freesurfer output** in /data/p_02161/ADI_Studie/BIDS/derivatives/freesurfer.

**Registration output** in /data/pt_02161/Data/Preprocessed/structural:

  * /X/transform_Warped.nii.gz (brain.mgz warped to MNI space)
  * /X/transform1Warp.nii.gz (Warpfield for this transform)
  * /X/transform1InverseWarp.nii.gz (inverse Warpfield for this transform)
  * /X/transform0GenericAffine.mat (affine matrix for this transform)
  * /X/T1_brain_mask.nii.gz (brainmask.mgz as nifti)
  * /X/T1.nii.gz (T1.mgz (before skullstrip) as nifti)
  * /X/brain.nii.gz (brain.mgz as nifti, input of the transform)

+ Functional (rsfMRI) preprocessing: removal of first 4 volumes, motion correction (MCFlirt), coregistration to anatomical (BBREGISTER), unwarping with fieldmaps in FUGUE, all transforms applied in a single step. smoothing with 6mm FWHM, ICA AROMA to correct for motion artifacts, regression of 5 WM/CSF compcor components and additionally global signal.

**Discussion**:

Standard in fMRIprep is to use "non-aggressive" denoising (Pruim, 2015, in the Discussion). There is ongoing discussion on whether to extract nuisance parameters (WM, CSF and global signal) before or after ICA-AROMA is applied. Here (https://github.com/poldracklab/fmriprep/issues/817) it was concluded that "non-aggressive case: Based on the notebook, my current opinion is that one should be able to the use other confounds (such as global signal) without modification even if they were derived from the non-denoised data." Yet, here (https://neurostars.org/t/ica-aroma-agg-vs-non-agg/3708/8) it was mentioned that "Intuitively, we might expect that – in order to prevent reintroduction of such structured noise – we would want to re-extract the mean CSF, WM, and global time series after performing the nonaggressive denoising, since they will already be orthogonal to any sources of variance removed during the nonaggressive denoising step." They also show a simulation where a slight benefit for extracting nuisance before AROMA is shown (https://github.com/poldracklab/fmriprep-notebooks/blob/9933a628dfb759dc73e61701c144d67898b92de0/05%20-%20Discussion%20AROMA%20confounds%20-%20issue-817%20%5BJ.%20Kent%5D.ipynb).
Here, I implemented non-aggressive denoising + WM/CSF/GSR signals extracted from the denoised AROMA data.

**Outputs in /data/pt_02161/Data/Preprocessed/resting.**

  * unwarp
    * /X/rest_mean2fmap_unwarped.nii.gz (EPI registered to fieldmap unwarped)
    * /X/rest_mean2fmap.nii.gz (EPI registered to fielmap)
    * /X/fullwarpfield.nii.gz (Warpfield to perform transform)
  * transform_ts
    * /X/rest2anat_detrend.nii (fMRI timeseries in downsampled individual's anatomical space, detrended)
    * /X/T1_resampled.nii.gz (T1 resampled to EPI resolution
    * /X/rest_mean2anat_lowres.nii.gz (mean EPI to lowres anatomical image)
    * /X/rest2anat.nii.gz (fMRI timeseries in downsampled individual's anatomical space)
  * moco
    * /X/tsnr.nii.gz (temporal SNR image)
    * /X/rest_realigned_mean.nii.gz (average of realigned EPI timeseries)
    * /X/rest_realigned.nii.gz_rel.rms (relative rms values)
    * /X/rest_realigned.nii.gz_abs.rms (absolute rms values)
    * /X/rest_realigned.nii.gz.par (rotational and translational motion parameters from MCFLIRT)
  * anat_coreg
    * /X/rest_mean2anat_highres.nii.gz (bbregister result mean EPI to anatomical image)
    * /X/rest2anat.mat (registration matrix from bbregister)
    * /X/rest2anat.dat
  * aroma
    * /X/highpass_compcor_gsr (highpassed, compcor+gsr-regressed data)
    * /X/highpass_compcor (highpassed, compcor-regressed data)
    * /X/filter_compcor_gsr (compcor-gsr-regressed data)
    * /X/filter_compcor (compcor-regressed data)
    * /X/denoised_func_data_nonaggr.nii.gz (non-aggr denoised aroma output, used for further analysis)
    * /X/denoised_func_data_aggr.nii.gz (aggr denoised aroma output)
    * /X/brain_warped.nii (brain warped to MNI during AROMA preprocessing)
    * /X/brain_field.nii (warp field for MNI during AROMA preprocessing)
  * gift
    * /X/rest2anat_aroma_cc.nii (MNI warped, aroma+cc+highpass filtered rs-data as input for GIFT)
    * /X/rest2anat_trans.nii (MNI warped, minimally processed rs-data as input for GIFT)
  * detailedQA
    * slicesdir: overview of MNI-warped anat images (for AROMA QA)
    * Power264conn/X/connvals.txt: connectivity values from the upper triangle without diagnoal values connectivity of a 264 Node Power parcellation with radius of 5mm. For QC-FC analysis.
    * metrics/X/confounds.csv: outlier and DVARS values & metrics/X/fd.txt: framewise displacement values
    * fftplot/X/freqplot.png: fourier transform of the framewise displacement (to identify breathing artifact)
    * /X/summary_fmriplot.png: summary_fmriplot.png shows outliers (from AFNI3DOutliercount), FD and DVARS trace over all volumes. Below carpet plot of red: GM, green: WM, orange: CSF and blue: cerebellum voxels for the minimally preprocessed data.


+ Diffusion MRI preprocessing: artefacts correction including denoising (MRTrix: dwidenoise) ; distortion correction based on fieldmaps, used together with motion correction and outliner replacement (FSL: eddy); tensor model fitting (FSL: dtifit) > /data/pt_02161/Data/preprocessed/diffusion

    * /X/gre_field_mapping_2.3iso_s12_ph_fslprepared.nii.gz (fieldmap for unwarping DWI)
    * /X/DTI_9b0_23iso_86ms_TR7500_s13_merged_denoised_unringed_roi_maths_brain_mask.nii.gz (denoised, unringed, skullstripped brain mask)      
    * /X/DTI_9b0_23iso_86ms_TR7500_s13_merged_denoised_unringed_roi_maths_brain.nii.gz (denoised, unringed, skullstripped brain)
    * /X/DTI_9b0_23iso_86ms_TR7500_s13_merged_denoised.nii.gz (denoised DWI)

    * dti
       * `/X/fa2anat.mat (bbregister FA to anat reg matrix)`
       * `/X/fa2anat.dat (bbregister FA to anat reg matrix)`
       * `/X/fa2anat_bbreg.nii.gz (bbregister FA to anat reg result)`
       * `/X/dtifit__V3.nii.gz`
       * `/X/dtifit__MD.nii.gz (MD map in individual's anatomical space)`
       * `/X/dtifit__L3.nii.gz`
       * `/X/dtifit__L2.nii.gz`
       * `/X/dtifit__L1.nii.gz`
       * `/X/dtifit__V2.nii.gz`
       * `/X/dtifit__V1.nii.gz`  
       * `/X/dtifit__FA.nii.gz`  (FA map in individual's anatomical space)
    * eddy
       * /X/eddy_corrected.eddy_residuals.nii.gz (eddy residuals)
       * /X/eddy_corrected.eddy_cnr_maps.nii.gz (CNR maps from eddy)
       * /X/eddy_corrected.eddy_movement_rms (movement params)
       * /X/eddy_corrected.nii.gz (eddy result)
       * /X/eddy_corrected.eddy_rotated_bvecs (rotated bvecs)
       * /X/eddy_corrected.eddy_outlier_report
       * /X/eddy_corrected.eddy_post_eddy_shell_alignment_parameters
       * /X/dwi_appa_field.nii.gz (distortion correction field)



#### Preprocessing history

1. Some preprocessing errors were discovered for some subjects and adaptations had to be made.

  Solved "special" cases

  - ADI049_bl:  different acquisitions names, therefore `interfaces_ADI049` which has a modified NiiWrangler-interface needs to be included into the `workflow.py`/`workflow_long.py` instead of `interfaces.py` for this subject.
  - ADI041_bl and ADI088_fu2: both subjects have two rs-acquisitions. Therefore scripts were modified to merge the acquisitions.

  Nonsolvable/Problem cases

  - ADI014_bl > no T1 image
  - ADI002_fu2 > non isotropic T1
  - ADI091_fu2 > no usable sequences

  Excluded due to excessive head motion in anatomical/functional

  - ADI116_bl, ADI116_fu, ADI116_fu2
  - ADI009_fu2
  - ADI063_bl, ADI063_fu

2. visual QA of freesurfer revealed large amounts of pial included into surfaces/lot of skull in brainmask.

- manual correction of freesurfer outputs (according to Klapwijk: Quola-T-protocol)
- need accurate pial editing because skullstripped brain is used for registration in hypothalamus pipeline.
- corrected fs and rerun for certain subjects
- see /data/pt_02161/Analysis/Preprocessing/qa/README.md for details
- then freesurfer longitudinal pipeline was run and also visually checked. fs longitudinal could not be run with nipype pipeline, therefore it was started with bash-scripts in /data/pt_02161/Analysis/Preprocessing/nipy1.4/structural/longitudinal_stream/.

3. discovered error in AROMA pipeline (it used GLM estimates instead of residuals) `12.09.2019`
- corrected this and changed run_workflow to use workflow_long and aroma_long. These pipelines use ADIXXX_XX.long.ADI and not the cross-sectional run as base for the functional registration. For this purpose, run_workflow_hcplike.py imports workflow_long.py (without diffusion + BIDS), but operates on the same working directory and output.
- additionally discovered wrong registration of brain.nii.gz to MNI space in the preparation of AROMA. Therefore included reorient2std-node as a preparatory step for brain.nii.gz but also rs and rs-mask.
- changed denoising from aggressive to non-aggressive denoising according to Pruim, 2015 but kept WM/CSF/GSR calculation to be done after ICA-AROMA denoising.
- checked order of segmentation groups by modifying /home/raid1/fbeyer/local_pt_life/miniconda2/envs/py3/lib/python3.5/site-packages/niworkflows/viz/plots.py, l. 190
