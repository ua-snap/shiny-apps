library(shiny)
shinyServer(function(input, output, session) source("external/app.R", local = TRUE))
