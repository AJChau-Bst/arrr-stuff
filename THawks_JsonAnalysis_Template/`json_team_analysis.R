library(httr)
library(jsonlite)
library(data.table)

## ##### ##
## ENTER TEAM NUMBER HERE ##
team <- 190

# Increase max value if more than 80 matches #
matches <- c(1:80)
## ##### ##


fulldataset <- list()
sepdata <- vector(mode="list",length=9999)
for (i in matches) {
  try(fulldataset[[i]] <- read_json(paste(i,".txt",sep="")))
}

for (j in 1:length(fulldataset)) {
  for (k in 1:length(fulldataset[[j]])) {
    # m <- fulldataset[[j]][[k]][["Team"]]
    try(sepdata[[fulldataset[[j]][[k]][["Team"]]]] <- vector(mode = "list", length = 12),silent = T)
  }
}

for (j in 1:length(fulldataset)) {
  for (k in 1:length(fulldataset[[j]])) {
    for (l in 1:12) {
      try(if (is.null(sepdata[[fulldataset[[j]][[k]][["Team"]]]][[l]]) == TRUE) {
        sepdata[[fulldataset[[j]][[k]][["Team"]]]][[l]] <- fulldataset[[j]][[k]]
        break
      },silent = T)
    }
    # assign(paste("frc",fulldataset[[j]][[k]][["Team"]],sep="")[[l]],fulldataset[[j]][[k]])
    
  }
}

auto <- vector()
autoscoring <- vector()
scoring <- vector()
climb <- vector()
for (n in 1:12) {
  if (is.null(sepdata[[team]][[n]]) == FALSE) {
    auto <- append(auto, sum(sepdata[[team]][[n]][["Auto Hits"]][["Bottom"]],sepdata[[team]][[n]][["Auto Hits"]][["Outer"]],sepdata[[team]][[n]][["Auto Hits"]][["Inner"]]))
    autoscoring <- append(autoscoring, sum(sepdata[[team]][[n]][["Auto Hits"]][["Bottom"]]*2,sepdata[[team]][[n]][["Auto Hits"]][["Outer"]]*4,sepdata[[team]][[n]][["Auto Hits"]][["Inner"]]*6))
    scoring <- append(scoring, sum(sepdata[[team]][[n]][["Scoring"]][["Position: 5"]][["Bottom"]],sepdata[[team]][[n]][["Scoring"]][["Position: 5"]][["Outer"]]*2,sepdata[[team]][[n]][["Scoring"]][["Position: 5"]][["Inner"]]*3,
                                   sepdata[[team]][[n]][["Scoring"]][["Position: 4"]][["Bottom"]],sepdata[[team]][[n]][["Scoring"]][["Position: 4"]][["Outer"]]*2,sepdata[[team]][[n]][["Scoring"]][["Position: 4"]][["Inner"]]*3,
                                   sepdata[[team]][[n]][["Scoring"]][["Position: 3"]][["Bottom"]],sepdata[[team]][[n]][["Scoring"]][["Position: 3"]][["Outer"]]*2,sepdata[[team]][[n]][["Scoring"]][["Position: 3"]][["Inner"]]*3,
                                   sepdata[[team]][[n]][["Scoring"]][["Position: 2"]][["Bottom"]],sepdata[[team]][[n]][["Scoring"]][["Position: 2"]][["Outer"]]*2,sepdata[[team]][[n]][["Scoring"]][["Position: 2"]][["Inner"]]*3,
                                   sepdata[[team]][[n]][["Scoring"]][["Position: 1"]][["Bottom"]],sepdata[[team]][[n]][["Scoring"]][["Position: 1"]][["Outer"]]*2,sepdata[[team]][[n]][["Scoring"]][["Position: 1"]][["Inner"]]*3,
                                   sepdata[[team]][[n]][["Scoring"]][["Position: 0"]][["Bottom"]],sepdata[[team]][[n]][["Scoring"]][["Position: 0"]][["Outer"]]*2,sepdata[[team]][[n]][["Scoring"]][["Position: 0"]][["Inner"]]*3))
    climb <- append(climb, sepdata[[team]][[n]][["Climb"]])
    }
}

# auto
# autoscoring
# scoring
# climb
# mean(auto)
# mean(autoscoring)
# mean(scoring)
# mean(climb)

dt <- data.table(
  AutoPoints = autoscoring,
  TeleopPoints = scoring,
  Climb = climb
)
dt0 <- data.table(
  MeanAutoPoints = mean(autoscoring),
  MeanTeleopPoints = mean(scoring),
  ClimbRate = paste(100*mean(climb),"%",sep="")
)

dt
dt0