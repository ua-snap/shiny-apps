lapply(list("shiny", "shinythemes", "shinyBS", "rCharts", "plyr"), function(x) library(x, character.only=T))
lapply(list.files(pattern="^cc4lite_launch_.*.\\.RData$"), load, envir=.GlobalEnv)
caption <- 'Due to variability among climate models and among years in a natural climate system, these graphs are useful for examining trends over time, rather than for precisely<br>predicting monthly or yearly values. For more information on derivation, reliability, and variability among these projections, please visit www.snap.uaf.edu.'
dec.lab <- paste0(seq(2010, 2090, by=10), "s")
#prov <- sapply(strsplit(locs, ", "), tail, n=1) # move these two lines to .RData file
#locs <- tapply(locs, prov, c, simplify=F)
