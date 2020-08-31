library(psych)
path="/data/pt_02161/Results/Project2_resting_state/connectivity/PowerRewconn/"
file.names <- dir(path, pattern =".txt")
setwd(path)
res=setNames(data.frame(matrix(ncol = 13, nrow = length(file.names))),c("ID","N_lures_as_similar","N_lures_as_old","N_lures_as_new",
                                                                        "N_new_as_similar","N_new_as_new", "N_new_as_old",
                                                                        "N_old_as_old","N_old_as_new","N_old_as_similar",
                                                                        "N_misses_lures","N_misses_old","N_misses_new"))
for(i in 1:length(file.names)){
  print(file.names[i])
  
  x <- read.table(file.names[i],header=TRUE, nrows=192, fill=TRUE)
