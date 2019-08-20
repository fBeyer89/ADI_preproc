#!/bin/bash


#run longitudinal timepoints

SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"


for subj in ADI041 ADI045 ADI046 ADI047 ADI048 ADI049 ADI050 ADI053 ADI061 ADI062 ADI063 ADI064 



#running: ADI003 ADI004 ADI006 ADI008 ADI013 ADI025 ADI026 ADI029 ADI032 ADI033 ADI036
#running: ADI068 ADI069 ADI072 ADI080 ADI082 ADI087 ADI088 ADI089 ADI091
#ADI041 ADI045 ADI046 ADI047 ADI048 ADI049 ADI050 ADI053 ADI061 ADI062 ADI063 ADI064 
#running: ADI097 ADI102 ADI107 ADI111 ADI116 ADI124 ADI139 ADI140 


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
#recon-all -long ${subj}_fu ${subj} -all
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
