library(lme4)
library(ggplot2)
library(haven)
library(plyr)
library(dplyr)
library(tidyr)
library(psych)
library(MuMIn)
library(lmerTest)

source('/a/share/gr_agingandobesity/literature/methods/statistics/linear_models_course_rogermundry_2018/functions/glmm_stability.r')
source('/a/share/gr_agingandobesity/literature/methods/statistics/linear_models_course_rogermundry_2018/functions/diagnostic_fcns.r')

##helper functions for within-subject error taken from 
#http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/#Helper%20functions

source("/data/pt_02161/Analysis/Project1_headmotion/helper_functions_withingroup.R")



#PREPARE DATA
#############################################################################################
#get BMI data from different ADI tables
adi_data=read_sav("/data/p_02161/ADI_studie/metadata/Daten ADI aktuell.sav")
#only bmi
bmi=adi_data[,c("ADI_Code","BMI_BL", "BMI_6m", "BMI_12m", "Sex", "Age_BL","Age_6m", "Age_12m", "Educa_BL" )]
bmi$subj.ID=gsub("-", "",bmi$ADI_Code)

#BMI from other table
bmi2=read.csv("/data/p_02161/ADI_studie/metadata/ADI_MRT_Messueberblick_2019_04_10.csv",na.strings=c("","NA"),stringsAsFactors = FALSE)
tmp=bmi2[,c("X.1","BMI","X.2", "BMI.1","X.3","BMI.2", "Geschlecht", "Alter")]

tmp$subj.ID = tmp$X.1  # your new merged column start with x
tmp$subj.ID[!is.na(tmp$X.2)] = tmp$X.2[!is.na(tmp$X.2)]  # merge with y
tmp$subj.ID[!is.na(tmp$X.3)] = tmp$X.3[!is.na(tmp$X.3)]  # merge with y

tmp=tmp[,c("subj.ID","BMI","BMI.1","BMI.2","Geschlecht", "Alter")]

#replace some missing BMI values
abmi=merge(tmp,bmi,by="subj.ID", all=TRUE)
abmi$BMI_BL[is.na(abmi$BMI_BL)]=abmi$BMI[is.na(abmi$BMI_BL)]
abmi$BMI_6m[is.na(abmi$BMI_6m)]=abmi$BMI.1[is.na(abmi$BMI_6m)]
abmi$BMI_12m[is.na(abmi$BMI_12m)]=abmi$BMI.2[is.na(abmi$BMI_12m)]

#compare abmi with bmi from list-> looks fine
QOL_sheet=read.csv("/data/pt_02161/Results/Project1_headmotion/results/QOL_sheet_of_ADI_Messueberblick.csv")
QOL_sheet$subj.ID=gsub("-", "",QOL_sheet$X.1)

QOL_sheet$condition="IG"
QOL_sheet[QOL_sheet$X=="KG","condition"]="KG"
adi_group=QOL_sheet[,c("subj.ID","condition")]

bmi_compare=merge(QOL_sheet, abmi,by="subj.ID", all=TRUE)
sum(bmi_compare$BMI.BL-bmi_compare$BMI_BL,na.rm = T)
sum(bmi_compare$BMI.FU-bmi_compare$BMI_6m,na.rm = T)
sum(bmi_compare$BMI.FU_2-bmi_compare$BMI_12m,na.rm = T)

#get fd values
subj=read.csv("/data/pt_02161/Results/Project1_headmotion/results/subjects_rs.csv")
colnames(subj)[1]="subj.ID"

#and their respective FD vals
res=read.csv("/data/pt_02161/Results/Project1_headmotion/results/summary_FDvals_based_on_subjects_rs.csv", header = FALSE)

colnames(res)=c("meanFD_bl","maxFD_bl","meanFD_fu","maxFD_fu","meanFD_fu2","maxFD_fu2")

data=data.frame(subj$subj.ID,res)
colnames(data)[1]="subj.ID"
data[data==0]=NA

#merge data with group & find group for those that are not in QOL table
data=merge(data,adi_group, by = "subj.ID", all.x=TRUE)

#this table has errors (contradictions for ADI080 and ADI036 with other table, but contains missing subjects)
group_coding_with_errors=read.csv("/data/pt_02161/Results/Project1_headmotion/results/summary_with_SPSS_data_sheet_of_ADI_Messueberblick.csv")
group_coding_with_errors$subj.ID=gsub("-", "",group_coding_with_errors$Copy.SPSS)

