library(shiny)
shinyUI(pageWithSidebar(
	headerPanel(
		HTML('<div id="stats_header">
		Distributions of Random Variables
		<a href="http://snap.uaf.edu" target="_blank">
		<img id="stats_logo" align="right" alt="SNAP Logo" src="http://www.snap.uaf.edu/images/snap_acronym_rgb.gif" />
		</a>
		</div>'
	)),
	sidebarPanel(
		radioButtons("dist","Distribution type:",
			list("Normal"="norm","Uniform"="unif","t"="t","F"="F","Gamma"="gam","Exponential"="exp","Chi-square"="chisq","Log-normal"="lnorm","Beta"="beta")),
		sliderInput("n","Sample size:",1,1000,500),
		uiOutput("dist1"),
		uiOutput("dist2"),
		checkboxInput("density","Show density curve",FALSE),
		conditionalPanel(
			condition="input.density==true",
			numericInput("bw","bandwidth:",1)
		),
		downloadButton('dldat', 'Download Sample')
	),
	mainPanel(
		tabsetPanel(
			tabPanel("Plot",plotOutput("plot",height="600px")),
			tabPanel("Summary",verbatimTextOutput("summary")),
			tabPanel("Table",tableOutput("table"))
		)
	)
))
