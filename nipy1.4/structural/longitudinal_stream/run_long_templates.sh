#!/bin/bash


##create freesurfer longitudinal templates.

#Processing single time point data through the longitudinal stream is now possible (usefull for LME where subjects with only a single time point can be included) (FS 5.2 or later). 

SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"


for subj in ADI097 ADI102 ADI107 ADI118 ADI124 ADI136


#running (corrected)
#ADI003 ADI004 ADI006 ADI008 ADI013 ADI025 ADI026 ADI029 ADI032 ADI033 ADI036

#running:
#ADI041 ADI045 ADI047 ADI048 ADI063 ADI064 
#running:
#ADI068 ADI069 ADI072 ADI080 ADI082 ADI087 ADI088 ADI089 ADI091 

#done: ADI005 ADI007 ADI014 ADI016 ADI020 ADI036 ADI046 ADI049 ADI050 ADI053 ADI061 ADI062 ADI093 ADI095 ADI111 ADI116 ADI124 ADI139 ADI140


#these need further correction
#ADI002 ADI003 ADI004 ADI006 ADI008 ADI009 ADI013  ADI025 ADI026 ADI029 ADI032 ADI033  ADI041 ADI045  ADI047 ADI048  ADI063 ADI064  ADI068 ADI069 ADI072 ADI080 ADI082  ADI087 ADI088 ADI089 ADI091  ADI097 ADI102 ADI107 ADI111 ADI116 ADI118 ADI124 ADI136 ADI139 ADI140 ADI002 ADI003 ADI004 ADI005 ADI006 ADI007 ADI008 ADI009 ADI013 ADI014 ADI016 ADI020 ADI025 ADI026 ADI029 ADI032 ADI033 ADI036 ADI041 ADI045 ADI046 ADI047 ADI048 ADI049 ADI050 ADI053 ADI061 ADI062 ADI063 ADI064 ADI068 ADI069 ADI072 ADI080 ADI082 ADI087 ADI088 ADI089 ADI091 ADI093 ADI095  ADI002 ADI003 ADI004 ADI005 ADI006 ADI007 ADI008 ADI009 ADI013 ADI014 ADI016 ADI020 ADI025 ADI026 ADI029 ADI032 ADI033 ADI036 ADI041 ADI045 ADI046 ADI047 ADI048 ADI049 ADI050 ADI053 ADI061 ADI062 ADI063 ADI064 ADI068 ADI069 ADI072 ADI080 ADI082 ADI087 ADI088 ADI089 ADI091 ADI093 ADI095 ADI097 ADI102 ADI107 ADI111 ADI116 ADI118 ADI136 
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
recon-all -base ${subj} -tp ${subj}_bl
elif [ -d ${SUBJECTS_DIR}/${subj}_fu ];
then
echo "only fu"
recon-all -base ${subj} -tp ${subj}_fu
elif [ -d ${SUBJECTS_DIR}/${subj}_fu2 ];
then
echo "only fu2"
recon-all -base ${subj} -tp ${subj}_fu2
else 
echo "nothing for this subject at all"

fi

done
