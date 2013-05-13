library(shiny)
tabPanelAbout <- source("about.r")$value
shinyUI(pageWithSidebar(
	headerPanel(
		HTML(
			'<div id="stats_header">
			Modeled Polar Sea Ice Coverage
			<a href="http://snap.uaf.edu" target="_blank">
			<img id="stats_logo" align="right" alt="SNAP Logo" src="http://www.snap.uaf.edu/images/snap_acronym_rgb.gif" />
			</a>
			</div>'
		),
		"Modeled Polar Sea Ice Coverage"
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
		)
	),
	mainPanel(
		tabsetPanel(
			tabPanel(
				"Extent Totals",
				h4("Sea Ice Extent Totals"),
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
			tabPanel("Concentration Map",h4("Sea Ice Concentration"),plotOutput("plot2",height="auto"),value="map"),
			tabPanelAbout(),
			id="tsp"
		)
	)
))
