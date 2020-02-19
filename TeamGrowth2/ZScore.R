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

for (j in uniqueteams) {
  for (k in years) {
    tempdata <- read.csv(paste(as.character(k), ".csv", sep = ""))
    tempteams <- tempdata$Team
    for (l in 1:length(tempteams)) {
      if (tempteams[l]==paste("frc",j,sep="")) {
        print(j)
      }
    }
  }
}