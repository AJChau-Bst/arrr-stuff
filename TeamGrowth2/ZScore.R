library(httr)
library(jsonlite)
library(data.table)

years <- 2007:2009

oprzscore <- vector()
dprzscore <- vector()
ccwmzscore <- vector()
for (year in years) {
  tempdata <- read.csv(paste(as.character(year), ".csv", sep = ""))
  opr <- tempdata$OPR
  oprmean <- mean(opr)
  oprsd <- sd(opr)
  dpr <- tempdata$DPR
  dprmean <- mean(dpr)
  dprsd <- sd(dpr)
  ccwm <- tempdata$CCWM
  ccwmmean <- mean(ccwm)
  ccwmsd <- sd(ccwm)
  for (a in 1:length(opr)) {
    oprzscore <- append(oprzscore,((opr[[a]]-oprmean)/oprsd))
    dprzscore <- append(dprzscore,((dpr[[a]]-dprmean)/dprsd))
    ccwmzscore <- append(ccwmzscore,((ccwm[[a]]-ccwmmean)/ccwmsd))
  }
}

