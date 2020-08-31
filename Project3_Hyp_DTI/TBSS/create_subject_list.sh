#! /bin/bash

cd /data/pt_02161/preprocessed/diffusion/dti/
subjs_bl=$( find . -type d -name "*_bl" | cut -c 3-8 )

# # rm -f /data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_bl_fu.txt

for subj in $subjs_bl
do

subj_fu=$( find . -type d -name "$subj*_fu" )
subj_fu2=$( find . -type d -name "$subj*_fu2" )

if [[ $subj_fu ]];
then

#     echo "${subj}" >> /data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_bl_fu.txt

    if [[ $subj_fu2 ]];
    then

    echo "${subj}" >> /data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_bl_fu_fu2.txt
    
    fi

fi
done
