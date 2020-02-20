library(httr)
library(jsonlite)
library(data.table)

# User input here
teamnum <- 3205

i <- getwd()

teamdata <- read.csv(paste(i,"/Teams/",teamnum,".csv",sep=""))

plot(teamdata$Year, teamdata$OPR, type = "l", col = "red", main = paste("Team ", teamnum),xlab = "Year", ylab = "Standardized Scores", xaxt = "none", ylim = c(-5, 6), lwd = 2)
lines(teamdata$Year, teamdata$DPR, col = "deepskyblue", lwd = 2, xaxt = "none")
lines(teamdata$Year, teamdata$CCWM, col = "green", lwd = 2, xaxt = "none")
axis(1, teamdata$Year)
legend("topleft", c("OPR", "DPR", "CCWM"), col = c("red", "deepskyblue", "green"), pch = 15, text.col = "black", horiz = TRUE)