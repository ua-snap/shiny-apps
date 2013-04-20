library(shiny)
shinyUI(pageWithSidebar(
	headerPanel("Distributions of Random Variables"),
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
			downloadButton('dldat', 'Download Sample')
		)
	),
	mainPanel(
		tabsetPanel(
			tabPanel("Plot",plotOutput("plot",height="auto")),
			tabPanel("Summary",verbatimTextOutput("summary")),
			tabPanel("Table",tableOutput("table"))
		)
	)
))
