library(httr)
library(jsonlite)
library(data.table)

years <- 2005:2019

zscore <- array(dim = c(1,1,1))
a=1
frcsize <- vector()
for (year in years) {
  tempdata <- read.csv(paste(as.character(year), ".csv", sep = ""))
  frcsize <- c(frcsize, length(tempdata$OPR))
  zscore <- array(c(zscore,c(tempdata$OPR,tempdata$DPR,tempdata$CCWM)),dim = c(length(tempdata$OPR),3,a))
  a=a+1
}

