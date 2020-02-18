library(httr)
library(jsonlite)
library(data.table)

years <- 2007:2008

teams <- vector()
for (i in years) {
  data <- read.csv(paste(as.character(i), ".csv", sep = ""))
  teams <- append(teams, data$Team)
}

uniqueteams <- unique(teams)

for (j in uniqueteams) {
  for (k in years) {
    
  }
}