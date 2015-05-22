lapply(list("shiny", "shinythemes", "shinyBS", "rCharts", "plyr", "leaflet"), function(x) library(x, character.only=T))
lapply(list.files(pattern="^cc4lite_launch_.*.\\.RData$"), load, envir=.GlobalEnv)
caption <- 'Due to inter-annual variability and model uncertainty, these graphs are useful for examining a range of projected trends, but not for precise prediction. For more information regarding climate projections, please visit'
dec.lab <- paste0(seq(2010, 2090, by=10), "s")

brks <- c(0, 1e4, 5e4, 1e5, 2.5e5, 5e5, 1e6)
nb <- length(brks)
cities.meta$PopClass <- cut(cities.meta$Population, breaks=brks, include.lowest=TRUE, labels=FALSE)
cities.meta$PopClass[is.na(cities.meta$PopClass)] <- 1
palfun <- colorFactor(palette=c("navy", "navy", "magenta4", "magenta4", "red", "red"), domain=1:(nb-1))
