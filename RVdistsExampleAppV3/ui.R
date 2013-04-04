library(shiny)
shinyUI(pageWithSidebar(
	headerPanel("Distributions of Random Variables"),
	sidebarPanel(
		radioButtons("dist","Distribution type:",
			list(
				"Bernoulli"="bern","Binomial"="bin","Discrete Uniform"="dunif","Geometric"="geom","Hypergeometric"="hgeom","Negative Binomial"="nbin","Poisson"="poi", # discrete
				"Beta"="beta","Cauchy"="cauchy","Chi-squared"="chisq","Exponential"="exp","F"="F","Gamma"="gam","Laplace (Double Exponential)"="lap", # continuous
				"Logistic"="logi","Log-Normal"="lnorm","Normal"="norm","Pareto"="pareto","t"="t","Uniform"="unif","Weibull"="weib"
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
		downloadButton('dldat', 'Download Sample')
	),
	mainPanel(
		tabsetPanel(
			tabPanel("Plot",plotOutput("plot",height="auto")),
			tabPanel("Summary",verbatimTextOutput("summary")),
			tabPanel("Table",tableOutput("table"))
		),
		h3(textOutput("caption"))
	)
))
