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
  for (a in 1:length(opr)) {
    oprzscore <- append(oprzscore,((opr[[a]]-oprmean)/oprsd))
  }
}

