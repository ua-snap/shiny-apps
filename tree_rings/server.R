library(shiny)
load("treerings.RData", envir = .GlobalEnv)
source("plot.R")
colpal <- colorRampPalette(c("navyblue", "dodgerblue", "white", "orange", "darkred"))(21)

shinyServer(function(input, output, session){

  # Moving average class error and confusion matrix
  output$macorplot <- renderPlot({
    if(!is.null(input$dataset)) plotFun(get(input$dataset), colpal = colpal)
  }, 
  height = function(){
    w <- session$clientData$output_macorplot_width
    round((8.75 / 12) * w)
  }, width = "auto")
  
  output$dl_macorplotPDF <- downloadHandler(
    filename = 'current_macorplot.pdf',
    content = function(file){
      pdf(file = file, width = 12, height = 8.75)
      plotFun(get(input$dataset), colpal = colpal)
      dev.off()
    }
  )
  
  output$dl_macorplotPNG <- downloadHandler(
    filename = 'current_macorplot.png',
    content = function(filename){ plotFun(get(input$dataset), filename, colpal) }
  )
})
