library(shiny)
pkgs <- c("ggplot2","Hmisc")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(ggplot2); library(Hmisc)
load("external/data.RData",envir=.GlobalEnv) # global assignment
modnames <- unique(as.character(d$Model))
scennames <- unique(as.character(d$Scenario))
varnames <- rev(sort(unique(as.character(d$Variable))))
monums <- c(paste0(0,1:9),10:12)
mos <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
decades <- paste0(seq(2010,2090,by=10),"s")
communities <<- sort(unique(as.character(d$Community))) # global assignment
cbpalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
short <- c("models","scens","mos","decs") # faceting
long <- c("Model","Scenario","Month","Decade") # faceting
