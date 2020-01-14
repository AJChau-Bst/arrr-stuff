library(httr)
library(jsonlite)
library(data.table)

teamnum <- 2877
year <- 2019

eventlist <- GET(paste("https://www.thebluealliance.com/api/v3/events/",year,"?X-TBA-Auth-Key=DzzDoXPk1JshyNjKpjkdDP2RHaqXNVD44xksasNYSxJu5YSmWYkTWvzA9stCcqrB",sep=""))
rawevents <- rawToChar(eventlist$content)
fullevents <- fromJSON(rawevents)

reducedevents = fullevents$key

reducedevents