group_for_replacement=merge(data[is.na(data$condition),],group_coding_with_errors, all.x=TRUE, by="subj.ID")
data[is.na(data$condition),"condition"]=as.factor(group_for_replacement$Gruppe)
data$condition=as.factor(data$condition)
levels(data$condition)=c("IG","KG","IG","KG")


#merge data with bmi
data=merge(data,abmi, by = "subj.ID", all.x=TRUE)

#remove one subject that has only NA values
data[data$subj.ID=="ADI002",]
data=data[data$subj.ID!="ADI002",]
data$subj.ID=droplevels(data$subj.ID)

#bring data from wide to long format
ldata <- data %>% gather(tp, meanFD, meanFD_bl,meanFD_fu, meanFD_fu2) %>% separate(tp, c("measure", "tp"))

lldata <-data  %>% gather(tp, maxFD, maxFD_bl,maxFD_fu, maxFD_fu2) %>% separate(tp, c("measure", "tp"))

lbmi <- data %>% gather(tp, BMI, BMI_BL, BMI_6m, BMI_12m) #%>% separate(tp, c("measure", "tp"))

#Could also reshape like this.
#dat <- reshape(dat, varying=c('measure.1', 'measure.2', 'measure.3', 'measure.4'), 
#               idvar='subject.id', direction='long')

#combine both
fdata=data.frame(lldata$subj.ID,lldata$tp, lldata$condition,lldata$Geschlecht, lldata$Alter, lldata$Educa_BL, ldata$meanFD, lldata$maxFD, lbmi$BMI)
colnames(fdata)=c("subj.ID", "tp", "condition", "sex", "Age_bl", "Educa_BL", "meanFD", "maxFD", "BMI")


fdata$logmeanFD=log10(fdata$meanFD)
fdata$condition=relevel(fdata$condition, "KG")
fdata$condition=droplevels(fdata$condition)


#############################################################################################

##DEMOGRAPHICS
#NUMBER of individuals
length((fdata$subj.ID))

t=fdata[fdata$tp=="bl",]

#one subject does not have baseline BMI
data[is.na(data$BMI_BL),"subj.ID"]

#distribution of individuals into groups
table(fdata[unique(fdata$subj.ID),"condition"])

#scanned at baseline
table(fdata[fdata$tp=="bl"&!is.na(fdata$meanFD),"condition"])

#demographics 
#sex
d.summary.extended <- t %>%
  select(Age_bl, Educa_BL, BMI, condition, sex) %>%
  group_by (condition,sex) %>%
  summarise_each(funs(n=n())) %>%
  print()

#summary of age and BMI without ADI095
d.summary.extended <- t[t$subj.ID!="ADI095",] %>%
  select(Age_bl, BMI, condition) %>%
  group_by (condition) %>%
  summarise_each(funs(mean=mean, median=median, sd=sd, n=n())) %>%
  print()


#(not relevant for paper)
###check that correct number of subjects are available
length(data[!is.na(data$meanFD_bl),"subj.ID"])
length(data[!is.na(data$meanFD_fu),"subj.ID"])
length(data[!is.na(data$meanFD_fu2),"subj.ID"])

##how many complete cases are there for control and intervention group?
cc=data[complete.cases(data),]
table(cc$condition)
nrow(cc)
#IG-> 11
#KG-> 10

###MAIN ANALYSIS

#Main analysis:
#H0: Bariatric surgery, i.e. BMI reduction, does not lead to a reduction in rsfMRI head motion.
#Alternative H1: Significant interaction of pre-6mo, 12mo timepoints with group on mean FD.

#R formulation: 
R1= lmer(logmeanFD ~ tp*condition + (1|subj.ID), data=fdata)

summary(R1)
r.squaredGLMM(R1)
##diagnostics
diagnostics.plot(R1)
ranef.diagn.plot(R1)

contr=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000))
m.stab=glmm.model.stab(model.res=R1, contr=contr)#model stability
m.stab$detailed$warnings #no warnings
m.stab$summary

Null = lmer(logmeanFD ~ tp + condition + (1|subj.ID), data=fdata)
anova(R1,Null,test="Chisq")

##significance of other terms in the model
R1_forp=lmerTest::as_lmerModLmerTest(R1)

