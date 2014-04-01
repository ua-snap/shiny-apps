library(shiny)
pkgs <- c("png","grid")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(png); library(grid)
load("external/AK_Station_Names_IDs.RData",envir=.GlobalEnv)
vars <- "Precipitation"

palettes <- c("Brown-DkGn","Wt-MdBlue","Wt-Yl-Gn","Orange-Blue","Wt-OrRd","LightBlue-Purple")

recursiveLog <- function(...,n=1,N=1){
	x <- list(...)[[1]]
	if(N==0) return(x)
	if(n==N) log(x+1) else Recall(log(x+1),n=n+1,N=N)
}

logo <- paste0(getwd(),"/www/img/snap_acronym_fullcolor_transparent.png")
