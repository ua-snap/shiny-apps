library(shiny)
library(shinythemes)
shinyUI(fluidPage(theme=shinytheme("united"),
  tags$head(includeScript("ga-RV_distributionsV2.js"), includeScript("ga-allapps.js")),
	headerPanel(
		HTML('Distributions of Random Variables v2
			<a href="http://snap.uaf.edu" target="_blank"><img align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" /></a>'
		), "Distributions of Random Variables"
	),
	fluidRow(
		column(4,
			wellPanel(
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
				downloadButton("dldat", "Download Sample", class="btn-warning")
			)
		),
		column(8,
			tabsetPanel(
				tabPanel("Plot",plotOutput("plot",height="600px")),
				tabPanel("Summary",verbatimTextOutput("summary")),
				tabPanel("Table",tableOutput("table"))
			)
		)
	)
))
