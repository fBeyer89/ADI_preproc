#!/bin/bash

SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"

recon-all -base ADI009 -tp ADI009_bl -tp ADI009_fu -all


recon-all -long ADI009_bl ADI009 -all
recon-all -long ADI009_fu ADI009 -all
