library(httr)
library(jsonlite)
library(data.table)

years <- 2010:2007

b=1
oprmaster <- list()
dprmaster <- list()
ccwmmaster <- list()
maxlength <- list()
emptyopr <- 
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
  maxlength[[b]] <- length(opr)
  for (a in 1:maxlength[[1]]) {
    tryCatch(
      oprzscore = append(oprzscore,((opr[[a]]-oprmean)/oprsd)),
      dprzscore = append(dprzscore,-((dpr[[a]]-dprmean)/dprsd)),
      ccwmzscore = append(ccwmzscore,((ccwm[[a]]-ccwmmean)/ccwmsd)),
      error = function(e){
        oprzscore = append(oprzscore, -255)
        dprzscore = append(dprzscore, -255)
        ccwmzscore = append(ccwmzscore, -255)
      }
    )
  }
  oprmaster[[b]] <- oprzscore
  dprmaster[[b]] <- dprzscore
  ccwmmaster[[b]] <- ccwmzscore
  b=b+1
}
write.csv(oprmaster, file = "OPR", row.names = FALSE, col.names = FALSE)
write.csv(dprmaster, file = "DPR", row.names = FALSE, col.names = FALSE)
write.csv(ccwmmaster, file = "CCWM", row.names = FALSE, col.names = FALSE)
