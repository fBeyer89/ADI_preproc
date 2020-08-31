# Use seed-based connectivity for resting state analysis of ADI

### calc_DMN_connectivity_based_on_Powers

##### Prerequisites:
Use a g6 compute server `getserver -sL -g6`. Run `./environment.sh` and load conda environment py3.
##### Analysis
Use `python calc_DMN_based_on_Power.py` to calculate the connectivity between all Power-246 nodes classified as DMN (see table `/data/pt_02161/Analysis/Project2_resting_state/seed-based/Neuron_consensus_264_Power_2011.csv`) and take the average of the connectivity matrix for different preprocessing regimes. You have to specify the subjectlist and input files in the script.
The working directory of this analysis is `/data/pt_02161/wd/calc_DMN` and results are saved in `/data/pt_02161/Results/Project2_resting_state/connectivity/PowerDMNconn/`.

### calc_REW_based_on_Manning

##### Prerequisites:
Use a g6 compute server `getserver -sL -g6`. Run `./environment.sh` and load conda environment py3.
##### Analysis
Use `calc_REW_based_on_Manning` to calculate the seed-based connectivity for 5 nodes from the reward network (['Nacc_left', 'Nacc_right', 'vmpfc_1', 'vmpfc_2','vmpfc_3']) and take the average of the connectivity matrix for different preprocessing regimes (similar to DMN pipeline) You have to specify the subjectlist and input files in the script.
The working directory of this analysis is `/data/pt_02161/wd/calc_Rew` and results are saved in `/data/pt_02161/Results/Project2_resting_state/connectivity/PowerRewconn/`.

**Both of these pipelines are deprecated because of the use of single-voxel ROIs for reward network, and especially the bad SNR in vmPFC ROIS**

### calc_DMN_reward_seed_connectivity
**THIS ANALYSIS IS USED ACCORDING TO MODIFIED PREREGISTRATION ON [OSF](https://osf.io/59bh7/, Dec. 2019).**
##### Prerequisites:
Use a g6 compute server `getserver -sL -g6`. Run `./environment.sh` and load conda environment py3 or agewell_nip1.2.
##### Analysis
Use `python calc_DMN_rew_seed.py` to calculate the connectivity between a precuneus-ROI (for DMN) and a Nucleus accumbens ROI (for reward network). These ROIs are defined based on the longitudinal stream of FS (saved in `/data/p_02161/ADI_Studie/BIDS/derivatives/freesurfer`). The connectivity is calculated for minimally preprocessed, AROMA-non-aggr, AROMA+CC and AROMA+CC+GSR-preprocessed data. You have to specify the subjectlist and input files in the script.
The working directory of this analysis is `/data/pt_02161/wd/calc_Rew_DMN_seed` and results are saved in `/data/pt_02161/Results/Project2_resting_state/connectivity/calc_DMN_reward_seed_connectivity/`.

### Second-level
This folder contains files and scripts for the second-level analysis of the connectivity data using the Sandwich-estimator toolbox (SwE) in SPM.
##### Prerequisites:
Use a g6 compute server `getserver -sL -g6`. Start current MATLAB version, then add private SPM "addpath(genpath('/data/pt_life/data_fbeyer/spm-fbeyer'))".
##### Analysis
Batch scripts to run the second-level analyses are located in the results folders `/data/pt_02161/Results/Project2_resting_state/connectivity/Analysis/`.   

Different modeling approaches can be taken:
- model time as continuous for both groups (`/data/pt_02161/Results/Project2_resting_state/connectivity/Analysis/PCC_cc_z/tp_linear/Model1_group_tp_codedlinearly_job.m`) -> is appropriate for smaller samples and when change can be reasonably approximated as linear
- model time_group combination as factor (`/data/pt_02161/Results/Project2_resting_state/connectivity/Analysis/PCC_cc_z/tp_factor/Model2_group_tp_as_factor_job.m`)-> may be more powerful when higher number of N in the sample, and changes may be non tp_linear

[In this post](https://groups.google.com/g/swe-toolbox/c/dn8zv-kO4RM),  the difference between the two modeling approaches is explained.
[Here](https://groups.google.com/g/swe-toolbox/c/RClq26Pg5uA) are more arguments and explanations for modeling each group_tp factor separately. Good example for understanding [contrasts](https://groups.google.com/g/swe-toolbox/c/ItAUwzt4pVw) for 2x2x2 designs.
Another walkthrough for a [4x2](https://groups.google.com/g/swe-toolbox/c/tZL91Ma6MTg) longitudinal design.
When examing the between- and within-subjects variation, one should split the effects (in this study, e.g. for BMI change)) with

All subject/group covariates for the `_job.m` files were created with the script `get_subject_ID_group_tp_forSwE.R` and are locateed in `SwE_files` which contain necessary g

**To do**
- run group-by-time interaction for all 4 preprocessing + with correction for age, sex, meanFD (as F-test, and individual group contrasts)
- calculate correlation of BMI change and FC change, correcting for mean FD, age, sex according to [this paper](http://doi.org/10.1016/j.neuroimage.2014.03.029), specified in [this post](https://groups.google.com/g/swe-toolbox/c/kTqU-l514B0) & [this post](https://groups.google.com/g/swe-toolbox/c/tZL91Ma6MTg).
