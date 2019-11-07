# QA scripts for ADI study

### fs_qa

freesurfer qa was done according to [Klapwijk et. al 2018](www.ncbi.nlm.nih.gov%2Fpubmed%2F30633965&usg=AOvVaw3LFn7aLEFsuOjNZHdgnyQw). Also see Klapwijk_QoalaT_fs_qa.pdf in this folder.
Briefly, all cross-sectional runs were inspected visually with *run_freesurfer_qa.sh* according to 4 criteria.

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

### rs_qa

resting state qa was done roughly according to the recommendations by Rastko Ciric in [Nature Protocols](https://www.nature.com/articles/s41596-018-0065-y?WT.feed_name=subjects_magnetic-resonance-imaging#Sec24)

`ADI_rs_qa.csv` is the file which contains QA information for the resting state. `all_ADI_for_rsqc.txt` is a text file with all participants included into the analysis before exclusion due to motion etc.

#### subject-level QA

1. plotting

`run_rsqc.py` runs the subject-level qc visualization and extracts confounds. `utils.py` contains the necessary helper functions. It needs the same environment as the preprocessing but python version 3.0. 
First, denoising was inspected on a subject-level using individual plots of minimally preprocessed vs. denoised images. These are located in /data/pt_02161/preprocessed/resting/detailedQA/X/summary_fmriplot.png. On top, the % outliers (defined by default settings of [afni](https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dToutcount.html), framewise displacement in mm and DVARS in % signal change are shown. These values are also saved in */data/pt_02161/preprocessed/resting/detailedQA/metrics/X/confounds.csv*. Only framewise displacement values are located in */data/pt_02161/preprocessed/resting/detailedQA/metrics/X/fd.txt*. Below come the carpet plots of signal in voxels classified into compartments (from top to bottom: red: GM, green: WM, orange: CSF, blue: cerebellum) for minimally preprocessed, AROMA, AROMA+CompCor and AROMA + CompCor + GSR denoised images. Lines without signal change indicate that in these voxels (which were defined from the segmentation of the anatomical image) did not have meaningful signal in the functional (due to e.g. signal dropout or FOV limitations.) Compare to the final brainmask was created as the overlap of brain_mask.mgz from Freesurfer and BET-brain extracted mean of functional images (see `transform_timeseries.py`)

1. minimally preprocessed

after removal of first 4 volumes, motion correction (MCFlirt), coregistration to anatomical (BBREGISTER) unwarping with fieldmaps in FUGUE, all transforms applied in a single step (*/data/pt_02161/preprocessed/resting/transform_ts/X/rest2anat.nii.gz*)

2. AROMA

smoothing with 6mm FWHM, ICA AROMA to correct for motion artifacts. Use non-agressive denoising which does not remove shared variance between motion and non-motion components. (*/data/pt_02161/preprocessed/resting/aroma/X/denoised_func_data_nonaggr.nii.gz*)

3. denoised Compcor

smoothing with 6mm FWHM, ICA AROMA to correct for motion artifacts, regression of 5 WM/CSF compcor components + high-pass filtering (*/data/pt_02161/preprocessed/resting/aroma/X/highpass_compcor/rest_denoised_highpassed.nii*)

4. denoised Compcor+ global signal

(*/data/pt_02161/preprocessed/resting/aroma/X/highpass_compcor_gsr/rest_denoised_highpassed.nii*)

The script also creates metrics (/data/pt_02161/preprocessed/resting/detailedQA/metrics/)
#### group-level QA

1. calc_connectome

Here, a connectome based on Power's N=264 nodes with radius of 5 mm is calculated `calc_connectome.py`. It transforms the original, and denoised images into MNI space, extracts the timeseries from the ROIs and calculates the connectome. It then saves the connectome plot ( resting/detailedQA/Power264conn/X/connmatrix_0/1/2/3.png (min-preprocessed, aroma, aroma+cc, aroma+cc+gsr) and the upper triangle of the correlation matrix (resting/detailedQA/Power264conn/X/connvals.txt) for further analysis.

2. QC-FC correlations

`calc_qc_fc_correlations.R` is used to calculate the correlations of QC (mean fd per participant) and functional connectivity per connection in the connectome. This serves as verification that preprocessing reduced QC-FC artifact.
