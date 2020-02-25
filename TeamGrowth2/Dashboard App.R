library(httr)
library(jsonlite)
library(data.table)
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  
  dashboardHeader(
    
  ),
  
  dashboardSidebar(
    
  ),
  
  dashboardBody(
    
  )
)

server <- function(input, output){
  
  output$Test <- renderText({"Yay"})
  
}

shinyApp(ui = ui, server = server)
