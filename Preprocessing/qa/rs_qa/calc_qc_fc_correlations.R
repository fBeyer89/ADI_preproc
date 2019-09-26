##Subjects
subjects=c('ADI005_fu2','ADI007_bl', 'ADI014_fu', 'ADI014_fu2','ADI016_fu',
       'ADI016_fu2', 'ADI020_bl','ADI020_fu','ADI020_fu2','ADI036_fu', 
       'ADI046_fu','ADI046_fu2','ADI049_fu','ADI049_fu2','ADI050_fu2',
       'ADI053_fu','ADI061_bl','ADI061_fu','ADI061_fu2', 'ADI062_bl',
       'ADI062_fu','ADI064_fu','ADI064_fu2', 'ADI082_fu2','ADI087_bl',
       'ADI088_fu2','ADI093_fu','ADI095_fu', 'ADI111_bl','ADI111_fu',
       'ADI111_fu2','ADI124_bl','ADI124_fu','ADI139_bl','ADI140_fu',
       'ADI140_fu2')

#read mean FD values
fd=read.csv("/data/pt_02161/projects/headmotion/results/ADI_meanFD.csv")
colnames(fd)=c("X",'subj.ID', "meanFD.bl","meanFD.fu", "meanFD.fu2")
wide <- reshape(fd, varying=c("meanFD.bl","meanFD.fu", "meanFD.fu2"),
                idvar=c('subj.ID'), ids="test",direction='long')

#create matrix with columns = subj and row = meanFD vals
allfd<-c()
for (subj in subjects){
  tmp=strsplit(subj,'_')
  allfd=c(allfd, wide[wide$subj.ID==tmp[[1]][1]&wide$time==tmp[[1]][2], "meanFD"]) 
}

min=NULL
aroma_cc=NULL
aroma_cc_gsr=NULL

for (subj in subjects){
print(subj)
fc=read.csv(paste("/data/pt_02161/preprocessed/resting/detailedQA/Power264conn/", subj, "/connvals.txt", sep=""),header=TRUE)
min = rbind(min, fc[,1])
aroma_cc = rbind(aroma_cc, fc[,2])
aroma_cc_gsr = rbind(aroma_cc_gsr, fc[,3])
}

#use only those connections that are not zero in any
min[aroma_cc==0|aroma_cc_gsr==0]<-NA
aroma_cc[aroma_cc==0|aroma_cc_gsr==0]<-NA
aroma_cc_gsr[aroma_cc==0|aroma_cc_gsr==0]<-NA

fdqc=c()
pvals=c()
x=min
for (i in (1:34716)){
      #print(i)
      if (sum(is.na(x[,i]))/length(subjects)>0.2){
        #print("not enough data for this connection")
      } else {
        temp=cor.test(x[,i],allfd, na.action=TRUE)
        pvals=c(pvals,temp$p.value)
        fdqc=c(fdqc,temp$estimate)
      }
        

}

#more NAs than useful data in
34716-length(fdqc)

hist(fdqc)
mean(fdqc)
median(fdqc)

#fdqc_aroma_gsr<-fdqc
#fdqc_aroma_cc<-fdqc
##
#adjusted p-values: 
padjusted=p.adjust(pvals, method="BH")
length(pvals[pvals<0.05]) #min: 1845, aroma_cc: 4383, aroma_cc_gsr: 2771
length(pvals[padjusted<0.05])
