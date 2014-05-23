library(shinyAce)
dataset.names <- c("Volcano (Maunga Whau)","Sinc","Lorenz Attractor","Hypsometry data")
anyPlot <- "input.tsp==='p2Dcontour' || input.tsp==='p2Dimage' || input.tsp==='p3Dpersp' ||
	input.tsp==='p3Dribbon' || input.tsp==='p3Dhist' || input.tsp==='p3Drgl'"
anyStatic <- "input.tsp==='p2Dcontour' || input.tsp==='p2Dimage' || input.tsp==='p3Dpersp' ||
	input.tsp==='p3Dribbon' || input.tsp==='p3Dhist'"
nonContourStatic <- "input.tsp==='p2Dimage' || input.tsp==='p3Dpersp' || input.tsp==='p3Dribbon' ||
	input.tsp==='p3Dhist'"
any3DStatic <- "input.tsp==='p3Dpersp' || input.tsp==='p3Dribbon' || input.tsp==='p3Dhist'"

LorenzText <- "The Lorenz Attractor data has been prepared only for interactive 3D (RGL) display."
conPan_LA <- conditionalPanel(condition="input.dataset==='Lorenz Attractor'", h5(LorenzText))

R_files <- paste0(c(
	"global", "ui", "server",
	file.path("external", c("app", "sidebar", "main", "about")), # cannot include "header" if it contains Google Analytics tracking code
	file.path("external/appSourceFiles", c("reactives"))
	), ".R")

showCode <- function(file, ht="600px"){
	list(
		h4(HTML(basename(file))),
		aceEditor(gsub('\\.', '', basename(file)), value=paste(readLines(file), collapse='\n'), mode='r', height=ht, readOnly=TRUE)
	)
}

for(i in 1:length(R_files)) assign(paste0("show_", gsub("\\.R", "R", basename(R_files[i]))), showCode(R_files[i]))
