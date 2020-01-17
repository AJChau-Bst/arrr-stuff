library(httr)
library(jsonlite)
library(data.table)

# User input here
teamnum <- 2877
year <- 2019

# Grabbing list of worldwide events from TBA API
eventlist <- GET(paste("https://www.thebluealliance.com/api/v3/events/",year,"?X-TBA-Auth-Key=DzzDoXPk1JshyNjKpjkdDP2RHaqXNVD44xksasNYSxJu5YSmWYkTWvzA9stCcqrB",sep=""))
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
}

# fulldata <- fulldata2 # <- For testing purposes

# Cleaning fulldata of empty events (not entirely sure why those are there)
for(k in length(fulldata):1){
  if(length(fulldata[[k]])==0){
    fulldata[[k]] <- NULL
  }
}

# Reducing the list down to only the data needed
reduceddata <- vector(mode="list", length=length(fulldata))
for (n in 1:length(fulldata)) {
  reduceddata[[n]][["blue"]][["score"]] <- fulldata[[n]][["alliances"]][["blue"]][["score"]]
  reduceddata[[n]][["blue"]][["team_keys"]] <- fulldata[[n]][["alliances"]][["blue"]][["team_keys"]]
  reduceddata[[n]][["red"]][["score"]] <- fulldata[[n]][["alliances"]][["red"]][["score"]]
  reduceddata[[n]][["red"]][["team_keys"]] <- fulldata[[n]][["alliances"]][["red"]][["team_keys"]]
}

# Ignore this
# for (l in 1:length(fulldata)) {
#   for (m in 1:length(fulldata[[l]][["alliances"]])) {
#     strsplit(fulldata[[l]][["alliances"]][[m]])
#   }
# }
