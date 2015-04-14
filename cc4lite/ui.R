shinyUI(navbarPage(theme=shinytheme("cerulean"),
	title=HTML('<div><a href="http://snap.uaf.edu" target="_blank"><img src="./img/SNAP_acronym_100px.png" width="80%"></a></div>'),
	tabPanel("Community Charts", value="commChart"),
	tabPanel("About", value="about"),
	windowTitle="CC4L Alpha",
	collapsible=TRUE,
	id="tsp",
	
	h4("Community Charts v4 Lite [Alpha]"),
	conditionalPanel("input.tsp=='commChart'",
	fluidRow(
	column(4, wellPanel(
		selectInput("location", "See the climate outlook for your community.", c("", locs), selected="", multiple=FALSE, width="100%"),
		selectInput("dec", "Decades", dec.lab, selected=dec.lab[c(1,4,6,9)], multiple=TRUE, width="100%"),
		bsButtonGroup("variable", label="Climate Variable", toggle="radio", value="Temperature", style="primary", size="small", block=T,
			bsButton("btn_T", label="Temperature", value="Temperature"), bsButton("btn_P", label="Precipitation", value="Precipitation")),
		bsButtonGroup("units", label="Units", toggle="radio", value="Cmm", style="primary", size="small", block=T, bsButton("btn_U", label="C, mm", value="Cmm"), bsButton("btn_UT2", label="F, in", value="Fin")),
		bsButtonGroup("rcp", label="Emissions", toggle="radio", value="r60", style="primary", size="small", block=T,
			bsButton("btn_r45", label="Low (RCP 4.5)", value="r45"), bsButton("btn_r60", label="Medium (RCP 6.0)", value="r60"), bsButton("btn_r85", label="High (RCP 8.5)", value="r85")),
		bsButtonGroup("err", label="Inter-Model Variability", toggle="radio", value="overlay", style="primary", size="small", block=T,
			bsButton("btn_errNone", label="None", value="none"), bsButton("btn_errOverlay", label="Overlay", value="overlay"))
	)),
	column(8, showOutput("Chart1", "highcharts"))
	)
	),
	conditionalPanel("input.tsp=='about'", source("about.R",local=T)$value)
))
