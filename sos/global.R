lapply(list("shiny", "shinythemes", "data.table", "dplyr", "ggplot2", "rasterVis", "leaflet"), function(x) library(x, character.only=T))
lapply(list.files(pattern="^appdata_.*.\\.RData$"), load, envir=.GlobalEnv)

clrs <- c("black", "darkorange", "purple")
