library(shiny)
library(ggplot2); library(gridExtra); library(png); library(Hmisc)

cbpalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7") # colorblind-friendly palette option
short <- c("models","scens","mos","decs") # for ggplot2 faceting
long <- c("Model","Scenario","Month","Decade") # for ggplot2 faceting

logo <- readPNG("www/img/SNAP_acronym_100px.png")
logo.alpha <- 1
logo.mat <- matrix(rgb(logo[,,1],logo[,,2],logo[,,3],logo[,,4]*logo.alpha), nrow=dim(logo)[1])

shinyServer(function(input, output, session) source("external/app.R", local=TRUE))
