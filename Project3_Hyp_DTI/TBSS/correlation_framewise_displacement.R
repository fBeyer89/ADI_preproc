####@uthor:thieleking

###### Load Packages #######
rm(list=ls())
library(pastecs)
library(BayesFactor)
library(reshape)
library(RColorBrewer)

###### Load Data ####
dwi_motion=read.csv("/data/pt_02161/wd/motion_FD_DWI/FD_all_subjects.csv", stringsAsFactors = F)
rs_motion_wide=read.csv("/data/pt_02161/Results/Project1_headmotion/results/ADI_meanFD.csv", stringsAsFactors = F)
rs_motion_wide=rs_motion_wide[,-1]
rs_motion=melt(rs_motion_wide, id = "subj.ID", variable_name = "tp")

rs_motion$tp <- as.character.factor(rs_motion$tp)
for(i in 1:length(rs_motion$tp)){
  temp <- strsplit(rs_motion$tp[i], "_")[[1]][2]
  rs_motion$tp[i] <- temp
}

names(rs_motion)[3] <- "meanFD"

rs_motion <- rs_motion[complete.cases(rs_motion),]
rs_motion <- rs_motion[order(rs_motion$subj.ID),]

mean_FD = data.frame(subj_id = rs_motion$subj.ID)
mean_FD$tp = rs_motion$tp
mean_FD$rs_meanFD = rs_motion$meanFD
mean_FD$dwi_meanFD = NA


for(i in 1:length(dwi_motion$subject_id)){
  mean_FD$dwi_meanFD[mean_FD$subj_id == dwi_motion$subject_id[i] & mean_FD$tp == dwi_motion$tp[i]] <- dwi_motion$meanFD[i] 
}

##### correlate mean FD from DWI and rs
correlationBF(mean_FD$rs_meanFD, mean_FD$dwi_meanFD)
bayes.cor.test(mean_FD$rs_meanFD, mean_FD$dwi_meanFD)

hist(mean_FD$rs_meanFD,breaks=40)
hist(mean_FD$dwi_meanFD,breaks=40)

lmBF(dwi_meanFD ~ rs_meanFD, mean_FD[complete.cases(mean_FD),], whichRandom = "subj_id")

fitted_model = lm(mean_FD$dwi_meanFD ~ mean_FD$rs_meanFD)


n <- nlevels(mean_FD$subj_id)
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))


plot(dwi_meanFD ~ rs_meanFD, mean_FD, col=col_vector[mean_FD$subj_id], pch=19)
abline(fitted_model, col="black", lwd=3)
