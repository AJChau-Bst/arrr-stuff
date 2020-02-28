library(httr)
library(jsonlite)
library(data.table)

# ### STILL NEED TO CHECK FOR CORRUPTED DATA (2004 - 2006) ###

event <- "2020isde2"
year <- 2020
grab <- T

if (grab == TRUE) {
  fulldata = list()

  rawdata <- GET(paste("https://www.thebluealliance.com/api/v3/event/",event,"/matches?X-TBA-Auth-Key=DzzDoXPk1JshyNjKpjkdDP2RHaqXNVD44xksasNYSxJu5YSmWYkTWvzA9stCcqrB",sep=""))
  rawdata2 <- rawToChar(rawdata$content)
  fulldata <- fromJSON(rawdata2)
  print(paste(paste(floor(100*j/length(reducedevents)),"%", sep = ""), i, sep = "     "))
}

combinedscore <- c(fulldata[[1]][[2]][[1]][[2]],fulldata[[1]][[2]][[2]][[2]])
average <- mean(combinedscore)
stdev <- sd(combinedscore)

combinedauto <- c(fulldata[[1]][["score_breakdown"]][["blue"]][["autoPoints"]],fulldata[[1]][["score_breakdown"]][["red"]][["autoPoints"]])
automean <- mean(combinedauto)
autosd <- sd(combinedauto)

combinedcells <- c((fulldata[[1]][["score_breakdown"]][["blue"]][["teleopCellPoints"]]+fulldata[[1]][["score_breakdown"]][["blue"]][["autoCellPoints"]]),(fulldata[[1]][["score_breakdown"]][["red"]][["teleopCellPoints"]]+fulldata[[1]][["score_breakdown"]][["red"]][["autoCellPoints"]]))
cellmean <- mean(combinedcells)
cellsd <- sd(combinedcells)

combinedcp <- c(fulldata[[1]][["score_breakdown"]][["blue"]][["controlPanelPoints"]],fulldata[[1]][["score_breakdown"]][["red"]][["controlPanelPoints"]])
cpmean <- mean(combinedcp)
cpsd <- sd(combinedcp)

combinedeg <- c(fulldata[[1]][["score_breakdown"]][["blue"]][["endgamePoints"]],fulldata[[1]][["score_breakdown"]][["red"]][["endgamePoints"]])
egmean <- mean(combinedeg)
egsd <- sd(combinedeg)

combinedfoul <- c(fulldata[[1]][["score_breakdown"]][["blue"]][["foulPoints"]],fulldata[[1]][["score_breakdown"]][["red"]][["foulPoints"]])
foulmean <- mean(combinedfoul)
foulsd <- sd(combinedfoul)

climbrpcombined <- c(fulldata[[1]][["score_breakdown"]][["blue"]][["shieldOperationalRankingPoint"]],fulldata[[1]][["score_breakdown"]][["red"]][["shieldOperationalRankingPoint"]])
climbrpsuccess <- mean(climbrpcombined)

cprpcombined <- c(fulldata[[1]][["score_breakdown"]][["blue"]][["shieldEnergizedRankingPoint"]],fulldata[[1]][["score_breakdown"]][["red"]][["shieldEnergizedRankingPoint"]])
cprpsuccess <- mean(cprpcombined)

average
stdev
automean
autosd
cellmean
cellsd
cpmean
cpsd
egmean
egsd
foulmean
foulsd
climbrpsuccess
cprpsuccess

pointdf <- data.frame(
  overall_points = c(average,stdev),
  auto_points = c(automean,autosd),
  ball_points = c(cellmean,cellsd),
  cp_points = c(cpmean,cpsd),
  endgame_points = c(egmean,egsd),
  foul_points = c(foulmean,foulsd),
  row.names = c("Average", "Stdev")
)

propdf <- data.frame(
  climb_rp = climbrpsuccess,
  cp_rp = cprpsuccess,
  row.names = "Success Rate"
)

pointdf
propdf

write.csv(pointdf,file=paste(event,"Points.csv"))
write.csv(propdf,file=paste(event,"RP.csv"))