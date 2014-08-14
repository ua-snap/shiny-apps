library(shiny)
shinyUI(pageWithSidebar(
	headerPanel(
		HTML(
			'<script>
			(function(i,s,o,g,r,a,m){i[\'GoogleAnalyticsObject\']=r;i[r]=i[r]||function(){
			(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
			m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
			})(window,document,\'script\',\'//www.google-analytics.com/analytics.js\',\'ga\');
			ga(\'create\', \'UA-46129458-2\', \'rstudio.com\');
			ga(\'send\', \'pageview\');
			</script>
			<div id="stats_header">
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
			list("Normal"="norm","Uniform"="unif","t"="t","F"="F","Gamma"="gam","Exponential"="exp","Chi-square"="chisq","Log-normal"="lnorm","Beta"="beta")),
		sliderInput("n","Sample size:",1,1000,500),
		uiOutput("dist1"),
		uiOutput("dist2"),
		checkboxInput("density","Show density curve",FALSE),
		conditionalPanel(
			condition="input.density==true",
			numericInput("bw","bandwidth:",1)
		),
		downloadButton('dldat', 'Download Sample')#,
		#h5(textOutput("pageviews"))
	),
	mainPanel(
		tabsetPanel(
			tabPanel("Plot",plotOutput("plot",height="600px")),
			tabPanel("Summary",verbatimTextOutput("summary")),
			tabPanel("Table",tableOutput("table"))
		)
	)
))
