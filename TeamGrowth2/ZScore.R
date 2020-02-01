library(httr)
library(jsonlite)
library(data.table)

years <- 2007:2010

b=1
oprmaster <- list()
dprmaster <- list()
ccwmmaster <- list()
for (year in years) {
  oprzscore <- vector()
  dprzscore <- vector()
  ccwmzscore <- vector()
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
  oprmaster[[b]] <- oprzscore
  dprmaster[[b]] <- dprzscore
  ccwmmaster[[b]] <- ccwmzscore
  b=b+1
}
write.csv(oprmaster, file = "OPR", row.names = FALSE, col.names = FALSE)
write.csv(dprmaster, file = "DPR", row.names = FALSE, col.names = FALSE)
write.csv(ccwmmaster, file = "CCWM", row.names = FALSE, col.names = FALSE)
