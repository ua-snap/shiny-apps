library(shiny)
library(shinythemes)
shinyUI(fluidPage(theme=shinytheme("united"),
  tags$head(includeScript("ga-RV_distributionsV3.js"), includeScript("ga-allapps.js")),
	headerPanel(
		HTML('Distributions of Random Variables v3
			<a href="http://snap.uaf.edu" target="_blank"><img align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" /></a>'
		), "Distributions of Random Variables"
	),
	fluidRow(
		column(4,
			wellPanel(
				radioButtons("dist","Distribution type:",
					list(
						"Bernoulli"="bern","Binomial"="bin","Discrete Uniform"="dunif","Geometric"="geom","Hypergeometric"="hgeom","Negative Binomial"="nbin","Poisson"="poi", # discrete
						"Beta"="beta","Cauchy"="cauchy","Chi-squared"="chisq","Exponential"="exp","F"="F","Gamma"="gam","Laplace (Double Exponential)"="lap", # continuous
						"Logistic"="logi","Log-Normal"="lognorm","Normal"="norm","Pareto"="pareto","t"="t","Uniform"="unif","Weibull"="weib"
						)
				),
				sliderInput("n","Sample size:",1,1000,500),
				uiOutput("dist1"),
				uiOutput("dist2"),
				uiOutput("dist3"),
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
				tabPanel("Plot",plotOutput("plot",height="auto")),
				tabPanel("Summary",verbatimTextOutput("summary")),
				tabPanel("Table",tableOutput("table"))
			)
		)
	)
))