#there is a significant group difference
R2= lmer(logmeanFD ~ tp + condition + (1|subj.ID), data=fdata)
summary(R2)
Null2= lmer(logmeanFD ~ tp + (1|subj.ID), data=fdata)
anova(R2,Null2,test="Chisq")

#without the logarithmic scale -> not significant.
R3= lmer(meanFD ~ tp * condition + (1|subj.ID), data=fdata)
summary(R3)
Null3= lmer(meanFD ~ tp + condition + (1|subj.ID), data=fdata)
anova(R3,Null3,test="Chisq")

##Did the average head motion of control participants change?
#No.
R1= lmer(logmeanFD ~ tp + (1|subj.ID), data=fdata[fdata$condition=="KG",])
Null= lmer(logmeanFD ~ (1|subj.ID), data=fdata[fdata$condition=="KG",])
anova(R1,Null)

##Did the head motion of IG increase from fu1 to fu2? (question of reviewer)
comp_fu_fu2=fdata[fdata$condition=="IG"&(fdata$tp=="fu"|fdata$tp=="fu2"),]
comp_fu_fu2$tp=droplevels(comp_fu_fu2$tp)
R1= lmer(logmeanFD ~ tp + (1|subj.ID), data=comp_fu_fu2)
summary(R1)
R0=lmer(logmeanFD ~ (1|subj.ID), data=comp_fu_fu2)
summary(R0)
anova(R1,R0)

#### Revision2: in some participants head motion increases from fu to fu2 while BMI decreases.   
#24 participants have fu, 20 have fu2 -> 44 observations on 26 unique subjects.
#nrow(comp_fu_fu2_c[comp_fu_fu2_c$tp=="fu",])
#nrow(comp_fu_fu2_c[comp_fu_fu2_c$tp=="fu2",])

#but in total 24 participants have both fu and fu2 (two have none, or only one timepoint)
comp_fu_fu2_c=comp_fu_fu2[!is.na(comp_fu_fu2$meanFD),]
fordiff=merge(comp_fu_fu2_c[comp_fu_fu2_c$tp=="fu",], comp_fu_fu2_c[comp_fu_fu2_c$tp=="fu2",], by="subj.ID", all.x = TRUE)
fordiff$diff_meanFD=fordiff$meanFD.x-fordiff$meanFD.y
fordiff$diff_BMI=fordiff$BMI.x-fordiff$BMI.y
#number of meanfd difference smaller/larger 0
nrow(fordiff[fordiff$diff_meanFD>0&!is.na(fordiff$diff_meanFD),])
nrow(fordiff[fordiff$diff_meanFD<0&!is.na(fordiff$diff_meanFD),])

hist(fordiff$diff_meanFD, breaks = 20, xlab="Mean FD difference fu-fu2 [mm]", main = "", 
     cex.axis=1.2, cex.lab=1.2)

par(mar=c(1,1,1,1))
png("/home/raid1/fbeyer/Documents/Results/ADI_study/results/head_motion/hbm/Revision2.png", width=4, height=4, units="in", res=300)
plot(fordiff$diff_BMI, fordiff$diff_meanFD, 
     ylab="FD difference fu-fu2 [mm]",
     xlab="BMI difference fu-fu2 [kg/m2]",
     main = "", 
     col=ifelse(fordiff$diff_BMI>2&fordiff$diff_meanFD<0, "red","black"),
     cex.axis=1.2, cex.lab=1.2)
dev.off()


#individuals who lose weight but do not reduce head motion
fordiff[fordiff$diff_meanFD<0&!is.na(fordiff$diff_meanFD)&fordiff$diff_BMI>2,c("subj.ID","meanFD.x","meanFD.y","BMI.x","BMI.y")]
subsample=fordiff[fordiff$diff_meanFD<0&!is.na(fordiff$diff_meanFD)&fordiff$diff_BMI>2,c("subj.ID","diff_BMI")]
subsample_d=merge(subsample, fdata, by="subj.ID", all.x=TRUE)
subsample_d[subsample_d$tp=="0", "within.mfd.p.subj"]
#BMI at bl
mean(subsample_d[subsample_d$tp=="0","BMI"])
mean(subsample_d[subsample_d$tp=="0","Age_bl"])
#BMI lost bl-fu
subsample_d[subsample_d$tp=="0","BMI"]-subsample_d[subsample_d$tp=="6","BMI"]
mean(subsample_d[subsample_d$tp=="0","BMI"]-subsample_d[subsample_d$tp=="6","BMI"])
subsample_d[subsample_d$tp=="0","meanFD"]-subsample_d[subsample_d$tp=="6","meanFD"]

  #for all intervention group participants.
