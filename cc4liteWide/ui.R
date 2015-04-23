shinyUI(navbarPage(theme=shinytheme("cerulean"),
	title=HTML('<div><a href="http://snap.uaf.edu" target="_blank"><img src="./img/SNAP_acronym_100px.png" width="80%"></a></div>'),
	tabPanel("Community Charts", value="commChart"),
	tabPanel("About", value="about"),
	windowTitle="CC4L Gamma",
	collapsible=TRUE,
	id="tsp",
	tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),
	h4("Community Charts v4 Lite [Delta] ~ See the climate outlook for your community."),
	conditionalPanel("input.tsp=='commChart'",
	fluidRow(
		column(3, selectInput("location", "Community", c("", locs), selected="", multiple=F, width="100%")),
		column(3, selectInput("dec", "Decades", dec.lab, selected=dec.lab[c(1,4,6,9)], multiple=TRUE, width="100%")),
		column(2, selectInput("variable", "Climate Variable", c("Temperature", "Precipitation"), selected="Temperature", multiple=F, width="100%")),
		column(2, selectInput("units", "Units", c("C, mm", "F, in"), selected="C, mm", multiple=F, width="100%")),
		column(2, selectInput("rcp", "Emissions", c("Low (RCP 4.5)", "Medium (RCP 6.0)", "High (RCP 8.5)"), selected="Medium (RCP 6.0)", multiple=F, width="100%"))
	),
	fluidRow(
	#column(4, wellPanel(
	#	selectInput("location", "See the climate outlook for your community.", c("", locs), selected="", multiple=F, width="100%"),
	#	selectInput("dec", "Decades", dec.lab, selected=dec.lab[c(1,4,6,9)], multiple=TRUE, width="100%"),
	#	bsButtonGroup("variable", label="Climate Variable", toggle="radio", value="Temperature", style="primary", size="small", block=T,
	#		bsButton("btn_T", label="Temperature", value="Temperature"), bsButton("btn_P", label="Precipitation", value="Precipitation")),
	#	bsButtonGroup("units", label="Units", toggle="radio", value="Cmm", style="primary", size="small", block=T, bsButton("btn_U", label="C, mm", value="Cmm"), bsButton("btn_UT2", label="F, in", value="Fin")),
	#	bsButtonGroup("rcp", label="Emissions", toggle="radio", value="r60", style="primary", size="small", block=T,
	#		bsButton("btn_r45", label="Low (RCP 4.5)", value="r45"), bsButton("btn_r60", label="Medium (RCP 6.0)", value="r60"), bsButton("btn_r85", label="High (RCP 8.5)", value="r85"))
	#)),
	column(12,
		showOutput("Chart1", "highcharts"),
		HTML('<style>.rChart {width: 100%; height: "auto"}</style>')
	)
	)
	),
	conditionalPanel("input.tsp=='about'", source("about.R",local=T)$value)
))
