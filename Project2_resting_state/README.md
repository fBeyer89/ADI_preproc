# Connectivity project

### This project has been preregistered on [OSF](https://osf.io/f8tpn). We aim to adress the following hypotheses:

1. Are there any changes in functional connectivity (FC) within the brain reward network and default mode network after bariatric surgery compared to waiting list control group at FU1 compared to BL?

2.  Does the magnitude of changes in reward network FC in the intervention group predict the magnitude of individual weight loss (reduced body mass-index (BMI)) after surgery (ΔFC ~ ΔBMI and ΔFC ~ Δ% body fat).

3. Do observed changes in serum level leptin (ΔFC ~ Δ leptin) predict reward FC, adjusting for initial body fat, body fat lost in sensitivity analyses?


### Preregistration

Whole-brain FC maps for a priori defined seed regions (taken from Freesurfer parcellation/segmentation or AAL atlas)
- reward network (vmPFC, STR, antIn)
- default mode network (posterior cingulate cortex (PCC), precuneus (pC), medial prefrontal gyrus (MPFG)

### Possible definitions of FC outcomes

#### seed-based connectivity:
seed-based connectivity is more variable because of noise associated with seed selection.

popular DMN regions

| Region        |  x  |  y  |  z  | Paper|definition|
| ------------- |:---:|:---:|:---:|------|-----|
| Medial prefrontal cortex | 	8| 59 |9 |doi:10.1016/j.nicl.2017.07.015|rs|
|Posterior cingulate cortex|− 2|− 50|25|doi:10.1016/j.nicl.2017.07.015|rs|
|PCC|0|−53|26|https://doi.org/10.1038/srep46088|rs|
PACC|0|46|2|https://doi.org/10.1016/j.neuroimage.2011.05.028|tid|
r-insula|38|-12|2|https://doi.org/10.1016/j.neuroimage.2011.05.028|tid|
l-TPJ|-48|-70|24|https://doi.org/10.1016/j.neuroimage.2011.05.028|tid|
PCC|-4|-52|24|https://doi.org/10.1016/j.neuroimage.2011.05.028|tid|
r-TPJ|46|-64|22|https://doi.org/10.1016/j.neuroimage.2011.05.028|tid|

popular reward network regions

| Region        |  x  |  y  |  z  | Paper|definition|
| ------------- |:---:|:---:|:---:|------|-----|
|amygdala | 	-23| -4 |-19 |4mm sphere, doi:https://doi.org/10.3945/ajcn.113.080671|rs|
|NAcc regions|-8|12|1|5mm sphere,  https://doi.org/10.1371/journal.pone.0125286|rs|
|NAcc regions|-11|11|1|5mm sphere,  https://doi.org/10.1371/journal.pone.0125286|rs|
|vmPFC |-6|24|-21|10mm sphere,  https://doi.org/10.1371/journal.pone.0125286|rs|
|vmPFC |6|30|-9|10mm sphere,   https://doi.org/10.1371/journal.pone.0125286|rs|
|vmPFC |9|27|-12|10mm sphere,  https://doi.org/10.1371/journal.pone.0125286|rs|


#### ICA based definition

does not depend on seed definition, but for GIFT default preprocessing is not optimal as it is recommended to not use anything beyond simple alignment to MNI space and intensity normalization (so no AROMA denoising, CC or GSR).

no problem if multiple timepoints of same subject are included: https://sourceforge.net/p/icatb/mailman/message/32428289/


#### Conclusion for now (Beginning of November 2019)

1. Use Power definition and average mean MD after GSR as outcome for DMN Connectivity.
2. Use seeds defined in papers to calculate an average reward network connectivity.

The scripts for these analyses can be found in `/data/pt_02161/Analysis/Project2_resting_state/seed-based/calc_DMN_connectivity_based_on_Powers` and `/data/pt_02161/Analysis/Project2_resting_state/seed-based/calc_REW_based_on_Manning`.

#### After group meeting (21.11.2019)

We decided to write an amendment to our original preregistration, specifying the exact analysis. We decided to first omit ICA and use seed-based connectivity from DMN and reward network. See [OSF](https://osf.io/59bh7/) for more details.




Whole-brain FC maps for a priori defined seed regions
(defined based on the results of the subcortical segmentation and Desikan-Killiany cortical parcellation in the Freesurfer version 6.0.0 longitudinal processing stream )

- reward network
(ROI combined from bilateral Nucleus accumbens from the subcortical
segmentation (26, Left-Accumbens-area, 58, Right-Accumbens-area)). Ventro-medial
prefrontal cortex was not selected as seed region due to low signal-to-noise ratio in this part
of the brain in many participants (noticed during quality checking).
- default mode network
(ROI combined from bilateral precuneus from the Desikan-Killiany
atlas (1025 ctx-lh-precuneus, 2025 ctx-rh-precuneus))

The script for this analysis is in `/data/pt_02161/Analysis/Project2_resting_state/seed-based/calc_DMN_reward_seed_connectivity`.
