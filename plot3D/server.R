library(shiny)
pkgs <- c("plot3D","rgl","shinyRGL")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
options(rgl.useNULL=TRUE)
library(rgl); library(plot3D)

load("external/data.RData",envir=.GlobalEnv)

shinyServer(function(input, output, session) source("external/app.R", local = TRUE))
