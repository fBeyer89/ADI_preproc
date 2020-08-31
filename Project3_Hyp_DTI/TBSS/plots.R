####@uthor:thieleking

###### Load Packages #######
rm(list=ls())
library(pastecs)
library(ggplot2)
library(plyr)
###### Load Data ####

subjects_bl_fu2=read.csv("/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects+group_for_randomise_incl_fu2.txt",header=T, sep="\t")


subjects_BMI_tp_group= data.frame(ID = rep(subjects_bl_fu2$ID, each=3), timepoint=rep(c("BL", "FU", "FU2"), 20), group=rep(subjects_bl_fu2$Group, each=3), BMI=NA)

subjects_BMI_tp_group$group <- revalue(subjects_BMI_tp_group$group, c("IG"="bariatric\nsurgery", "KG"="waiting\nlist"))

for(subj in subjects_BMI_tp_group$ID){
  subjects_BMI_tp_group$BMI[subjects_BMI_tp_group$ID == subj & subjects_BMI_tp_group$timepoint == "BL"] = subjects_bl_fu2$BMI_BL[subjects_bl_fu2$ID == subj]
  subjects_BMI_tp_group$BMI[subjects_BMI_tp_group$ID == subj & subjects_BMI_tp_group$timepoint == "FU"] = subjects_bl_fu2$BMI_FU[subjects_bl_fu2$ID == subj]
  subjects_BMI_tp_group$BMI[subjects_BMI_tp_group$ID == subj & subjects_BMI_tp_group$timepoint == "FU2"] = subjects_bl_fu2$BMI_FU2[subjects_bl_fu2$ID == subj]
}

subjects_BMI_tp_group$timepoint <- revalue(subjects_BMI_tp_group$timepoint, c("BL"="pre", "FU"="6m", "FU2"="12m"))

#### plot bmi ----


ggplot(aes(y = BMI, x = timepoint, fill = group), data = subjects_BMI_tp_group) + geom_boxplot() + theme(text = element_text(size=26)) + ylab("BMI [in kg/m²]")
