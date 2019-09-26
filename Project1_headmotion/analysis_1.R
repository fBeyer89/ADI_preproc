library(lme4)
library(tidyr)
library(haven)
source('/a/share/gr_agingandobesity/literature/methods/statistics/linear_models_course_rogermundry_2018/functions/glmm_stability.r')

subj=read.csv("/data/pt_02161/projects/headmotion/lists/ADI_restingstate.csv")

subj$ID

#write.table(subj$ID, "/data/pt_02161/study_lists/subjectlist.txt", col.names = FALSE,
#            row.names = FALSE, quote = FALSE)

#get BMI data
adi_data=read_sav("/data/p_02161/ADI_studie/metadata/Daten ADI aktuell.sav")
#only bmi
bmi=adi_data[,c("ADI_Code","BMI_BL", "BMI_6m", "BMI_12m")]
bmi$subj.ID=gsub("-", "",bmi$ADI_Code)

#BMI from other table
bmi2=read.csv("/data/p_02161/ADI_studie/metadata/ADI_MRT_Messueberblick_2019_04_10.csv",na.strings=c("","NA"),stringsAsFactors = FALSE)
tmp=bmi2[,c("X.1","BMI","X.2", "BMI.1","X.3","BMI.2")]


tmp$subj.ID = tmp$X.1  # your new merged column start with x
tmp$subj.ID[!is.na(tmp$X.2)] = tmp$X.2[!is.na(tmp$X.2)]  # merge with y
tmp$subj.ID[!is.na(tmp$X.3)] = tmp$X.3[!is.na(tmp$X.3)]  # merge with y

tmp=tmp[,c("subj.ID","BMI","BMI.1","BMI.2")]

abmi=merge(tmp,bmi,by="subj.ID", all=TRUE)
abmi$BMI_BL[is.na(abmi$BMI_BL)]=abmi$BMI[is.na(abmi$BMI_BL)]
abmi$BMI_6m[is.na(abmi$BMI_6m)]=abmi$BMI.1[is.na(abmi$BMI_6m)]
abmi$BMI_12m[is.na(abmi$BMI_12m)]=abmi$BMI.2[is.na(abmi$BMI_12m)]

##results

res=read.csv("/data/pt_02161/projects/headmotion/results/results.csv", header = FALSE)

colnames(res)=c("meanFD_bl","maxFD_bl","meanFD_fu","maxFD_fu","meanFD_fu2","maxFD_fu2")

data=data.frame(subj$ID,res, subj$condition)

data[data==0]=NA

###check that correct number of subjects are available
length(data[!is.na(data$meanFD_bl),"subj.ID"])
length(data[!is.na(data$meanFD_fu),"subj.ID"])
length(data[!is.na(data$meanFD_fu2),"subj.ID"])

#merge data with bmi
data=merge(data,abmi, by = "subj.ID", all.x=TRUE)

##missing BMI data of some participants
data[is.na(data$BMI_BL),"subj.ID"]



ldata <- data %>% gather(tp, meanFD, meanFD_bl,meanFD_fu, meanFD_fu2) %>% separate(tp, c("measure", "tp"))

lldata <-data  %>% gather(tp, maxFD, maxFD_bl,maxFD_fu, maxFD_fu2) %>% separate(tp, c("measure", "tp"))

lbmi <- data %>% gather(tp, BMI, BMI_BL, BMI_6m, BMI_12m) #%>% separate(tp, c("measure", "tp"))



#combine both
fdata=data.frame(lldata$subj.ID,lldata$tp, lldata$subj.condition, ldata$meanFD, lldata$maxFD, lbmi$BMI)
colnames(fdata)=c("subj.ID", "tp", "condition", "meanFD", "maxFD", "BMI")


fdata$logmeanFD=log10(fdata$meanFD)

###MAIN ANALYSIS

#Main analysis:
#H0: Bariatric surgery, i.e. BMI reduction, does not lead to a reduction in rsfMRI head motion.
#Alternative H1: Significant interaction of pre-6mo, 12mo timepoints with group on mean FD.

#R formulation: 
R1= lmer(logmeanFD ~ tp*condition + (1|subj.ID), data=fdata)

summary(R1)

##diagnostics
diagnostics.plot(R1)
ranef.diagn.plot(R1)

contr=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000))
m.stab=glmm.model.stab(model.res=R1, contr=contr)#model stability
m.stab$detailed$warnings #no warnings
m.stab$summary

Null = lmer(logmeanFD ~ tp + (1|subj.ID), data=fdata)
anova(R1,Null,test="Chisq")

#plot the result 

#distribution
p <- ggplot(aes(x = tp, y=logmeanFD),data=fdata)+ geom_violin() + geom_point()
p

#spaghetti plot of individual subjects
tspag = ggplot(fdata, aes(x=tp, y=logmeanFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID)) + guides(colour=TRUE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="none")

#with BMI loss
tspag = ggplot(fdata, aes(x=BMI, y=logmeanFD,group=subj.ID)) + 
  geom_line(aes(color=subj.ID)) + guides(colour=TRUE)
tspag + theme(axis.text=element_text(size=10),axis.title=element_text(size=12),strip.text = element_text(size=12),legend.position="none")

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

#plot comparing both groups
tspag = ggplot(fdata, aes(x=tp, y=logmeanFD, color=condition, group=condition)) +
        geom_point() +
        stat_summary(fun.y = mean, geom = "point") +
        stat_summary(fun.y = mean, geom = "line")
tspag + theme(axis.text=element_text(size=10),
              axis.title=element_text(size=12),
              strip.text = element_text(size=12),
              legend.position="top")

tspag = ggplot(fdata, aes(x=tp, y=logmeanFD, color=condition, group=condition)) +
  geom_point() +
  stat_summary(fun.y = mean, geom = "point") +
  stat_summary(fun.y = mean, geom = "line")
tspag + theme(axis.text=element_text(size=10),
              axis.title=element_text(size=12),
              strip.text = element_text(size=12),
              legend.position="top")

# -> reduced head motion in the intervention compared to control group!!!

##how many complete cases are there for control and intervention group?
cc=data[complete.cases(data),]
nrow(cc)
#IG-> 11
#KG-> 10

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

#mean BMI in subject
mean.bmi.p.subj=tapply(X=fdata$BMI,
                       INDEX=fdata$subj.ID, FUN=mean)
fdata$mean.bmi.p.subj=
  mean.bmi.p.subj[as.numeric(fdata$subj.ID)]

#variation in BMI within subject (+/- difference to mean)
fdata$within.bmi.p.subj=
  fdata$BMI-fdata$mean.bmi.p.subj


#not possible to model random effects of within-subject slope (only 2 measurements)
res=lmer(logmeanFD ~  mean.bmi.p.subj + within.bmi.p.subj + (1 |subj.ID),
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

Null = lmer(logmaxFD ~ tp + (1|subj.ID), data=fdata)
anova(R1,Null,test="Chisq")

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

#plot comparing both groups
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

#plot comparing both groups
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
