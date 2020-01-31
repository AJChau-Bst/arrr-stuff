library(shiny)


  
ui <- fluidPage(
  magic <- numericInput("obs", "Team Number",10, min = 1, max = 100),
  verbatimTextOutput("value"),
  )
  server <- function(input, output) {
    csv <- read.csv(file='ccwm.csv', header = TRUE)
    matchvalue <- match(V1, V2, nomatch = NA_integer_, incomparables = NULL)
    
    
    
    
    output$value <- renderText({ input$obs })
  }
  shinyApp(ui, server)
  