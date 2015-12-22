lapply(list("shiny", "shinythemes", "shinyBS", "gbm", "tidyr", "grid", "gridExtra", "ggplot2", "rasterVis", "leaflet", "data.table", "dplyr"), function(x) library(x, character.only=T))
lapply(list.files(pattern="^appdata_.*.\\.RData$"), load, envir=.GlobalEnv)

gbm_plot_types <- c("Error curves", "Predictor strength", "Partial dependence", "GBM predictions", "Exchangeability")
clrs <- c("black", "darkorange", "purple", "dodgerblue", "firebrick1")
