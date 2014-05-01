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
			Modeled Arctic Sea Ice Coverage
			<a href="http://accap.uaf.edu" target="_blank">
			<img id="stats_logo" align="right" style="margin-left: 15px;" alt="ACCAP Logo" src="./img/ACCAP_acronym_100px.png" />
			</a>
			<a href="http://snap.uaf.edu" target="_blank">
			<img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" />
			</a>
			</div>'
		), h3, "Modeled Arctic Sea Ice Coverage"
	),
	sidebarPanel(
		wellPanel(
			conditionalPanel( # Tab 1 only, part 1
				condition="input.tsp=='ts'",
				uiOutput("Dataset"),
				uiOutput("tsSlider"),
				uiOutput("Mo")
			),
			conditionalPanel( # Tab 2 only, part 1
				condition="input.tsp=='map'",
				uiOutput("Decade"),
				uiOutput("Mo2")
			)
		),
		conditionalPanel( # Tab 1 only,  part 2
			condition="input.tsp=='ts'",
			wellPanel(
				uiOutput("regpoints"),
				uiOutput("reglines"),
				uiOutput("reglineslm1"),
				uiOutput("reglineslm2"),
				uiOutput("reglineslo"),
				uiOutput("loSpan"),
				uiOutput("fixXY"),
				uiOutput("semiTrans"),
				uiOutput("showObs")
			)
		),
		wellPanel(
			conditionalPanel( # Tab 1 only,  part 3
				condition="input.tsp=='ts'",
				downloadButton("dlCurPlotTS", "Download Graphic")
			),
			conditionalPanel( # Tab 2 only,  part 3
				condition="input.tsp=='map'",
				downloadButton("dlCurPlotMap", "Download Graphic")
			)
		),
		conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
	),
	mainPanel(
		tabsetPanel(
			tabPanel(
				"Extent Totals",
				h4("RCP 8.5 Sea Ice Extent Totals"),
				plotOutput("plot",height="auto"),
				conditionalPanel("input.reglnslm1==true",
					p(strong("Linear Model")),
					verbatimTextOutput("lm1_summary")
				),
				conditionalPanel("input.reglnslm2==true",
					p(strong("Linear Model w/ Quadratic Term")),
					verbatimTextOutput("lm2_summary")
				),
				conditionalPanel("input.reglnslo==true",
					p(strong("Locally Weighted LOESS Model")),
					verbatimTextOutput("lo_summary")
				),
			value="ts"),
			tabPanel("Concentration Map",h4("RCP 8.5 Sea Ice Concentration"),plotOutput("plot2",height="auto"),value="map"),
			tabPanelAbout(),
			id="tsp"
		)
	)
))
