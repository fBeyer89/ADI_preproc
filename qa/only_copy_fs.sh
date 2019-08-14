
SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"

for subj in ADI006_fu2 ADI006_fu ADI008_bl ADI009_bl ADI009_fu ADI013_bl ADI013_fu ADI013_fu2
do 

if [ ! -d /data/pt_02161/wd/freesurfer/uncorrected/${subj}/surf ];
then
echo "copying $subj"
mkdir -p /data/pt_02161/wd/freesurfer/uncorrected/${subj}/surf
cp -r -v  ${SUBJECTS_DIR}/$subj/surf /data/pt_02161/wd/freesurfer/uncorrected/${subj}/surf
else 
echo "copy done"
fi

done
