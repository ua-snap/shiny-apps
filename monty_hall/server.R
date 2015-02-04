library(shiny)
load("external/data.RData",envir=.GlobalEnv)
shinyServer(function(input, output, session) source("external/app.R", local=TRUE))
