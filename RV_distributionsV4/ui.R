library(shiny)
tabPanelAbout <- source("about.r")$value
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
			<img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" />
			</a>
			</div>'
		),
		"Distributions of Random Variables"
	),
	sidebarPanel(
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
			downloadButton("dlCurPlot", "Download Graphic"),
			downloadButton('dldat', 'Download Sample')
		)#,
		#conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
	),
	mainPanel(
		tabsetPanel(
			tabPanel("Plot",plotOutput("plot",height="auto")),
			tabPanel("Summary",verbatimTextOutput("summary")),
			tabPanel("Table",tableOutput("table")),
			tabPanelAbout(),
			id="tsp"
		)
	)
))
