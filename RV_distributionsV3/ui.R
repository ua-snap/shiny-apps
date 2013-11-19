library(shiny)
shinyUI(pageWithSidebar(
	headerPanel(
		HTML(
			'<div id="stats_header">
			Distributions of Random Variables
			<a href="http://snap.uaf.edu" target="_blank">
			<img id="stats_logo" align="right" alt="SNAP Logo" src="http://www.snap.uaf.edu/images/snap_acronym_rgb.gif" />
			</a>
			</div>'
		),
		"Distributions of Random Variables"
	),
	sidebarPanel(
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
		downloadButton('dldat', 'Download Sample'),
		h5(textOutput("pageviews"))
	),
	mainPanel(
		tabsetPanel(
			tabPanel("Plot",plotOutput("plot",height="auto")),
			tabPanel("Summary",verbatimTextOutput("summary")),
			tabPanel("Table",tableOutput("table"))
		)
	)
))
