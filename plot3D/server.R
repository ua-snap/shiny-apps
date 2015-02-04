library(shiny)
options(rgl.useNULL=TRUE)
library(rgl); library(plot3D)

load("data.RData",envir=.GlobalEnv)

shinyServer(function(input, output, session) source("app.R", local = TRUE))