mean(fdata[fdata$condition=="IG"&fdata$tp=="0","BMI"],na.rm = TRUE)
mean(fdata[fdata$condition=="IG"&fdata$tp=="0","Age_bl"],na.rm = TRUE)
comp=merge(fdata[fdata$condition=="IG"&fdata$tp=="0"&!is.na(fdata$BMI),c("subj.ID","tp","BMI")],
           fdata[fdata$condition=="IG"&fdata$tp=="6"&!is.na(fdata$BMI),c("subj.ID","tp","BMI")],
           by="subj.ID",all.x=TRUE)
comp$diff=comp$BMI.x-comp$BMI.y
mean(comp$diff,na.rm = TRUE)

#create variable within fdata to compare
fdata_bl_IG=fdata[fdata$condition=="IG"&fdata$tp=="0",]
subsample$subsampleID=1
fdata_bl_IG=merge(fdata_bl_IG,subsample[,c("subj.ID","subsampleID")],by="subj.ID",all = TRUE)
fdata_bl_IG$subsampleID[is.na(fdata_bl_IG$subsampleID)]=0

#compare BMI&Age
mean(fdata_bl_IG[fdata_bl_IG$subsampleID==1,"BMI"])
mean(fdata_bl_IG[fdata_bl_IG$subsampleID==0,"BMI"],na.rm=TRUE)
R1=lm(BMI~subsampleID, data=fdata_bl_IG)
summary(R1)
R2=lm(Age_bl~subsampleID, data=fdata_bl_IG)
summary(R2)

######################
#########PLOT FOR PAPER
######################
#use within subject error bars: http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/#Helper%20functions
tgc <- summarySEwithin(fdata, measurevar="logmeanFD",withinvars="tp",
                       idvar="subj.ID", betweenvars="condition",na.rm=TRUE, conf.interval=.95)

#relevel tp according to suggestion by Dr. Colomb
tgc$tp=revalue(tgc$tp, c("bl"="0", "fu"="6", "fu2"="12"))
fdata$tp=revalue(fdata$tp, c("bl"="0", "fu"="6", "fu2"="12"))
tgc$condition=revalue(tgc$condition, c("KG"="CG"))
fdata$condition=revalue(fdata$condition, c("KG"="CG"))
ggplot(tgc, aes(x=tp, y=logmeanFD, group=condition, color=condition)) +
  geom_line() +
  geom_point(aes(x=tp, y=logmeanFD, color=condition, group=condition), data=fdata) +
  geom_errorbar(width=.1, aes(ymin=logmeanFD-ci, ymax=logmeanFD+ci), data=tgc) +
  geom_point(shape=21, size=3, fill="white")+
  xlab("time after surgery [months]")+
  #xlab("Monate nach bariatrischer OP") + (for defense)
  ylab("log(mean FD) [mm]")+
  #ylab("Kopfbewegung im MRT in mm")+ (for defense)
  theme(axis.text=element_text(colour = "black",size=10),
        axis.title=element_text(size=12),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        strip.text = element_text(size=14),
        legend.position="top",
        legend.title = element_text( size = 12),
        legend.text = element_text( size = 12))

#ggsave("/data/pt_02161/Results/Project1_headmotion/results/Figure1.eps", width = 80, units = "mm", dpi = 300)
#ggsave("/home/raid1/fbeyer/Documents/Praesis/Defense/barOP.jpeg", width = 80, units = "mm", dpi = 300)

###################
#DIFFERENT PLOTS to further investigate results
##################

#distribution
p <- ggplot(aes(x = tp, y=logmeanFD),data=fdata)+ geom_violin() + geom_point()
p

#spaghetti plot of individual subjects
tspag = ggplot(fdata, aes(x=tp, y=logmeanFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID)) + geom_point(aes(color=subj.ID)) +guides(colour=TRUE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="none")

tspag = ggplot(fdata, aes(x=tp, y=logmeanFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID)) + 
  geom_point(aes(color=subj.ID))+ 
  facet_grid(. ~ condition)+ guides(colour=TRUE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="none")


