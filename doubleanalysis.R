library(httr)
library(jsonlite)
library(data.table)

team <- 7760
matches <- c(11:43)

fulldataset <- list()
sepdata <- vector(mode="list",length=9999)
for (i in matches) {
  try(fulldataset[[i]] <- read_json(paste("Live Analysis/",i,".txt",sep="")))
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

auto
autoscoring
scoring
climb
mean(auto)
mean(autoscoring)
mean(scoring)
mean(climb)

# User input here
teamnum <- team

i <- getwd()

teamdata <- read.csv(paste(i,"/TeamGrowth2/Teams/",teamnum,".csv",sep=""))

q <- seq(min(teamdata$Year), max(teamdata$Year), 1)
degfr <- 3

oprmax <- max(teamdata$OPR)
dprmax <- max(teamdata$DPR)
ccwmmax <- max(teamdata$CCWM)
oprmin <- min(teamdata$OPR)
dprmin <- min(teamdata$DPR)
ccwmmin <- min(teamdata$CCWM)

maxoprvdpr <- function() {
  if (oprmax >= dprmax) {
    maxval <<- ceiling(oprmax)
    maxoprvccwm()
  } else {
    maxval <<- ceiling(dprmax)
    maxdprvccwm()
  }
}

maxoprvccwm <- function() {
  if (ccwmmax >= maxval) {
    maxval <<- ceiling(ccwmmax)
  }
}

maxdprvccwm <- function() {
  if (ccwmmax >= maxval) {
    maxval <<- ceiling(ccwmmax)
  }
}

minoprvdpr <- function() {
  if (oprmin <= dprmin) {
    minval <<- floor(oprmin)
    minoprvccwm()
  } else {
    minval <<- floor(dprmin)
    mindprvccwm()
  }
}

minoprvccwm <- function() {
  if (ccwmmin <= minval) {
    minval <<- floor(ccwmmin)
  }
}

mindprvccwm <- function() {
  if (ccwmmin <= minval) {
    minval <<- floor(ccwmmin)
  }
}

maxoprvdpr()
minoprvdpr()

plot(teamdata$Year, teamdata$OPR, type = "p", col = "red", main = paste("Team ", teamnum),xlab = "Year", ylab = "Standardized Scores", xaxt = "none", ylim = c(minval, maxval), pch = 16, cex = 1.5)
points(teamdata$Year, teamdata$DPR, col = "deepskyblue", pch = 16, cex = 1.5)
points(teamdata$Year, teamdata$CCWM, col = "green", pch = 16, cex = 1.5)
axis(2, at = minval:maxval, tck = 1, lty = 2, col = "grey", labels = NA)
axis(1, c(teamdata$Year, max(teamdata$Year) + 1), lty = 1, col = "black")
axis(2, lty = 1, col = "black")

auto
autoscoring
scoring
climb
mean(auto)
mean(autoscoring)
mean(scoring)
mean(climb)

model <- lm(teamdata$OPR ~ poly(q, degfr))
predicted.intervals <- predict(model,data.frame(x=q),interval='confidence',level=0.9)
lines(q,predicted.intervals[,1],col='red',lwd=2.5)
model <- lm(teamdata$DPR ~ poly(q, degfr))
predicted.intervals <- predict(model,data.frame(x=q),interval='confidence',level=0.9)
lines(q,predicted.intervals[,1],col='deepskyblue',lwd=2.5)
model <- lm(teamdata$CCWM ~ poly(q, degfr))
predicted.intervals <- predict(model,data.frame(x=q),interval='confidence',level=0.9)
lines(q,predicted.intervals[,1],col='green',lwd=2.5)
legend("bottomleft", c("OPR", "DPR", "CCWM"), col = c("red", "deepskyblue", "green"), pch = 15, text.col = "black", horiz = TRUE)

auto
autoscoring
scoring
climb
mean(auto)
mean(autoscoring)
mean(scoring)
mean(climb)
