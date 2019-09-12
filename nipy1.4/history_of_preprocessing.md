##PREPROCESSING FOR ADI study

# run structural, functional and DTI preprocessing according to preregistration with run_workflow_hcplike.py + workflow.py

- manual correction of freesurfer outputs (according to Quola-T --> )
- many pial edits necessary (link to obesity?)
- need accurate pial editing because skullstripped brain is used for registration in hypothalamus pipeline.
- corrected fs and rerun for certain subjects 

# discovered error in AROMA pipeline (using GLM estimates instead of residuals) (12.09.2019)
-> corrected this and added long-implementation using freesurfer long for registration to MNI and func-anat transform.
-> run_workflow_hcplike.py now imports workflow_long.py (without diffusion + BIDS), but operates on the same working directory and output.

