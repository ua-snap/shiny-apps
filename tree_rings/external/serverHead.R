library(shiny)
#pkgs <- c()
#pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
#if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
#library()
load("external/data.RData",envir=.GlobalEnv)
colpal <- colorRampPalette(c("navyblue","dodgerblue","white","orange","darkred"))(21)
