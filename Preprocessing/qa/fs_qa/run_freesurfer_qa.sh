#run freesurfer quality checks according to 
#Klapwijk: Qoala-T: A supervised-learning tool for quality control of FreeSurfer segmented MRI data
SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"
for subj in ADI140
do
view="tkmedit ${subj}_bl.long.$subj brainmask.mgz -surfs -aux wm.mgz"
eval $view

done


#already done:
#ADI003_fu2 ADI003_fu ADI004_fu2 ADI005_fu2 ADI006_bl ADI006_fu2 ADI006_fu ADI007_bl ADI008_bl ADI009_bl ADI009_fu2 ADI009_fu ADI013_bl ADI013_fu ADI013_fu2 ADI014_fu ADI014_fu2 ADI016_bl ADI016_fu ADI016_fu2 ADI020_bl ADI020_fu ADI020_fu2 ADI025_bl ADI025_fu ADI026_bl ADI029_fu ADI029_fu2 ADI032_bl ADI033_bl ADI036_bl ADI036_fu ADI036_fu2 ADI041_bl ADI041_fu ADI045_bl ADI045_fu ADI045_fu2 ADI046_bl ADI046_fu ADI046_fu2 ADI047_fu ADI047_fu2 ADI048_bl ADI048_fu ADI048_fu2 ADI049_fu ADI049_fu2 ADI050_fu ADI050_fu2 ADI053_fu ADI053_fu2 ADI061_bl ADI061_fu ADI061_fu2 ADI062_bl ADI062_fu ADI062_fu2 ADI063_bl ADI063_fu ADI064_bl ADI064_fu ADI064_fu2 ADI068_bl ADI068_fu ADI068_fu2 ADI069_bl ADI069_fu ADI072_bl ADI072_fu ADI072_fu2 ADI080_bl ADI082_fu ADI082_fu2 ADI087_bl ADI087_fu ADI087_fu2 ADI088_fu ADI088_fu2 ADI089_bl ADI091_fu ADI093_fu ADI095_fu ADI097_bl ADI097_fu ADI097_fu2 ADI102_bl ADI102_fu ADI107_bl ADI107_fu ADI111_bl ADI111_fu ADI111_fu2 ADI116_bl ADI116_fu ADI116_fu2 ADI118_bl ADI124_bl ADI124_fu ADI124_fu2 ADI136_bl ADI139_bl ADI139_fu ADI140_bl ADI140_fu ADI140_fu2