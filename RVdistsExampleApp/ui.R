library(shiny)
shinyUI(pageWithSidebar(
	headerPanel("Distributions of Random Variables"),
	sidebarPanel(
		radioButtons("dist","Distribution type:",
			list("Normal"="norm","Uniform"="unif","t"="t","F","Gamma"="gam","Exponential"="exp","Chi-square"="chisq","Log-normal"="lnorm","Beta"="beta")),
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
		),
		h3(textOutput("caption"))
	)
))
