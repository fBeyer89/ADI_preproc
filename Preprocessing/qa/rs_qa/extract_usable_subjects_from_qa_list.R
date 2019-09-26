rs=read.csv("/data/pt_02161/scripts/qa/rs_qa/ADI_rs_qa.csv", header=T, sep=",")

write.table(rs[!is.na(rs$new.AROMA.run),]$Subject, 
          "/data/pt_02161/scripts/qa/rs_qa/all_ADI_for_rsqc.txt",
          col.names=FALSE, row.names=FALSE,quote=FALSE)

##get fd values for these subjects and add them to file
fd=read.csv("/data/pt_02161/projects/headmotion/results/ADI_meanFD.csv")
colnames(fd)=c("X",'subj.ID', "meanFD.bl","meanFD.fu", "meanFD.fu2")
wide <- reshape(fd, varying=c("meanFD.bl","meanFD.fu", "meanFD.fu2"),
                idvar=c('subj.ID'), ids="test",direction='long')
allfd<-c()
for (subj in rs[!is.na(rs$new.AROMA.run),]$Subject){
  tmp=strsplit(subj,'_')
  allfd=c(allfd, wide[wide$subj.ID==tmp[[1]][1]&wide$time==tmp[[1]][2], "meanFD"]) 
}

rs$meanfd=0
rs[!is.na(rs$new.AROMA.run),]$meanfd=allfd

write.csv(rs,"/data/pt_02161/scripts/qa/rs_qa/ADI_rs_qa_withmeanFD.csv")
