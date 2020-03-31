library(httr)
library(jsonlite)
library(data.table)

# Grabbing list of worldwide events from TBA API
eventlist <- GET(paste("https://www.thebluealliance.com/api/v3/events/2020?X-TBA-Auth-Key=DzzDoXPk1JshyNjKpjkdDP2RHaqXNVD44xksasNYSxJu5YSmWYkTWvzA9stCcqrB",sep=""))
rawevents <- rawToChar(eventlist$content)
fullevents <- fromJSON(rawevents)

reducedevents = fullevents$key

# Grabbing match data for every event. This step takes a while.
fulldata = list()
j=1
for(i in reducedevents){
  rawdata <- GET(paste("https://www.thebluealliance.com/api/v3/event/",i,"/matches?X-TBA-Auth-Key=DzzDoXPk1JshyNjKpjkdDP2RHaqXNVD44xksasNYSxJu5YSmWYkTWvzA9stCcqrB",sep=""))
  rawdata2 <- rawToChar(rawdata$content)
  fulldata[[j]] <- fromJSON(rawdata2)
  j=j+1
  print(paste(paste(floor(100*j/length(reducedevents)),"%", sep = ""), i, sep = "     "))
}

# Cleaning fulldata of empty events (not entirely sure why those are there)
for(k in length(fulldata):1){
  if(length(fulldata[[k]])==0){
    fulldata[[k]] <- NULL
  }
}

# "win","autoPoints","teleopCellPoints","endgamePoints","foulPoints","autoCellsInner","teleopCellsInner","autoCellsOuter","teleopCellsOuter"
# winning_alliance,autoPoints,teleopCellPoints,endgamePoints,foulPoints,autoCellsInner,teleopCellsInner,autoCellsOuter,teleopCellsOuter

infiniterecharge <- data.frame()
for (l in 1:length(fulldata)) {
  temp <- data.frame(datacol <- fulldata[[l]][["winning_alliance"]])
  infiniterecharge <- rbind(infiniterecharge, temp)
}

