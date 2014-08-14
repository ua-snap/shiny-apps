library(shiny)
pkgs <- c("randomForest","ggplot2","plyr","reshape2","gridExtra","gtable")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(randomForest); library(ggplot2); library(plyr); library(reshape2); library(gridExtra); library(gtable); library(parallel) # parallel experimental
d <- read.csv("external/flagData.csv")
clrs <- c("#E69F00", "#56B4E9", "#8B4513", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#551A8B", "#999999")
var.is.factor <- sapply(d[-1],is.factor)
#num.vars <- which(!var.is.factor)
#for(i in num.vars) if(length(unique(d[,i]))<=7) d[,i] <- factor(d[,i],levels=0:max(d[,i]),ordered=T)

#logo <- readPNG("www/images/snap_acronym_rgb.png")
#logo.alpha <- 1
#logo.mat <- matrix(rgb(logo[,,1],logo[,,2],logo[,,3],logo[,,4]*logo.alpha), nrow=dim(logo)[1])
