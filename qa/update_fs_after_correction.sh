#!/bin/bash

SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"
#update recons for all subjects with corrections

contr=0
pial=1
# #mkdir -p /data/pt_02161/wd/freesurfer/uncorrected/

for subj in ADI072_fu





#running on springsteen ADI033_bl

#running on styx: ADI072_bl ADI072_fu ADI072_fu2 ADI080_bl ADI087_fu ADI087_fu2 ADI088_fu ADI089_bl ADI091_fu ADI097_bl ADI097_fu ADI097_fu2 ADI102_bl ADI102_fu ADI107_bl ADI107_fu ADI118_bl ADI124_fu2 ADI136_bl

#done: 
#ADI008_bl ADI009_bl ADI009_fu ADI013_bl ADI013_fu ADI013_fu2 ADI025_bl ADI025_fu ADI029_fu ADI029_fu2 ADI032_bl  ADI036_bl ADI036_fu2 ADI041_fu ADI045_bl ADI045_fu ADI045_fu2 ADI047_fu ADI047_fu2 ADI048_bl ADI048_fu ADI048_fu2  ADI063_fu ADI064_bl

#done
#ADI068_bl ADI068_fu ADI068_fu2 ADI069_bl ADI069_fu 

#done
#ADI004_fu2 ADI009_bl, ADI063_bl 

#done contorl point subjects 
#ADI036_fu2 ADI033_bl ADI064_bl ADI026_bl
do

echo ${subj}

#if [ ! -d /data/pt_02161/wd/freesurfer/uncorrected/${subj}/surf ];
#then
#echo "copying $subj"
#mkdir -p /data/pt_02161/wd/freesurfer/uncorrected/${subj}/surf
#cp -r -v  ${SUBJECTS_DIR}/$subj/surf /data/pt_02161/wd/freesurfer/uncorrected/${subj}/surf
#else 
#echo "copy done"
#fi

#echo $pial
#echo $contr
if [ $contr -eq 1 ];
then
echo "control points"
recon-all -autorecon2-cp -autorecon3 -subjid ${subj} -openmp 8

elif [ $pial -eq 1 ];
then
echo "pial edits"
recon-all -autorecon-pial -subjid ${subj} -openmp 8

else
recon-all -make all -subjid $subj -openmp 8
fi

done


