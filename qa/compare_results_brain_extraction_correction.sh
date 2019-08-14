#!/bin/bash

SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"
subject="ADI102_fu"


freeview ${SUBJECTS_DIR}/${subject}/mri/T1.mgz -f ${SUBJECTS_DIR}/${subject}/surf/lh.pial:edgecolor=lightgreen ${SUBJECTS_DIR}/${subject}/surf/rh.pial:edgecolor=lightgreen /data/pt_02161/wd/freesurfer/uncorrected/${subject}/surf/surf/lh.pial:edgecolor=yellow /data/pt_02161/wd/freesurfer/uncorrected/${subject}/surf/surf/rh.pial:edgecolor=yellow
