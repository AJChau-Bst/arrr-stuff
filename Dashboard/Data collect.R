library(httr)
library(jsonlite)
library(data.table)

# ### STILL NEED TO CHECK FOR CORRUPTED DATA (2004 - 2006) ###

years <- 2020:2020

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
    tryCatch(combinedscore <- c(combinedscore, reduceddata[[l]][["blue"]][["score"]]), error = function(e) {combinedscore <- c(combinedscore, 0)}, silent = TRUE)
    tryCatch(combinedscore <- c(combinedscore, reduceddata[[l]][["red"]][["score"]]), error = function(e) {combinedscore <- c(combinedscore, 0)}, silent = TRUE)
    tryCatch(combinedteams <- c(combinedteams, reduceddata[[l]][["blue"]][["team_keys"]]), error = function(e) {combinedteams <- c(combinedteams, c("null1","null2","null3"))}, silent = TRUE)
    tryCatch(combinedteams <- c(combinedteams, reduceddata[[l]][["red"]][["team_keys"]]), error = function(e) {combinedteams <- c(combinedteams, c("null1","null2","null3"))}, silent = TRUE)
    tryCatch(dprscore <- c(dprscore, reduceddata[[l]][["red"]][["score"]]), error = function(e) {dprscore <- c(dprscore, 0)}, silent = TRUE)
    tryCatch(dprscore <- c(dprscore, reduceddata[[l]][["blue"]][["score"]]), error = function(e) {dprscore <- c(dprscore, 0)}, silent = TRUE)
    print(paste(paste(floor(100*l/length(fulldata)),"%", sep = ""),combinedscore[[l]],dprscore[[l]],combinedteams[[l]],sep="     "))
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
      }, silent = TRUE)
    }
    print(paste(paste(floor(100*m/length(combinedscore)),"%", sep = ""),year,combinedscore[[m]],dprscore[[m]],sep="     "))
  }
  
  print("Please wait. This may take a while.")
  # normalizing the matrix
  tmatchmatrix <- t(matchmatrix)
  nmatchmatrix <- tmatchmatrix %*% matchmatrix
  print("Matrix normalized.")
  
  # solving the matrix
  print("Solving. Please wait. This may take several minutes.")
  nscore <- tmatchmatrix %*% combinedscore
  
  opr <- solve(nmatchmatrix, nscore)
  
  colnames(opr) <- "OPR"
  
  # ## DPR ##
  print("Solving. Please wait. This may take a while.")
  dprnscore <- tmatchmatrix %*% dprscore
  
  dpr <- solve(nmatchmatrix, dprnscore)
  
  colnames(dpr) <- "DPR"
  
  # ## CCWM ##
  ccwm <- opr - dpr
  colnames(ccwm) <- "CCWM"
  
  # ## Writing to .CSV ##
  csvtemp <- do.call(rbind, Map(cbind, uniqueteams, opr, dpr, ccwm))
  colnames(csvtemp) <- c("Team", "OPR", "DPR", "CCWM")
  
  write.csv(csvtemp, file = paste(as.character(year), ".csv", sep = ""), row.names=FALSE)
}
print("Complete.")