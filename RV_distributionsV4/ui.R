library(shiny)
tabPanelAbout <- source("about.r")$value
shinyUI(pageWithSidebar(
	headerPanel(
		HTML(
			'<div id="stats_header">
			Distributions of Random Variables
			<a href="http://snap.uaf.edu" target="_blank">
			<img id="stats_logo" align="right" alt="SNAP Logo" src="./img/snap_sidebyside.png" />
			</a>
			</div>'
		),
		"Distributions of Random Variables"
	),
	sidebarPanel(
		wellPanel( radioButtons("dist.type","Distribution type:",list("Discrete","Continuous"),selected="Discrete") ),
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
			downloadButton("dlCurPlot", "Download Graphic"),
			downloadButton('dldat', 'Download Sample')
		),
		h5(textOutput("pageviews"))
	),
	mainPanel(
		tabsetPanel(
			tabPanel("Plot",plotOutput("plot",height="auto")),
			tabPanel("Summary",verbatimTextOutput("summary")),
			tabPanel("Table",tableOutput("table")),
			tabPanelAbout()
		)
	)
))
