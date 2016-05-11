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
