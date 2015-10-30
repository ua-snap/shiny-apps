# @knitr server
library(shiny)
library(ggplot2)
library(data.table)
library(dplyr)

cbpalette <- c("#000000", "gray", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7") # colorblind-friendly palette
main.frp <- paste(obs.years.range[1], "-", obs.years.range[2], "Fire Rotation Period ~ Buffer Radius")
xlb.frp <- "Buffer (km)"
ylb.frp <- "FRP (years)"
fontsize <- 12
lgd.pos <- "Top"

shinyServer(function(input, output, session) source("app.R", local = TRUE))
