lapply(list("shiny", "shinythemes", "shinyBS", "rCharts", "plyr"), function(x) library(x, character.only=T))
#load("cc4lite_cru31_prism_akcan2km.RData")
load(list.files(pattern="\\.RData$"))
caption <- 'Due to variability among climate models and among years in a natural climate system, these graphs are useful for examining trends over time, rather than for precisely<br>predicting monthly or yearly values. For more information on derivation, reliability, and variability among these projections, please visit www.snap.uaf.edu.'

prov <- sapply(strsplit(locs, ", "), tail, n=1) # move these two lines to .RData file
locs <- tapply(locs, prov, c, simplify=F)
