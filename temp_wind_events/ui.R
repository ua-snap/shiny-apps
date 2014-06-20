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
			<img id="stats_logo" align="right" style="margin-left: 15px;" alt="ACCAP Logo" src="./img/ACCAP_acronym_100px.png" />
			</a>
			<a href="http://snap.uaf.edu" target="_blank">
			<img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" />
			</a>
			</div>'
		), h3, "CMIP5 Quantile-mapped GCM Daily Data"
	),
	sidebarPanel(
		uiOutput("showMapPlot"),
		wellPanel(
			h5("Time"),
			sliderInput("yrs", "", 1958,2100, c(1981,2010), step=1, format="#", width="100%"),
			div(class="row-fluid",
				div(class="span6", selectInput("mo", "Show months:", choices=c("All",mos), selected="Jan", multiple=T, width="100%")),
				div(class="span6", uiOutput("MoHi")))
		),
		wellPanel(
			h5("Climate and Geography"),
			div(class="row-fluid",
				div(class="span6", selectInput("var", "Climate variable:", choices=var.nam, selected=var.nam[1], multiple=T, width="100%")),
				div(class="span6", selectInput("loc", "Geographic location:", choices=sort(loc.nam), selected=sort(loc.nam)[3], multiple=T, width="100%"))),
			div(class="row-fluid",
				div(class="span6", selectInput("mod", "Climate model:", choices=mod.nam, selected=mod.nam[1], width="100%")),
				div(class="span6", selectInput("rcp", "RCP:", choices=rcp.nam, selected=rcp.nam[1], width="100%")))
		),
		wellPanel(
			h5("Thresholds and Conditionals"),
			div(class="row-fluid",
				div(class="span6", selectInput("cut.t", "Temp. threshold (C):", choices=temp.cut, selected=temp.cut[6], multiple=T, width="100%")),
				div(class="span6", uiOutput("CutW"))),
			div(class="row-fluid",
				div(class="span6", selectInput("direct", "Days per month:", choices=c("Above threshold","Below threshold"), selected="Above threshold", width="100%")),
				div(class="span6", selectInput("cond", "Conditional variable:", choices=c("Model","RCP","Location","Threshold","Variable"), selected="Model", width="100%"))),
			p("Positive values for directional wind components indicate West to East and South to North, like an X-Y graph.")
		),
		wellPanel(div(class="row-fluid", div(class="span6", checkboxInput("showmap","Show location grid",F)), div(class="span6", downloadButton("dlCurPlot", "Download Graphic")))),
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
