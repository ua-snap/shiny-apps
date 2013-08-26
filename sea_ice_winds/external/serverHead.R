library(shiny)
pkgs <- c("Hmisc")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(Hmisc)
load("external/wind_ice.RData",envir=.GlobalEnv)
cuts <- rev(unique(w.beaufort$Cut))
varlevels <- unique(w.beaufort$Var)
years <- unique(w.beaufort$Year)
decades <- years[years%%10==0]
seas <- capitalize(unique(sapply(strsplit(ls(pattern="^w.*.c$",envir=.GlobalEnv),"\\."),"[[",2)))
models <- unique(sapply(strsplit(ls(pattern="^w.*.c$",envir=.GlobalEnv),"\\."),"[[",3))
dpm <- c(31,28,31,30,31,30,31,31,30,31,30,31)
