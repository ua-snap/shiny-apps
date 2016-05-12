library(shiny)
tabPanelAbout <- source("about.r")$value
library(shinythemes)
shinyUI(fluidPage(theme=shinytheme("united"),
  tags$head(includeScript("ga-RV_distributionsV4.js"), includeScript("ga-allapps.js")),
	headerPanel(
		HTML('Distributions of Random Variables v4
			<a href="http://snap.uaf.edu" target="_blank"><img align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" /></a>'
		), "Distributions of Random Variables"
	),
	fluidRow(
		column(4,
			wellPanel( radioButtons("disttype","Distribution type:",list("Discrete","Continuous"),selected="Discrete") ),
			wellPanel(	uiOutput("distName") ),
			wellPanel(
				numericInput("n","Sample size:",10000),
				uiOutput("dist1"),
				uiOutput("dist2"),
				uiOutput("dist3")
			),
			wellPanel(
				uiOutput("sampDens"),
				uiOutput("BW"),
				fluidRow(
					column(6, downloadButton("dlCurPlot", "Download Graphic", class="btn-block btn-primary")),
					column(6, downloadButton("dldat", "Download Sample", class="btn-block btn-warning"))
				)
			)
		),
		column(8,
			tabsetPanel(
				tabPanel("Plot",plotOutput("plot", width="100%", height="auto")),
				tabPanel("Summary",verbatimTextOutput("summary")),
				tabPanel("Table",tableOutput("table")),
				tabPanelAbout(),
				id="tsp"
			)
		)
	)
))