#with BMI loss
tspag = ggplot(fdata, aes(x=BMI, y=logmeanFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID))+ 
  geom_point(aes(color=subj.ID, shape=tp, size=0.0001, alpha = 0.5))+ 
  facet_grid(. ~ condition) + 
  guides(color = FALSE, alpha=FALSE, size=FALSE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="top")

#for intervention group only
tspag = ggplot(fdata[fdata$condition=="IG",], aes(x=BMI, y=logmeanFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID)) + geom_point()+ guides(colour=TRUE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="none")

length(unique(fdata[fdata$condition=="IG"&!is.na(fdata$logmeanFD)&!is.na(fdata$BMI),"subj.ID"]))

#for control group
tspag = ggplot(fdata[fdata$condition=="KG",], aes(x=BMI, y=logmeanFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID)) + geom_point()+ guides(colour=TRUE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="none")

tspag = ggplot(fdata[fdata$condition=="KG",], aes(x=tp, y=logmeanFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID)) + geom_point() + guides(colour=TRUE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="none")

length(unique(fdata[fdata$condition=="KG"&!is.na(fdata$logmeanFD)&!is.na(fdata$BMI),"subj.ID"]))

##WITHIN-BETWEEN VARIABILITY ANALYSIS##

#We will perform a more detailed analysis to disentangle the contributions of 
#within- and between-subject BMI variation. 
#If head motion was a trait, there should be no effect of within-subject BMI change on mean FD. 
#Yet, BMI-related, between-subject variation in head motion would still be possible, 
#e.g. due to differences in breathing amplitude that go along with differences in BMI. 
#If higher head motion is mainly a consequence of obesity, there should be an additional 
#effect of the within-subject BMI reduction (participants, who lost more weight, should move much less).

#H0: There is no effect of within-subject BMI variation on head motion.
#Alternative H1: there is a significant effect of within-subject BMI variation on mean FD.

#plot comparing both groups
tspag = ggplot(fdata, aes(x=tp, y=BMI, color=condition, group=condition)) +
  geom_point() +
  stat_summary(fun.y = mean, geom = "point") +
  stat_summary(fun.y = mean, geom = "line")
tspag + theme(axis.text=element_text(size=10),
              axis.title=element_text(size=12),
              strip.text = element_text(size=12),
              legend.position="top")
tspag
#mean BMI in subject
mean.bmi.p.subj=tapply(X=fdata$BMI,
                       INDEX=fdata$subj.ID, FUN=mean, na.rm=TRUE)
fdata$mean.bmi.p.subj=
  mean.bmi.p.subj[as.numeric(fdata$subj.ID)]

#variation in BMI within subject (+/- difference to mean)
fdata$within.bmi.p.subj=
  fdata$BMI-fdata$mean.bmi.p.subj


#not possible to model random effects of within-subject slope (only 2 measurements)
res=lmer(logmeanFD ~  mean.bmi.p.subj + within.bmi.p.subj + (1 |subj.ID),
         data=fdata, REML=F)
summary(res)
r.squaredGLMM(res)
#diagnostics and convergence
diagnostics.plot(res)
ranef.diagn.plot(res)

m.stab=glmm.model.stab(model.res = res)
#to check whether there were any converge issues:
table(m.stab$detailed$warnings)
m.stab$summary

#null model. significant effect of ind. variation in BMI
null=lmer(logmeanFD ~  mean.bmi.p.subj + (1 |subj.ID),
          data=fdata, REML=F)#the intercept is included by default. If you want to exclude it you would do R ~ 0 + ...
summary(null)
as.data.frame(anova(res,null,test="Chisq"))

################################################
################################################
################################################
################################################
#Repeat analysis for maximal FD.
#Main analysis:
#H0: Bariatric surgery, i.e. BMI reduction, does not lead to a reduction in rsfMRI head motion.
#Alternative H1: Significant interaction of pre-6mo, 12mo timepoints with group on mean FD.

#R formulation: 
fdata$logmaxFD=log10(fdata$maxFD)
R1= lmer(logmaxFD ~ tp*condition + (1|subj.ID), data=fdata)

summary(R1)

##diagnostics
diagnostics.plot(R1)
ranef.diagn.plot(R1)

