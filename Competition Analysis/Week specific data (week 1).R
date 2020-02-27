library(httr)
library(jsonlite)
library(data.table)

# ### STILL NEED TO CHECK FOR CORRUPTED DATA (2004 - 2006) ###

event <- "2020isde1"
year <- 2020
grab <- F

if (grab == TRUE) {
  fulldata = list()
  j=1
  for(i in event){
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
}

combinedscore <- c(fulldata[[1]][[2]][[1]][[2]],fulldata[[1]][[2]][[2]][[2]])
average <- mean(combinedscore)
stdev <- sd(combinedscore)

average
stdev