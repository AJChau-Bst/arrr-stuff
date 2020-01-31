library(httr)
library(jsonlite)
library(data.table)

years <- 2002:2003

for (year in years) {
  tempdata <- read.csv(paste(as.character(year), ".csv", sep = ""))
  
}
