pkgs <- list("shiny", "shinyBS", "shinyjs", "leaflet", "rgdal", "raster", "data.table", "dplyr", "tidyr", "ggplot2")
suppressMessages(lapply(pkgs, function(x) library(x, character.only=T)))

options(warn = -1) # # haven't figured out how to suppress warning from colors(.)

load("nwt_data.RData")
load("nwt_data_pr_tas_CRU32_1961_1990_climatology.RData")
load("nwt_locations.RData")

r <- subset(cru6190$pr, 1)
lon <- (xmin(r)+xmax(r))/2
lat <- (ymin(r)+ymax(r))/2
decades <- seq(2010, 2090, by=10)

season.labels <- names(cru6190[[1]])[13:16]
season.labels.long <- season.labels[c(1,1,2,2,2,3,3,3,4,4,4,1)]
sea.idx <- list(Winter=c(1,2,12), Spring=3:5, Summer=6:8, Fall=9:11)
toy_list <- list(Season=season.labels, Month=month.abb)

rcps <- sort(unique(d$RCP))
rcp.labels <- c("RCP 4.5", "RCP 6.0", "RCP 8.5")
models <- unique(d$Model)
vars <- rev(sort(unique(d$Var)))
var.labels <- rev(c("Precipitation", "Temperature"))

maptype_list <- list("Single GCM"=models, Statistic=c("Mean", "Min", "Max", "Spread"))
is_gcm_string <- paste(sprintf("input.mod_or_stat == '%s'", models), collapse=" || ")

colpals <- RColorBrewer::brewer.pal.info
dv <- rownames(colpals)[colpals["category"]=="div"]
sq <- rownames(colpals)[colpals["category"]=="seq"]
colpals_list <- list(Divergent=c(Custom="Custom div", dv), Sequential=c(Custom="Custom seq", sq))
