####@uthor:thieleking

###### Load Packages #######
rm(list=ls())
library(pastecs)
library(tibble)
###### Load Data ####

group_list=read.csv("/data/p_02161/ADI_studie/metadata/group_list_all.csv")
final_group_table=read.csv("/data/p_02161/ADI_studie/metadata/final_sample_MRI_QA_info.csv")
subjects_tbss=read.csv("/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_bl_fu.txt",header=F)
subjects_tbss_fu2=read.csv("/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_bl_fu_fu2.txt",header=F)

names(subjects_tbss)=c("ID")
subjects_tbss$No_in_4d_dataset=0:27
subjects_tbss$Group=NA
subjects_tbss$Age_BL=NA
subjects_tbss$BMI_BL=NA
subjects_tbss$BMI_FU=NA
subjects_tbss$BMI_change_bl_fu=NA
subjects_tbss$randomise_code_IG=NA
subjects_tbss$randomise_code_KG=NA
subjects_tbss$mean_meanFD=NA
subjects_tbss$diff_meanFD=NA
subjects_tbss$Age_BL_z=NA

for(subj in subjects_tbss$ID){
  subjects_tbss$Group[subjects_tbss$ID == subj] <- group_list$condition[group_list$subj.ID == subj]
  if(subjects_tbss$Group[subjects_tbss$ID == subj] == 1){
    subjects_tbss$Group[subjects_tbss$ID == subj] = "IG"
    subjects_tbss$randomise_code_IG[subjects_tbss$ID == subj] = "1"
    subjects_tbss$randomise_code_KG[subjects_tbss$ID == subj] = "0"
  } else{
    subjects_tbss$Group[subjects_tbss$ID == subj] = "KG"
    subjects_tbss$randomise_code_IG[subjects_tbss$ID == subj] = "0"
    subjects_tbss$randomise_code_KG[subjects_tbss$ID == subj] = "1"
  }
  subjects_tbss$mean_meanFD[subjects_tbss$ID == subj] = mean(final_group_table$meanFD[final_group_table$subj.ID == subj & final_group_table$tp == "bl"], final_group_table$meanFD[final_group_table$subj.ID == subj & final_group_table$tp == "fu"])
  subjects_tbss$diff_meanFD[subjects_tbss$ID == subj] = final_group_table$meanFD[final_group_table$subj.ID == subj & final_group_table$tp == "fu"] - final_group_table$meanFD[final_group_table$subj.ID == subj & final_group_table$tp == "bl"]
  subjects_tbss$Age_BL[subjects_tbss$ID == subj] = group_list$Age_BL[group_list$subj.ID == subj]
  subjects_tbss$BMI_BL[subjects_tbss$ID == subj] = group_list$BMI[group_list$subj.ID == subj]
  subjects_tbss$BMI_FU[subjects_tbss$ID == subj] = final_group_table$BMI[final_group_table$subj.ID == subj & final_group_table$tp =="fu"]
  subjects_tbss$BMI_change_bl_fu[subjects_tbss$ID == subj] = subjects_tbss$BMI_FU[subjects_tbss$ID == subj] - subjects_tbss$BMI_BL[subjects_tbss$ID == subj]
}
subjects_tbss$Group = as.factor(subjects_tbss$Group)
subjects_tbss$randomise_code_IG = as.factor(subjects_tbss$randomise_code_IG)
subjects_tbss$randomise_code_KG = as.factor(subjects_tbss$randomise_code_KG)

summary(subjects_tbss$Group)

subjects_tbss$log_mean_meanFD = log(subjects_tbss$mean_meanFD)
subjects_tbss$Age_BL_z=scale(subjects_tbss$Age_BL)

#### create dataframe for FU2 analysis ------

subjects_tbss_incl_fu2 <- subjects_tbss[subjects_tbss$ID %in% subjects_tbss_fu2$V1,]

subjects_tbss_incl_fu2$No_in_4d_dataset <- 0:(length(subjects_tbss_incl_fu2$ID)-1)

subjects_tbss_incl_fu2 <- add_column(subjects_tbss_incl_fu2, BMI_FU2=NA, .after = 6)

names(subjects_tbss_incl_fu2)[8] = "BMI_change_bl_fu2"


for(subj in as.character.factor(subjects_tbss_incl_fu2$ID)){
  subjects_tbss_incl_fu2$mean_meanFD[subjects_tbss_incl_fu2$ID == subj] = mean(final_group_table$meanFD[final_group_table$subj.ID == subj & final_group_table$tp == "bl"], final_group_table$meanFD[final_group_table$subj.ID == subj & final_group_table$tp == "fu2"])
  subjects_tbss_incl_fu2$diff_meanFD[subjects_tbss_incl_fu2$ID == subj] = final_group_table$meanFD[final_group_table$subj.ID == subj & final_group_table$tp == "fu2"] - final_group_table$meanFD[final_group_table$subj.ID == subj & final_group_table$tp == "bl"]
  subjects_tbss_incl_fu2$BMI_FU2[subjects_tbss_incl_fu2$ID == subj] = final_group_table$BMI[final_group_table$subj.ID == subj & final_group_table$tp =="fu2"]
  subjects_tbss_incl_fu2$BMI_change_bl_fu2[subjects_tbss_incl_fu2$ID == subj] = subjects_tbss_incl_fu2$BMI_FU2[subjects_tbss_incl_fu2$ID == subj] - subjects_tbss_incl_fu2$BMI_BL[subjects_tbss_incl_fu2$ID == subj]
}

