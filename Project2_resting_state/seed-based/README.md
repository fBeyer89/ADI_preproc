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


Models are run with SwE toolbox.
Start MATLAB, then add private SPM "addpath(genpath('/data/pt_life/data_fbeyer/spm-fbeyer'))"
Then, find batch scripts in results folders `/data/pt_02161/Results/Project2_resting_state/connectivity/Analysis/` where `Files`
contains group/covariates necessary.
