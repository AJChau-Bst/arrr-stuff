library(httr)
library(jsonlite)
library(data.table)
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  
  dashboardHeader(
    title = "Team Viewing"
  ),
  
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      textOutput("teamnum"),
      menuItem("Individual Team Analysis", icon = icon("chart-area"),
               menuSubItem(numericInput("team", "Input Team Number", 2877)),
               menuSubItem("Plot", tabName = "plot", icon = icon("chart-bar")),
               menuSubItem("Regresion", tabName = "regression", icon = icon("chart-line"))),
      menuItem("Placeholder", icon = icon("chart-pie"),
               menuSubItem("Placeholder2", icon = icon("cloudscale"))),
      textOutput("tab")
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "plot",
              fluidRow(
                box(width = 12,
                  plotOutput("single", height = 550)
                )
              )
      ),
      tabItem(tabName = "regression",
              fluidRow(
                box(width = 12,
                  plotOutput("curve", height = 550)
                )
              )
      )
    )
  )
)

server <- function(input, output){
  
  output$teamnum <- renderText({input$team})
  output$tab <- renderText({input$tabs})
  
  output$single <- renderPlot({
    # teamnum <- input$team
    
    # i <- getwd()
    
    teamdata <- read.csv(paste("Teams/",input$team,".csv",sep=""))
    
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
    
    plot(teamdata$Year, teamdata$OPR, type = "l", col = "red", main = paste("Team ", input$team),xlab = "Year", ylab = "Standardized Scores", xaxt = "none", ylim = c(minval, maxval), lwd = 2, lty = 6)
    lines(teamdata$Year, teamdata$DPR, col = "deepskyblue", lwd = 2, xaxt = "none", lty = 6)
    lines(teamdata$Year, teamdata$CCWM, col = "green", lwd = 2, xaxt = "none", lty = 6)
    points(teamdata$Year, teamdata$OPR, col = "red", pch = 16, cex = 1.5)
    points(teamdata$Year, teamdata$DPR, col = "deepskyblue", pch = 16, cex = 1.5)
    points(teamdata$Year, teamdata$CCWM, col = "green", pch = 16, cex = 1.5)
    axis(2, at = minval:maxval, tck = 1, lty = 2, col = "grey", labels = NA)
    axis(1, teamdata$Year, lty = 1, col = "black")
    axis(2, lty = 1, col = "black")
    legend("bottomleft", c("OPR", "DPR", "CCWM"), col = c("red", "deepskyblue", "green"), pch = 15, text.col = "black", horiz = TRUE)
    
  })
  
  output$curve <- renderPlot({
    # teamnum <- 6328
    # 
    # i <- getwd()
    
    teamdata <- read.csv(paste("Teams/",input$team,".csv",sep=""))
    
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
    
    plot(teamdata$Year, teamdata$OPR, type = "p", col = "red", main = paste("Team ", input$team),xlab = "Year", ylab = "Standardized Scores", xaxt = "none", ylim = c(minval, maxval), pch = 16, cex = 1.5)
    points(teamdata$Year, teamdata$DPR, col = "deepskyblue", pch = 16, cex = 1.5)
    points(teamdata$Year, teamdata$CCWM, col = "green", pch = 16, cex = 1.5)
    axis(2, at = minval:maxval, tck = 1, lty = 2, col = "grey", labels = NA)
    axis(1, c(teamdata$Year, max(teamdata$Year) + 1), lty = 1, col = "black")
    axis(2, lty = 1, col = "black")
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
    
  })
  
}

shinyApp(ui, server)
