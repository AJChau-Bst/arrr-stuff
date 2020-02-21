library(httr)
library(jsonlite)
library(data.table)

# User input here
teamnum <- 2877

i <- getwd()

teamdata <- read.csv(paste(i,"/Teams/",teamnum,".csv",sep=""))

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

plot(teamdata$Year, teamdata$OPR, type = "l", col = "red", main = paste("Team ", teamnum),xlab = "Year", ylab = "Standardized Scores", xaxt = "none", ylim = c(minval, maxval), lwd = 2, lty = 6)
lines(teamdata$Year, teamdata$DPR, col = "deepskyblue", lwd = 2, xaxt = "none", lty = 6)
lines(teamdata$Year, teamdata$CCWM, col = "green", lwd = 2, xaxt = "none", lty = 6)
points(teamdata$Year, teamdata$OPR, col = "red", pch = 16, cex = 1.5)
points(teamdata$Year, teamdata$DPR, col = "deepskyblue", pch = 16, cex = 1.5)
points(teamdata$Year, teamdata$CCWM, col = "green", pch = 16, cex = 1.5)
axis(2, at = minval:maxval, tck = 1, lty = 2, col = "grey", labels = NA)
axis(1, teamdata$Year, lty = 1, col = "black")
axis(2, lty = 1, col = "black")
legend("bottomleft", c("OPR", "DPR", "CCWM"), col = c("red", "deepskyblue", "green"), pch = 15, text.col = "black", horiz = TRUE)
