library(httr)
library(jsonlite)
library(data.table)

years <- 2007:2019

teams <- vector()
for (i in years) {
  tempdata <- read.csv(paste(as.character(i), ".csv", sep = ""))
  teams <- append(teams, tempdata$Team)
}

uniqueteams <- unique(teams)

m <- getwd()

for (j in uniqueteams) {
  umatrix <- matrix(,nrow=0,ncol=4)
  for (k in years) {
    tempdata <- read.csv(paste(as.character(k), ".csv", sep = ""))
    tempteams <- tempdata$Team
    opr <- tempdata$OPR
    dpr <- tempdata$DPR
    ccwm <- tempdata$CCWM
    for (l in 1:length(tempteams)) {
      if (tempteams[l]==paste("frc",j,sep="")) {
        umatrix <- rbind(umatrix, c(k,opr[l],dpr[l],ccwm[l]))
      }
    }
  }
  colnames(umatrix) <- c("Team", "OPR", "DPR", "CCWM")
  write.csv(umatrix,file=paste(m,"/Teams/",j,".csv",sep=""),row.names=FALSE)
}