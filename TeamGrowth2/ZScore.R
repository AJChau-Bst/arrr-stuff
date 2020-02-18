library(httr)
library(jsonlite)
library(data.table)

years <- 2007:2008

teams <- vector()
for (i in years) {
  tempdata <- read.csv(paste(as.character(i), ".csv", sep = ""))
  teams <- append(teams, tempdata$Team)
}

uniqueteams <- unique(teams)

