library(httr)
library(jsonlite)
library(data.table)

# User input here
teamnum <- 2877
years <- 2009:2019

o <- 1
opr <- list()
dpr <- list()
ccwm <- list()

for (year in years) {
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
    print(paste(paste(floor(100*j/length(reducedevents)),"%", sep = ""), i, sep = "     "))
  }
  
  # Cleaning fulldata of empty events (not entirely sure why those are there)
  for(k in length(fulldata):1){
    if(length(fulldata[[k]])==0){
      fulldata[[k]] <- NULL
    }
    print(paste(floor(100-(100*k/length(fulldata))),"%", sep = ""))
  }
  
  # Reducing the list down to only the data needed, and splitting into individual vectors to be later combined into a matrix
  reduceddata <- vector(mode="list", length=length(fulldata))
  combinedscore <- vector()
  combinedteams <- vector()
  dprscore <- vector()
  for (l in 1:length(fulldata)) {
    reduceddata[[l]][["blue"]][["score"]] <- fulldata[[l]][["alliances"]][["blue"]][["score"]]
    reduceddata[[l]][["blue"]][["team_keys"]] <- fulldata[[l]][["alliances"]][["blue"]][["team_keys"]]
    reduceddata[[l]][["red"]][["score"]] <- fulldata[[l]][["alliances"]][["red"]][["score"]]
    reduceddata[[l]][["red"]][["team_keys"]] <- fulldata[[l]][["alliances"]][["red"]][["team_keys"]]
    try(combinedscore <- c(combinedscore, reduceddata[[l]][["blue"]][["score"]]))
    try(combinedscore <- c(combinedscore, reduceddata[[l]][["red"]][["score"]]))
    try(combinedteams <- c(combinedteams, reduceddata[[l]][["blue"]][["team_keys"]]))
    try(combinedteams <- c(combinedteams, reduceddata[[l]][["red"]][["team_keys"]]))
    try(dprscore <- c(dprscore, reduceddata[[l]][["red"]][["score"]]))
    try(dprscore <- c(dprscore, reduceddata[[l]][["blue"]][["score"]]))
    print(paste(floor(100*l/length(fulldata)),"%", sep = ""))
  }
  
  # creates a vector of all unique team numbers
  teamvector <- unlist(combinedteams)
  uniqueteams <- unique(teamvector)
  
  # assembling the matrix defining when each team played
  matchmatrix <- matrix(0, ncol = length(uniqueteams), nrow = length(combinedscore))
  for (m in 1:length(combinedscore)) {
    for (n in 1:length(uniqueteams)) {
      try(if (combinedteams[[m]][[1]]==uniqueteams[[n]]) {
        matchmatrix[m,n] <- 1
      } else if (combinedteams[[m]][[2]]==uniqueteams[[n]]) {
        matchmatrix[m,n] <- 1
      } else if (combinedteams[[m]][[3]]==uniqueteams[[n]]) {
        matchmatrix[m,n] <- 1
      })
    }
    print(paste(floor(100*m/length(combinedscore)),"%", sep = ""))
  }
  
  print("Please wait. This may take a while.")
  # normalizing the matrix
  tmatchmatrix <- t(matchmatrix)
  nmatchmatrix <- tmatchmatrix %*% matchmatrix
  print("Matrix normalized.")
  
  # solving the matrix
  print("Solving. Please wait. This may take several minutes.")
  nscore <- tmatchmatrix %*% combinedscore
  
  opr[[o]] <- solve(nmatchmatrix, nscore)
  
  # assigning teams to opr's
  rownames(opr[[o]]) <- uniqueteams
  colnames(opr[[o]]) <- "OPR"
  
  # ## DPR ##
  print("Solving. Please wait. This may take a while.")
  dprnscore <- tmatchmatrix %*% dprscore
  
  dpr[[o]] <- solve(nmatchmatrix, dprnscore)
  
  rownames(dpr[[o]]) <- uniqueteams
  colnames(dpr[[o]]) <- "DPR"
  
  # ## CCWM ##
  ccwm[[o]] <- opr[[o]] - dpr[[o]]
  colnames(ccwm[[o]]) <- "CCWM"
  
  o=o+1
}