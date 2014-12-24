library(shiny)
shinyServer(function(input, output) source("external/app.R", local = TRUE))
