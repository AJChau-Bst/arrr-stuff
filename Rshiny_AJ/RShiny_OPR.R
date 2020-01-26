library(shiny)


  
ui <- fluidPage(
  numericInput("obs", "Team Number",10, min = 1, max = 100),
  verbatimTextOutput("value"),
  )
  server <- function(input, output) {
    output$value <- renderText({ input$obs })
  }
  shinyApp(ui, server)