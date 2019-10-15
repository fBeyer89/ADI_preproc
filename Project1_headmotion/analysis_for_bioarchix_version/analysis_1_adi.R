library(lme4)
library(tidyr)
library(haven)
library(dplyr)
library(psych)
library(ggplot2)
source('/a/share/gr_agingandobesity/literature/methods/statistics/linear_models_course_rogermundry_2018/functions/glmm_stability.r')

subj=read.csv("/data/pt_02161/projects/headmotion/lists/ADI_restingstate.csv")

subj$ID

#write.table(subj$ID, "/data/pt_02161/study_lists/subjectlist.txt", col.names = FALSE,
#            row.names = FALSE, quote = FALSE)

#get BMI data
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

##results

res=read.csv("/data/pt_02161/projects/headmotion/results/results.csv", header = FALSE)

colnames(res)=c("meanFD_bl","maxFD_bl","meanFD_fu","maxFD_fu","meanFD_fu2","maxFD_fu2")

data=data.frame(subj$ID,res, subj$condition)

data[data==0]=NA

#merge data with bmi
data=merge(data,abmi, by = "subj.ID", all.x=TRUE)

#write data for Kristin Prehn
#write.csv(data[,c(1,2,4,6)],"/data/pt_02161/projects/headmotion/results/ADI_meanFD.csv")
##missing BMI data of some participants
data[is.na(data$BMI_BL),"subj.ID"]

ldata <- data %>% gather(tp, meanFD, meanFD_bl,meanFD_fu, meanFD_fu2) %>% separate(tp, c("measure", "tp"))

lldata <-data  %>% gather(tp, maxFD, maxFD_bl,maxFD_fu, maxFD_fu2) %>% separate(tp, c("measure", "tp"))

lbmi <- data %>% gather(tp, BMI, BMI_BL, BMI_6m, BMI_12m) #%>% separate(tp, c("measure", "tp"))

#Could also reshape like this.
#dat <- reshape(dat, varying=c('measure.1', 'measure.2', 'measure.3', 'measure.4'), 
#               idvar='subject.id', direction='long')

#combine both
fdata=data.frame(lldata$subj.ID,lldata$tp, lldata$subj.condition,lldata$Geschlecht, lldata$Alter, lldata$Educa_BL, ldata$meanFD, lldata$maxFD, lbmi$BMI)
colnames(fdata)=c("subj.ID", "tp", "condition", "sex", "Age_bl", "Educa_BL", "meanFD", "maxFD", "BMI")


fdata$logmeanFD=log10(fdata$meanFD)
fdata$condition=relevel(fdata$condition, "KG")

##DEMOGRAPHICS
#NUMBER of individuals
#exclude participants with no mean FD values.
t=fdata[!is.na(fdata$meanFD),]

#t[t$subj.ID=="ADI095","BMI"]=fdata[fdata$subj.ID=="ADI095"&fdata$tp=="fu","BMI"]

#distribution of individuals into groups
table(t[unique(t$subj.ID),"condition"])

#print distribution characteristics for everybody
d.summary.extended <- t[unique(t$subj.ID),] %>%
  select(Age_bl, Educa_BL, BMI, condition, sex) %>%
  group_by (condition,sex) %>%
  summarise_each(funs(n=n())) %>%
  print()

#print age statistics for everybody (as Age is the baseline age in the respective table)
d.summary.extended <- t[unique(t$subj.ID),] %>%
  select(Age_bl, Educa_BL,condition) %>%
  group_by (condition) %>%
  summarise_each(funs(mean=mean, median=median, sd=sd, n=n())) %>%
  print()

#print BMI statistics only for those which have BL measurement
nrow(t[t$tp=="bl",]) #37 have baseline assessment, 13 do only have fu, fu2

d.summary.extended <- t[t$tp=="bl",] %>%
  select(BMI,condition) %>%
  group_by (condition) %>%
  summarise_each(funs(mean=mean, median=median, sd=sd, n=n())) %>%
  print()



###check that correct number of subjects are available
length(data[!is.na(data$meanFD_bl),"subj.ID"])
length(data[!is.na(data$meanFD_fu),"subj.ID"])
length(data[!is.na(data$meanFD_fu2),"subj.ID"])
##how many complete cases are there for control and intervention group?

cc=data[complete.cases(data),]
table(cc$subj.condition)
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

##diagnostics
diagnostics.plot(R1)
ranef.diagn.plot(R1)

contr=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000))
m.stab=glmm.model.stab(model.res=R1, contr=contr)#model stability
m.stab$detailed$warnings #no warnings
m.stab$summary

Null = lmer(logmeanFD ~ tp + condition + (1|subj.ID), data=fdata)
anova(R1,Null,test="Chisq")

#plot the result 

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


tgc <- summarySEwithin(fdata, measurevar="logmeanFD",withinvars="tp",
                       idvar="subj.ID", betweenvars="condition",na.rm=TRUE, conf.interval=.95)