contr=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000))
m.stab=glmm.model.stab(model.res=R1, contr=contr)#model stability
m.stab$detailed$warnings #no warnings
m.stab$summary

Null = lmer(logmaxFD ~ tp + condition + (1|subj.ID), data=fdata)
anova(R1,Null,test="Chisq")

#explained variance (marginal: variance explained by fixed effects)
r.squaredGLMM(R1)

#plot the result 

#distribution
p <- ggplot(aes(x = tp, y=logmaxFD),data=fdata)+ geom_violin() + geom_point()
p

#spaghetti plot of individual subjects
tspag = ggplot(fdata, aes(x=tp, y=logmaxFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID)) + geom_point() + guides(colour=TRUE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="none")

#with BMI loss
tspag = ggplot(fdata, aes(x=BMI, y=logmaxFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID)) + guides(colour=TRUE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="none")

#for intervention group only
tspag = ggplot(fdata[fdata$condition=="IG",], aes(x=BMI, y=logmaxFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID)) + geom_point()+ guides(colour=TRUE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="none")

length(unique(fdata[fdata$condition=="IG"&!is.na(fdata$logmaxFD)&!is.na(fdata$BMI),"subj.ID"]))

#for control group
tspag = ggplot(fdata[fdata$condition=="KG",], aes(x=BMI, y=logmaxFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID)) + geom_point()+ guides(colour=TRUE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="none")

tspag = ggplot(fdata[fdata$condition=="KG",], aes(x=tp, y=logmaxFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID)) + geom_point() + guides(colour=TRUE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="none")

length(unique(fdata[fdata$condition=="KG"&!is.na(fdata$logmaxFD)&!is.na(fdata$BMI),"subj.ID"]))

#plot comparing logmaxFD across both groups
tspag = ggplot(fdata, aes(x=tp, y=logmaxFD, color=condition, group=condition)) +
  geom_point() +
  stat_summary(fun.y = mean, geom = "point") +
  stat_summary(fun.y = mean, geom = "line")
tspag + theme(axis.text=element_text(size=10),
              axis.title=element_text(size=12),
              strip.text = element_text(size=12),
              legend.position="top")

#We will perform a more detailed analysis to disentangle the contributions of 
#within- and between-subject BMI variation. 
#If head motion was a trait, there should be no effect of within-subject BMI change on mean FD. 
#Yet, BMI-related, between-subject variation in head motion would still be possible, 
#e.g. due to differences in breathing amplitude that go along with differences in BMI. 
#If higher head motion is mainly a consequence of obesity, there should be an additional 
#effect of the within-subject BMI reduction (participants, who lost more weight, should move much less).

#H0: There is no effect of within-subject BMI variation on head motion.
#Alternative H1: there is a significant effect of within-subject BMI variation on mean FD.

#Plot comparing BMI change in both groups
tspag = ggplot(fdata, aes(x=tp, y=BMI, color=condition, group=condition)) +
  geom_point() +
  stat_summary(fun.y = mean, geom = "point") +
  stat_summary(fun.y = mean, geom = "line")
tspag + theme(axis.text=element_text(size=10),
              axis.title=element_text(size=12),
              strip.text = element_text(size=12),
              legend.position="top")

#mean BMI in subject
mean.bmi.p.subj=tapply(X=fdata$BMI,
                       INDEX=fdata$subj.ID, FUN=mean)
fdata$mean.bmi.p.subj=
  mean.bmi.p.subj[as.numeric(fdata$subj.ID)]

#variation in BMI within subject (+/- difference to mean)
fdata$within.bmi.p.subj=
  fdata$BMI-fdata$mean.bmi.p.subj


#not possible to model random effects of within-subject slope (only 2 measurements)
res=lmer(logmaxFD ~  mean.bmi.p.subj + within.bmi.p.subj + (1 |subj.ID),
         data=fdata, REML=F)
summary(res)
#diagnostics and convergence
diagnostics.plot(res)
ranef.diagn.plot(res)

m.stab=glmm.model.stab(model.res = res)
#to check whether there were any converge issues:
table(m.stab$detailed$warnings)
m.stab$summary

#null model. significant effect of ind. variation in BMI
null=lmer(logmaxFD ~  mean.bmi.p.subj + (1 |subj.ID),
          data=fdata, REML=F)#the intercept is included by default. If you want to exclude it you would do R ~ 0 + ...
