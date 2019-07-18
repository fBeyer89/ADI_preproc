#!/bin/bash

SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"
subject="ADI025_fu"

recon-all -skullstrip -clean-bm -gcut -subjid ${subject}
