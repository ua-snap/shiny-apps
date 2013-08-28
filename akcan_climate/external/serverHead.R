library(shiny)
pkgs <- c("ggplot2","gridExtra","Hmisc","png")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(ggplot2); library(gridExtra); library(png); library(Hmisc)
load("external/AR4_CMIP3_historical_pop2500.RData",envir=.GlobalEnv) # global assignment
load("external/AR4_CMIP3_projected_pop2500.RData",envir=.GlobalEnv) # global assignment

monums <- c(paste0(0,1:9),10:12)
mos <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
colorsHCL <- function(n) hcl(h=seq(0,(n-1)/(n),length=n)*360,c=100,l=65,fixup=TRUE) # evenly spaced HCL colors when too many levels present

# So far, the apps uses AR4/CMIP3 historical and projected datasets
decades.list <- list(paste0(seq(1870,1990,by=10),"s"),paste0(seq(2010,2090,by=10),"s"))
scennames.list <- list("historical",levels(AR4_CMIP3_projected_data$Scenario))
modnames <- unique(as.character(AR4_CMIP3_historical_data$Model))
varnames <- rev(levels(AR4_CMIP3_historical_data$Variable))
communities <<- sort(unique(paste(as.character(AR4_CMIP3_historical_data$Community),as.character(AR4_CMIP3_historical_data$Region),sep=", "))) # global assignment

cbpalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7") # colorblind-friendly palette option
short <- c("models","scens","mos","decs") # for ggplot2 faceting
long <- c("Model","Scenario","Month","Decade") # for ggplot2 faceting

logo <- readPNG("www/img/snap_sidebyside.png")
logo.alpha <- 1
logo.mat <- matrix(rgb(logo[,,1],logo[,,2],logo[,,3],logo[,,4]*logo.alpha), nrow=dim(logo)[1])
