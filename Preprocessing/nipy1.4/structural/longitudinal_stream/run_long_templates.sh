#!/bin/bash


##create freesurfer longitudinal templates.

#Processing single time point data through the longitudinal stream is now possible (usefull for LME where subjects with only a single time point can be included) (FS 5.2 or later). 

SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"


for subj in ADI118 


do
echo ${subj}
if [ -d ${SUBJECTS_DIR}/${subj}_bl -a -d ${SUBJECTS_DIR}/${subj}_fu -a -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "all three timepoints"
recon-all -base ${subj} -tp ${subj}_bl -tp ${subj}_fu -tp ${subj}_fu2 -all

elif [ -d ${SUBJECTS_DIR}/${subj}_bl -a -d ${SUBJECTS_DIR}/${subj}_fu ];
then
echo "two timepoints bl+fu"
recon-all -base ${subj} -tp ${subj}_bl -tp ${subj}_fu  -all

elif [ -d ${SUBJECTS_DIR}/${subj}_fu -a -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "two timepoints fu + fu2"
recon-all -base ${subj} -tp ${subj}_fu -tp ${subj}_fu2  -all

elif [ -d ${SUBJECTS_DIR}/${subj}_bl -a -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "two timepoints bl and fu2"
recon-all -base ${subj} -tp ${subj}_bl -tp ${subj}_fu2  -all

elif [ -d ${SUBJECTS_DIR}/${subj}_bl ];
then
echo "only bl"
recon-all -base ${subj} -tp ${subj}_bl -all
elif [ -d ${SUBJECTS_DIR}/${subj}_fu ];
then
echo "only fu"
recon-all -base ${subj} -tp ${subj}_fu -all
elif [ -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "only fu2"
recon-all -base ${subj} -tp ${subj}_fu2 -all
else 
echo "nothing for this subject at all"

fi

done
