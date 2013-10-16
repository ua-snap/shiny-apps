library(shiny)
pkgs <- c("png","grid")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(png); library(grid)
load("external/usStationMetadata.RData")
vars <- "Precipitation"
yr.min <- 1900 #### min(gsub("-","",metadata$Start))
yr.max <- as.numeric(substr(Sys.Date(),1,4))
startdate.yr <- as.numeric(substr(metadata$Start,1,4))
enddate.yr <- as.numeric(substr(metadata$End,1,4))

palettes <- c("Wt-Yl-Gn","Orange-Blue","Wt-OrRd","LightBlue-Purple","Brown-DkGn","Wt-MdBlue")

recursiveLog <- function(...,n=1,N=1){
	x <- list(...)[[1]]
	if(N==0) return(x)
	if(n==N) log(x+1) else Recall(log(x+1),n=n+1,N=N)
}

logo <- paste0(getwd(),"/www/img/snap_acronym_fullcolor_transparent.png")
