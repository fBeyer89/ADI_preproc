#!/bin/bash

SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"


for subj in ADI072 ADI080 ADI082 ADI087 ADI088 ADI089 ADI091 ADI097 ADI102 ADI107 ADI118 ADI124 ADI136


do
echo ${subj}

if [ -d ${SUBJECTS_DIR}/${subj}_bl -a -d ${SUBJECTS_DIR}/${subj}_fu -a -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "all three timepoints"

freeview ${SUBJECTS_DIR}/${subj}_bl.long.${subj}/mri/brainmask.mgz ${SUBJECTS_DIR}/${subj}_fu.long.${subj}/mri/brainmask.mgz ${SUBJECTS_DIR}/${subj}_fu2.long.${subj}/mri/brainmask.mgz -f ${SUBJECTS_DIR}/${subj}_bl.long.${subj}/surf/lh.pial:edgecolor=lightgreen ${SUBJECTS_DIR}/${subj}_bl.long.${subj}/surf/rh.pial:edgecolor=lightgreen ${SUBJECTS_DIR}/${subj}_fu.long.${subj}/surf/lh.pial:edgecolor=white ${SUBJECTS_DIR}/${subj}_fu.long.${subj}/surf/rh.pial:edgecolor=white ${SUBJECTS_DIR}/${subj}_fu2.long.${subj}/surf/lh.pial:edgecolor=red ${SUBJECTS_DIR}/${subj}_fu2.long.${subj}/surf/rh.pial:edgecolor=red


elif [ -d ${SUBJECTS_DIR}/${subj}_bl -a -d ${SUBJECTS_DIR}/${subj}_fu ];
then
echo "two timepoints bl+fu"

freeview ${SUBJECTS_DIR}/${subj}_bl.long.${subj}/mri/brainmask.mgz ${SUBJECTS_DIR}/${subj}_fu.long.${subj}/mri/brainmask.mgz -f ${SUBJECTS_DIR}/${subj}_bl.long.${subj}/surf/lh.pial:edgecolor=lightgreen ${SUBJECTS_DIR}/${subj}_bl.long.${subj}/surf/rh.pial:edgecolor=lightgreen ${SUBJECTS_DIR}/${subj}_fu.long.${subj}/surf/lh.pial:edgecolor=white ${SUBJECTS_DIR}/${subj}_fu.long.${subj}/surf/rh.pial:edgecolor=white

elif [ -d ${SUBJECTS_DIR}/${subj}_fu -a -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "two timepoints fu + fu2"
freeview ${SUBJECTS_DIR}/${subj}_fu.long.${subj}/mri/brainmask.mgz ${SUBJECTS_DIR}/${subj}_fu2.long.${subj}/mri/brainmask.mgz -f ${SUBJECTS_DIR}/${subj}_fu2.long.${subj}/surf/lh.pial:edgecolor=lightgreen ${SUBJECTS_DIR}/${subj}_fu2.long.${subj}/surf/rh.pial:edgecolor=lightgreen ${SUBJECTS_DIR}/${subj}_fu.long.${subj}/surf/lh.pial:edgecolor=white ${SUBJECTS_DIR}/${subj}_fu.long.${subj}/surf/rh.pial:edgecolor=white

elif [ -d ${SUBJECTS_DIR}/${subj}_bl -a -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "two timepoints bl and fu2"
freeview ${SUBJECTS_DIR}/${subj}_bl.long.${subj}/mri/brainmask.mgz ${SUBJECTS_DIR}/${subj}_fu2.long.${subj}/mri/brainmask.mgz -f ${SUBJECTS_DIR}/${subj}_fu2.long.${subj}/surf/lh.pial:edgecolor=lightgreen ${SUBJECTS_DIR}/${subj}_fu2.long.${subj}/surf/rh.pial:edgecolor=lightgreen ${SUBJECTS_DIR}/${subj}_bl.long.${subj}/surf/lh.pial:edgecolor=white ${SUBJECTS_DIR}/${subj}_bl.long.${subj}/surf/rh.pial:edgecolor=white

elif [ -d ${SUBJECTS_DIR}/${subj}_bl ];
then
echo "only bl"
freeview ${SUBJECTS_DIR}/${subj}_bl.long.${subj}/mri/brainmask.mgz -f ${SUBJECTS_DIR}/${subj}_bl.long.${subj}/surf/lh.pial:edgecolor=white ${SUBJECTS_DIR}/${subj}_bl.long.${subj}/surf/rh.pial:edgecolor=white
elif [ -d ${SUBJECTS_DIR}/${subj}_fu ];
then
echo "only fu"

freeview ${SUBJECTS_DIR}/${subj}_fu.long.${subj}/mri/brainmask.mgz -f ${SUBJECTS_DIR}/${subj}_fu.long.${subj}/surf/lh.pial:edgecolor=white ${SUBJECTS_DIR}/${subj}_fu.long.${subj}/surf/rh.pial:edgecolor=white
elif [ -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "only fu2"
freeview ${SUBJECTS_DIR}/${subj}_fu2.long.${subj}/mri/brainmask.mgz -f ${SUBJECTS_DIR}/${subj}_fu2.long.${subj}/surf/lh.pial:edgecolor=white ${SUBJECTS_DIR}/${subj}_fu2.long.${subj}/surf/rh.pial:edgecolor=white
else 
echo "nothing for this subj at all"

fi
done





