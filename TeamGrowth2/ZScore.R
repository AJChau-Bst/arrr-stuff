library(httr)
library(jsonlite)
library(data.table)

years <- 2007:2010

teams <- vector()
for (i in years) {
  j <- paste("x",i,sep="")
  tempdata <- read.csv(paste(as.character(i), ".csv", sep = ""))
  teams <- append(teams, tempdata$j)
}
