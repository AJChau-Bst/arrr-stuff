library(httr)
library(jsonlite)
library(data.table)

years <- 2007:2013

teams <- vector()
for (i in years) {
  tempdata <- read.csv(paste(as.character(i), ".csv", sep = ""))
  teams <- append(teams, tempdata$Team)
}

uniqueteams <- unique(teams)

m <- getwd()
n <- 1
for (j in uniqueteams) {
  umatrix <- matrix(,nrow=0,ncol=4)
  for (k in years) {
    tempdata <- read.csv(paste(as.character(k), ".csv", sep = ""))
    tempteams <- tempdata$Team
    opr <- tempdata$OPR
    dpr <- tempdata$DPR
    ccwm <- tempdata$CCWM
    oprmean <- mean(opr)
    dprmean <- mean(dpr)
    ccwmmean <- mean(ccwm)
    oprsd <- sd(opr)
    dprsd <- sd(dpr)
    ccwmsd <- sd(ccwm)
    for (l in 1:length(tempteams)) {
      if (tempteams[l]==paste("frc",j,sep="")) {
        oprzscore <- (opr[l]-oprmean)/oprsd
        dprzscore <- -(dpr[l]-dprmean)/dprsd
        ccwmzscore <- (ccwm[l]-ccwmmean)/ccwmsd
        umatrix <- rbind(umatrix, c(k,oprzscore,dprzscore,ccwmzscore))
      }
    }
  }
  colnames(umatrix) <- c("Year", "OPR", "DPR", "CCWM")
  write.csv(umatrix,file=paste(m,"/Teams/",j,".csv",sep=""),row.names=FALSE)
  print(paste(paste(floor(100*n/length(uniqueteams)),"%",sep=""),j,sep="     "))
  n=n+1
}