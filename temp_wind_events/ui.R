library(shiny)
tabPanelAbout <- source("about.r")$value
headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}
shinyUI(pageWithSidebar(
	headerPanel_2(
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
			CMIP5 Quantile-mapped GCM Daily Data
			<a href="http://accap.uaf.edu" target="_blank">
			<img id="stats_logo" align="right" alt="ACCAP Logo" src="./img/ACCAP_acronym_100px.png" />
			</a>
			<a href="http://snap.uaf.edu" target="_blank">
			<img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" />
			</a>
			</div>'
		), h3, "CMIP5 Quantile-mapped GCM Daily Data"
	),
	sidebarPanel(
		tags$head(
			tags$style(type="text/css", "select { max-width: 500px; width: 100%; }"),
			tags$style(type="text/css", "textarea { max-width: 500px; width: 100%; }"),
			tags$style(type="text/css", ".jslider { max-width: 500px; width: 100%; }"),
			tags$style(type="text/css", ".well { max-width: 500px; }")
		  ),
		uiOutput("showMapPlot"),
		wellPanel(
			h5("Time"),
			sliderInput("yrs","",1958,2100,c(1981,2010),step=1,format="#"),
			div(class="row-fluid", div(class="span6", uiOutput("Mo")), div(class="span6", uiOutput("MoHi")))
		),
		wellPanel(
			h5("Climate and Geography"),
			div(class="row-fluid", div(class="span6", uiOutput("Var")), div(class="span6", uiOutput("Loc"))),
			div(class="row-fluid", div(class="span6", uiOutput("Mod")),	div(class="span6", uiOutput("RCP")))
		),
		wellPanel(
			h5("Thresholds and Conditionals"),
			div(class="row-fluid", div(class="span6", uiOutput("CutT")), div(class="span6", uiOutput("CutW"))),
			div(class="row-fluid", div(class="span6", uiOutput("Direction")), div(class="span6", uiOutput("Cond"))),
			p("Positve values for directional wind components indicate West to East and South to North, like an X-Y graph.")
		),
		wellPanel(div(class="row-fluid", div(class="span6", uiOutput("showMap")), div(class="span6", downloadButton("dlCurPlot", "Download Graphic")))),
		conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
	),
	mainPanel(
		tabsetPanel(
			tabPanel("Conditional Barplots",plotOutput("plot",height="auto"),value="barplots"),
			tabPanelAbout(),
			id="tsp"
		)
	)
))
