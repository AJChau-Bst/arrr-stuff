library(httr)
library(jsonlite)
library(data.table)

# ### STILL NEED TO CHECK FOR CORRUPTED DATA (2004 - 2006) ###

event <- "2020ctnct"
year <- 2020
grab <- T

if (grab == TRUE) {
  fulldata = list()

  rawdata <- GET(paste("https://www.thebluealliance.com/api/v3/event/",event,"/matches?X-TBA-Auth-Key=DzzDoXPk1JshyNjKpjkdDP2RHaqXNVD44xksasNYSxJu5YSmWYkTWvzA9stCcqrB",sep=""))
  rawdata2 <- rawToChar(rawdata$content)
  fulldata[[1]] <- fromJSON(rawdata2)
  # print(paste(paste(floor(100*j/length(reducedevents)),"%", sep = ""), i, sep = "     "))
}

# for (o in length(fulldata[[1]][["alliances"]][["blue"]][["score"]])) {
#   if (fulldata[[1]][["alliances"]][["blue"]][["score"]][[o]]==-1) {
#     fulldata[[1]][["alliances"]][["blue"]][["score"]][[o]] <- NULL
#     fulldata[[1]][["alliances"]][["red"]][["score"]][[o]]=NULL
#   }
# }


for (q in 1:length(fulldata[[1]][["alliances"]][["blue"]][["score"]])) {
  if (fulldata[[1]][["alliances"]][["blue"]][["score"]][[q]] <0) {
    fulldata[[1]][["alliances"]][["blue"]][["score"]][[q]] <- NA
  }
}

# fulldata[[1]][["alliances"]][["blue"]][["score"]] <- na.omit(fulldata[[1]][["alliances"]][["blue"]][["score"]])

combinedscore <- c(fulldata[[1]][[2]][[1]][[2]],fulldata[[1]][[2]][[2]][[2]])
average <- mean(combinedscore, na.rm = TRUE)
stdev <- sd(combinedscore, na.rm = TRUE)

combinedauto <- c(fulldata[[1]][["score_breakdown"]][["blue"]][["autoPoints"]],fulldata[[1]][["score_breakdown"]][["red"]][["autoPoints"]])
automean <- mean(combinedauto, na.rm = TRUE)
autosd <- sd(combinedauto, na.rm = TRUE)

combinedcells <- c((fulldata[[1]][["score_breakdown"]][["blue"]][["teleopCellPoints"]]+fulldata[[1]][["score_breakdown"]][["blue"]][["autoCellPoints"]]),(fulldata[[1]][["score_breakdown"]][["red"]][["teleopCellPoints"]]+fulldata[[1]][["score_breakdown"]][["red"]][["autoCellPoints"]]))
cellmean <- mean(combinedcells, na.rm = TRUE)
cellsd <- sd(combinedcells, na.rm = TRUE)

combinedcp <- c(fulldata[[1]][["score_breakdown"]][["blue"]][["controlPanelPoints"]],fulldata[[1]][["score_breakdown"]][["red"]][["controlPanelPoints"]])
cpmean <- mean(combinedcp, na.rm = TRUE)
cpsd <- sd(combinedcp, na.rm = TRUE)

combinedeg <- c(fulldata[[1]][["score_breakdown"]][["blue"]][["endgamePoints"]],fulldata[[1]][["score_breakdown"]][["red"]][["endgamePoints"]])
egmean <- mean(combinedeg, na.rm = TRUE)
egsd <- sd(combinedeg, na.rm = TRUE)

combinedfoul <- c(fulldata[[1]][["score_breakdown"]][["blue"]][["foulPoints"]],fulldata[[1]][["score_breakdown"]][["red"]][["foulPoints"]])
foulmean <- mean(combinedfoul, na.rm = TRUE)
foulsd <- sd(combinedfoul, na.rm = TRUE)

climbrpcombined <- c(fulldata[[1]][["score_breakdown"]][["blue"]][["shieldOperationalRankingPoint"]],fulldata[[1]][["score_breakdown"]][["red"]][["shieldOperationalRankingPoint"]])
climbrpsuccess <- mean(climbrpcombined, na.rm = TRUE)

cprpcombined <- c(fulldata[[1]][["score_breakdown"]][["blue"]][["shieldEnergizedRankingPoint"]],fulldata[[1]][["score_breakdown"]][["red"]][["shieldEnergizedRankingPoint"]])
cprpsuccess <- mean(cprpcombined, na.rm = TRUE)

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