ggplot(tgc, aes(x=tp, y=logmeanFD, group=condition, color=condition)) +
  geom_line() +
  geom_point(aes(x=tp, y=logmeanFD, color=condition, group=condition), data=fdata) +
  geom_errorbar(width=.1, aes(ymin=logmeanFD-ci, ymax=logmeanFD+ci), data=tgc) +
  geom_point(shape=21, size=3, fill="white")+
  xlab("timepoint")+
  ylab("log(mean FD)")+
  theme(axis.text=element_text(size=10),
        axis.title=element_text(size=12),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        strip.text = element_text(size=14),
        legend.position="top",
        legend.title = element_text( size = 12),
        legend.text = element_text( size = 12))



####################OLD PLOT COMPARING BOTH GROUPS
##################################################
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

## Norms the data within specified groups in a data frame; it normalizes each
## subject (identified by idvar) so that they have the same mean, within each group
## specified by betweenvars.
##   data: a data frame.
##   idvar: the name of a column that identifies each subject (or matched subjects)
##   measurevar: the name of a column that contains the variable to be summariezed
##   betweenvars: a vector containing names of columns that are between-subjects variables
##   na.rm: a boolean that indicates whether to ignore NA's
normDataWithin <- function(data=NULL, idvar, measurevar, betweenvars=NULL,
                           na.rm=FALSE, .drop=TRUE) {
  library(plyr)
  
  # Measure var on left, idvar + between vars on right of formula.
  data.subjMean <- ddply(data, c(idvar, betweenvars), .drop=.drop,
                         .fun = function(xx, col, na.rm) {
                           c(subjMean = mean(xx[,col], na.rm=na.rm))
                         },
                         measurevar,
                         na.rm
  )
  
  # Put the subject means with original data
  data <- merge(data, data.subjMean)
  
  # Get the normalized data in a new column
  measureNormedVar <- paste(measurevar, "_norm", sep="")
  data[,measureNormedVar] <- data[,measurevar] - data[,"subjMean"] +
    mean(data[,measurevar], na.rm=na.rm)
  
  # Remove this subject mean column
  data$subjMean <- NULL
  
  return(data)
}

## Summarizes data, handling within-subjects variables by removing inter-subject variability.
## It will still work if there are no within-S variables.
## Gives count, un-normed mean, normed mean (with same between-group mean),
##   standard deviation, standard error of the mean, and confidence interval.
## If there are within-subject variables, calculate adjusted values using method from Morey (2008).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   betweenvars: a vector containing names of columns that are between-subjects variables
##   withinvars: a vector containing names of columns that are within-subjects variables
##   idvar: the name of a column that identifies each subject (or matched subjects)
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySEwithin <- function(data=NULL, measurevar, betweenvars=NULL, withinvars=NULL,
                            idvar=NULL, na.rm=FALSE, conf.interval=.95, .drop=TRUE) {
  
  # Ensure that the betweenvars and withinvars are factors
  factorvars <- vapply(data[, c(betweenvars, withinvars), drop=FALSE],
                       FUN=is.factor, FUN.VALUE=logical(1))
  
  if (!all(factorvars)) {
    nonfactorvars <- names(factorvars)[!factorvars]
    message("Automatically converting the following non-factors to factors: ",
            paste(nonfactorvars, collapse = ", "))
    data[nonfactorvars] <- lapply(data[nonfactorvars], factor)
  }
  
  # Get the means from the un-normed data
  datac <- summarySE(data, measurevar, groupvars=c(betweenvars, withinvars),
                     na.rm=na.rm, conf.interval=conf.interval, .drop=.drop)
  
  # Drop all the unused columns (these will be calculated with normed data)
  datac$sd <- NULL
  datac$se <- NULL
  datac$ci <- NULL
  
  # Norm each subject's data
  ndata <- normDataWithin(data, idvar, measurevar, betweenvars, na.rm, .drop=.drop)
  
  # This is the name of the new column
  measurevar_n <- paste(measurevar, "_norm", sep="")
  
  # Collapse the normed data - now we can treat between and within vars the same
  ndatac <- summarySE(ndata, measurevar_n, groupvars=c(betweenvars, withinvars),
                      na.rm=na.rm, conf.interval=conf.interval, .drop=.drop)
  
  # Apply correction from Morey (2008) to the standard error and confidence interval
  #  Get the product of the number of conditions of within-S variables
  nWithinGroups    <- prod(vapply(ndatac[,withinvars, drop=FALSE], FUN=nlevels,
                                  FUN.VALUE=numeric(1)))
  correctionFactor <- sqrt( nWithinGroups / (nWithinGroups-1) )
  
  # Apply the correction factor
  ndatac$sd <- ndatac$sd * correctionFactor
  ndatac$se <- ndatac$se * correctionFactor
  ndatac$ci <- ndatac$ci * correctionFactor
  
  # Combine the un-normed means with the normed results
  merge(datac, ndatac)
}

## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}

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


nres=lmer(logmeanFD ~  mean.bmi.p.subj + within.bmi.p.subj + (1 |subj.ID),
         data=fdata[fdata$condition=="IG",], REML=F)
#diagnostics and convergence
diagnostics.plot(res)
ranef.diagn.plot(res)

m.stab=glmm.model.stab(model.res = res)
#to check whether there were any converge issues:
table(m.stab$detailed$warnings)
m.stab$summary

#null model. significant effect of ind. variation in BMI
null=lmer(logmeanFD ~  mean.bmi.p.subj + (1 |subj.ID),
          data=fdata, REML=T)#the intercept is included by default. If you want to exclude it you would do R ~ 0 + ...
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
