
#run longitudinal timepoints

SUBJECTS_DIR="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer"

#recon-all -long ADI080_bl ADI080 -all

#recon-all -long ADI016_bl ADI016 -all
#recon-all -long ADI050_fu ADI050 -all
recon-all -long ADI082_fu ADI082 -all
#recon-all -long ADI139_fu ADI139 -all


#recon-all -long ADI032_bl ADI032 -all -parallel
#recon-all -long ADI033_bl ADI033 -all -parallel