summary(null)
as.data.frame(anova(res,null,test="Chisq"))

r.squaredGLMM(res)

#with BMI loss
tspag = ggplot(fdata, aes(x=BMI, y=logmaxFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID))+ 
  geom_point(aes(color=subj.ID, shape=tp, size=0.0001, alpha = 0.5))+ 
  facet_grid(. ~ condition) + 
  guides(color = FALSE, alpha=FALSE, size=FALSE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="top")


##REVISION figure
#BMI change and logmeanFD change.
fdata$tp=revalue(fdata$tp, c("bl"="0", "fu"="6", "fu2"="12"))
fdata$condition=revalue(fdata$condition, c("KG"="CG"))
tspag = ggplot(fdata, aes(x=BMI, y=logmeanFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID))+ 
  ylab("log(mean FD) (mm)") +
  xlab("BMI" ~ (kg/m^2)) +
  xlim(30,55) +
  labs(shape="time after surgery (months)") +
  geom_point(aes(color=subj.ID, shape=tp), size=3, alpha = 0.5)+ 
  #geom_smooth(aes(x=BMI, y=logmeanFD,group=subj.ID),method="auto", level=0.2) +
  facet_grid(. ~ condition) + 
  guides(color = FALSE, alpha=FALSE, size=FALSE)
tspag + theme(axis.text=element_text(colour = "black",size=10),
              axis.title=element_text(size=14),
              axis.text.x = element_text(size=12),
              axis.text.y = element_text(size=12),
              strip.text = element_text(size=14),
              legend.position="top",
              legend.title = element_text( size = 14),
              legend.text = element_text( size = 14))
#ggsave("/home/raid1/fbeyer/Documents/Results/ADI_study/results/head_motion/hbm/Figure_2b.eps", device=cairo_ps)

#ggsave("/home/raid1/fbeyer/Documents/Results/ADI_study/results/head_motion/hbm/Figure_S1.png")

##other way
#mean BMI in subject
mean.mfd.p.subj=tapply(X=fdata$logmeanFD,
                       INDEX=fdata$subj.ID, FUN=mean, na.rm=TRUE)
fdata$mean.mfd.p.subj=
  mean.mfd.p.subj[as.numeric(fdata$subj.ID)]

#variation in BMI within subject (+/- difference to mean)
fdata$within.mfd.p.subj=
  fdata$logmeanFD-fdata$mean.mfd.p.subj

tspag=ggplot(data=fdata[fdata$tp=="6",], aes(y=within.mfd.p.subj, x=within.bmi.p.subj, color=condition))+
  geom_point(aes(size=4))+
  geom_smooth(method = "lm", colour = "black", linetype = 1, fill = "mistyrose3" ) +
  xlab("within-subject BMI change" ~ (kg/m^2))+
  ylab("within-subject log mean FD change (mm)")+ 
  guides(alpha=FALSE, size=FALSE,
         color = guide_legend(override.aes = list(size=4)))
tspag + theme(axis.text=element_text(colour = "black",size=10),
              axis.title=element_text(size=14),
              axis.text.x = element_text(size=12),
              axis.text.y = element_text(size=12),
              strip.text = element_text(size=14),
              legend.position="top",
              legend.title = element_text( size = 14),
              legend.text = element_text( size = 14))
ggsave("/home/raid1/fbeyer/Documents/Results/ADI_study/results/head_motion/hbm/Figure_2a.eps", width = 100, units = "mm", dpi = 300, device=cairo_ps)
ggsave("/home/raid1/fbeyer/Documents/Results/ADI_study/results/head_motion/hbm/Figure2.png", width = 100, units = "mm")


##correlation of head motion and BMI in rs-sample
rs=read.csv("/data/p_life_results/2017_beyer_rs_BMI/BMI_RSN_analysis/Tables/DATA_USED_FOR_HBM/ipython_notebooks/521_new_SOP_healthy_goodreg_motionok_forANALYSIS_22.4.csv")
fdata[fdata$subj.ID=="ADI009",]
cor.test(fdata[fdata$tp=="12","within.bmi.p.subj"],fdata[fdata$tp=="12","within.mfd.p.subj"])
plot(fdata[fdata$tp=="12","within.bmi.p.subj"],fdata[fdata$tp=="12","within.mfd.p.subj"])
#Revision2: correlation of mean BMI change and meanFD change from fu to fu2