mainPanel_2(
	span="span9",
	tabsetPanel(
		tabPanel("Daily Precipitation",
			div(class="row-fluid",
				div(class="span8", uiOutput("TpDailyTitle")),
				conditionalPanel(condition="input.genPlotButton>0 && input.loc!==''",
					div(class="span2", downloadButton("dl_plotDailyPrecipPNG","Download PNG")),
					div(class="span2", downloadButton("dl_plotDailyPrecipPDF","Download PDF"))
				)
			),
			plotOutput("plotDailyPrecip",height="auto"),
			br(), value="daily"),
		tabPanelAbout(),
		id="tsp"
	)
)
