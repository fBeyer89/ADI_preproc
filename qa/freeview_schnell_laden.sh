#!/bin/bash
SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"
subject="ADI136_bl"

freeview ${SUBJECTS_DIR}/${subject}/mri/T1.mgz ${SUBJECTS_DIR}/${subject}/mri/brainmask.mgz:colormap=heat -f ${SUBJECTS_DIR}/${subject}/surf/lh.pial:edgecolor=lightgreen ${SUBJECTS_DIR}/${subject}/surf/lh.white:edgecolor=white ${SUBJECTS_DIR}/${subject}/surf/rh.pial:edgecolor=lightgreen ${SUBJECTS_DIR}/${subject}/surf/rh.white:edgecolor=white



