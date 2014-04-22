library(shiny)
pkgs <- c("plot3D","rgl","shinyRGL")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(rgl); library(plot3D); library(shinyRGL)
load("external/data.RData",envir=.GlobalEnv)
dataset.names <- c("Volcano (Maunga Whau)","Sinc","Lorenz Attractor","Hypsometry data")
getFun <- function(type){
	switch(type,
		p2dCL=contour2D,
		p2dIM=image2D,
		p2dIC=image2D,
		p3dPP=persp3D,
		p3dRI=ribbon3D,
		p3dHI=hist3D)
}

shinyServer(function(input, output, session) source("external/app.R", local = TRUE))