subjects_tbss_incl_fu2$log_mean_meanFD = log(subjects_tbss_incl_fu2$mean_meanFD)
subjects_tbss_incl_fu2$Age_BL_z=scale(subjects_tbss_incl_fu2$Age_BL)

str(subjects_tbss_incl_fu2)
summary(subjects_tbss_incl_fu2$Group)

#### Save data #####
write.table(subjects_tbss, "/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects+group_for_randomise.txt", sep="\t", quote = F, row.names=FALSE)

write.table(subjects_tbss_incl_fu2, "/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects+group_for_randomise_incl_fu2.txt", sep="\t", quote = F, row.names=FALSE)


#### exploratory plots and stats ####

mean(subjects_tbss$BMI_BL[subjects_tbss$Group=="IG"])
mean(subjects_tbss$BMI_BL[subjects_tbss$Group=="KG"])
sd(subjects_tbss$BMI_BL[subjects_tbss$Group=="IG"])
sd(subjects_tbss$BMI_BL[subjects_tbss$Group=="KG"])

mean(subjects_tbss$BMI_change_bl_fu[subjects_tbss$Group=="IG"])
mean(subjects_tbss$BMI_change_bl_fu[subjects_tbss$Group=="KG"])
sd(subjects_tbss$BMI_change_bl_fu[subjects_tbss$Group=="IG"])
sd(subjects_tbss$BMI_change_bl_fu[subjects_tbss$Group=="KG"])

mean(subjects_tbss_incl_fu2$BMI_change_bl_fu2[subjects_tbss_incl_fu2$Group=="IG"])
mean(subjects_tbss_incl_fu2$BMI_change_bl_fu2[subjects_tbss_incl_fu2$Group=="KG"])
sd(subjects_tbss_incl_fu2$BMI_change_bl_fu2[subjects_tbss_incl_fu2$Group=="IG"])
sd(subjects_tbss_incl_fu2$BMI_change_bl_fu2[subjects_tbss_incl_fu2$Group=="KG"])

hist(subjects_tbss$mean_meanFD)
hist(subjects_tbss$diff_meanFD)
boxplot(formula=Age_BL~Group, data=subjects_tbss)
boxplot(formula=BMI_BL~Group, data=subjects_tbss)
boxplot(formula=BMI_change_bl_fu~Group, data=subjects_tbss)
boxplot(formula=BMI_change_bl_fu2~Group, data=subjects_tbss_incl_fu2)

# library(BayesFactor)
# ttestBF(formula=diff_meanFD~Group, data=subjects_tbss)
# ttestBF(formula=log_mean_meanFD~Group, data=subjects_tbss)
# ttestBF(formula=Age_BL~Group, data=subjects_tbss)
# ttestBF(formula=Age_BL_z~Group, data=subjects_tbss)
# 
# ttestBF(formula=diff_meanFD~Group, data=subjects_tbss_incl_fu2)
# ttestBF(formula=log_mean_meanFD~Group, data=subjects_tbss_incl_fu2)

#### split into table for IG and KG separately

subjects_tbss_IG = subjects_tbss[subjects_tbss$Group == "IG",]
subjects_tbss_KG = subjects_tbss[subjects_tbss$Group == "KG",]

write.table(subjects_tbss_IG, "/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_IG_for_randomise.txt", sep="\t", quote = F, row.names=FALSE)
write.table(subjects_tbss_KG, "/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_KG_for_randomise.txt", sep="\t", quote = F, row.names=FALSE)

subjects_tbss_incl_fu2_IG = subjects_tbss_incl_fu2[subjects_tbss_incl_fu2$Group == "IG",]
subjects_tbss_incl_fu2_KG = subjects_tbss_incl_fu2[subjects_tbss_incl_fu2$Group == "KG",]

write.table(subjects_tbss_incl_fu2_IG, "/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_IG_for_randomise_incl_fu2.txt", sep="\t", quote = F, row.names=FALSE)
write.table(subjects_tbss_incl_fu2_KG, "/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_KG_for_randomise_incl_fu2.txt", sep="\t", quote = F, row.names=FALSE)


##### corrections to z-scoring ----

subjects_tbss_IG$Age_BL_z = scale(subjects_tbss_IG$Age_BL)
subjects_tbss_KG$Age_BL_z = scale(subjects_tbss_KG$Age_BL)

subjects_tbss_incl_fu2_IG$Age_BL_z = scale(subjects_tbss_incl_fu2_IG$Age_BL)
subjects_tbss_incl_fu2_KG$Age_BL_z = scale(subjects_tbss_incl_fu2_KG$Age_BL)


write.table(subjects_tbss_IG, "/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_IG_for_randomise_corrected_Age_z.txt", sep="\t", quote = F, row.names=FALSE)
write.table(subjects_tbss_KG, "/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_KG_for_randomise_corrected_Age_z.txt", sep="\t", quote = F, row.names=FALSE)

write.table(subjects_tbss_incl_fu2_IG, "/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_IG_for_randomise_incl_fu2_corrected_Age_z.txt", sep="\t", quote = F, row.names=FALSE)
write.table(subjects_tbss_incl_fu2_KG, "/data/pt_02161/Analysis/Project3_Hyp_DTI/TBSS/subjects_KG_for_randomise_incl_fu2_corrected_Age_z.txt", sep="\t", quote = F, row.names=FALSE)

