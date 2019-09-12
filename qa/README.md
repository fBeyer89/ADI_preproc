#QA scripts for ADI study

1. fs_qa 

freesurfer qa was done according to Klapwijk et. al 2018 (see Klapwijk_QoalaT_fs_qa.pdf)
briefly, all cross-sectional runs were inspected visually with *run_freesurfer_qa.sh* according to 4 criteria:
1. Is the reconstructed image affected by movement?
2. Is (part of) the temporal pole missing in the reconstruction?
3. Is non-brain tissue (e.g. dura/skull) included in the reconstruction of pial surface (red line)?
4. Are parts of the cortex missing in the reconstruction (other than temporal poles)

These criteria were used to provide a numerical rating of overall quality (1-4: Excellent (1), Good (2), Doubtful (3), Failed(4))
This information is found in: /data/p_02161/ADI_studie/BIDS/derivatives/freesurfer/QA/freesurfer_qa_qoala_11.7.ods

Participants were corrected if they had an overall rating of 2 or 3 and correction was possible, e.g. pial or wm errors, but not motion artifacts in general.
In part, gcut was used with the script *gcut.sh*, but most often manual corrections in freeview *freeview_schnell_laden.sh* were performed.
Afterward, FS was rerun *update_fs_after_correction.sh* or *rerun_freesurfer.py* and results were inspected *compare_results_brain_extraction_correction.sh*
Color coding in the table gives level of correction success.

Uncorrected FS scans are located in /data/pt_02161/wd/freesurfer/uncorrected.

After template creation, and longitudinal timepoints analysis, pial and white matter surfaces and brainmask.mgz were again inspected visually *run_freesurfer_qa.sh*

2. rs_qa (to be used with environment py3 + AFNI

resting state qa was done roughly according to the recommendations in https://www.nature.com/articles/s41596-018-0065-y?WT.feed_name=subjects_magnetic-resonance-imaging#Sec24

First, denoising was inspected on a subject-level using carpet plots of minimally preprocessed vs. denoised images.

minimally preprocessed: after removal of first 4 volumes, motion correction (MCFlirt), coregistration to anatomical (BBREGISTER) unwarping with fieldmaps in FUGUE, all transforms applied in a single step (*/data/pt_02161/preprocessed/resting/transform_ts/XXX/rest2anat.nii.gz*)

denoised: smoothing with 6mm FWHM, ICA AROMA to correct for motion artifacts, regression of 5 WM/CSF compcor components + high-pass filtering (*/data/pt_02161/preprocessed/resting/aroma/XXX/highpass_compcor/rest_denoised_highpassed.nii*) and optionally global signal (*/data/pt_02161/preprocessed/resting/aroma/ADI003_fu2/highpass_compcor_gsr/rest_denoised_highpassed.nii*)




