#!/bin/bash


#run longitudinal timepoints

SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"


for subj in ADI089 #ADI118 # #
#






#running: ADI003 ADI004 ADI005 ADI007 ADI008 ADI026 ADI032
#running ADI016 ADI020 ADI140 


do
echo ${subj}

if [ -d ${SUBJECTS_DIR}/${subj}_bl -a -d ${SUBJECTS_DIR}/${subj}_fu -a -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "all three timepoints"

recon-all -long ${subj}_bl ${subj} -all
recon-all -long ${subj}_fu ${subj} -all
recon-all -long ${subj}_fu2 ${subj} -all

elif [ -d ${SUBJECTS_DIR}/${subj}_bl -a -d ${SUBJECTS_DIR}/${subj}_fu ];
then
echo "two timepoints bl+fu"
recon-all -long ${subj}_bl ${subj} -all
recon-all -long ${subj}_fu ${subj} -all

elif [ -d ${SUBJECTS_DIR}/${subj}_fu -a -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "two timepoints fu + fu2"
recon-all -long ${subj}_fu ${subj} -all
recon-all -long ${subj}_fu2 ${subj} -all

elif [ -d ${SUBJECTS_DIR}/${subj}_bl -a -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "two timepoints bl and fu2"
recon-all -long ${subj}_bl ${subj} -all
recon-all -long ${subj}_fu2 ${subj} -all

elif [ -d ${SUBJECTS_DIR}/${subj}_bl ];
then
echo "only bl"
recon-all -long ${subj}_bl ${subj} -all

elif [ -d ${SUBJECTS_DIR}/${subj}_fu ];
then
echo "only fu"
recon-all -long ${subj}_fu ${subj} -all
elif [ -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "only fu2"
recon-all -long ${subj}_fu2 ${subj} -all
else 
echo "nothing for this subject at all"

fi
done
