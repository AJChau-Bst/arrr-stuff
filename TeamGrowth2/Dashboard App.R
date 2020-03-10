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
               menuSubItem("Plot", icon = icon("chart-bar")),
               menuSubItem("Regresion", icon = icon("chart-line"))),
      menuItem("Placeholder", icon = icon("chart-pie"),
               menuSubItem("Placeholder2", icon = icon("cloudscale"))),
      textOutput("tab")
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "Plot",
              fluidRow(
                box(
                  plotOutput("single")
                )
              )
      )
    )
  )
)

server <- function(input, output){
  
  output$teamnum <- renderText({input$team})
  output$tab <- renderText({input$tabs})
  
}

shinyApp(ui = ui, server = server)
