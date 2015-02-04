column(9,
	tabsetPanel(
		tabPanel("Daily Precipitation",
			fluidRow(
				column(8, uiOutput("TpDailyTitle")),
				conditionalPanel(condition="input.genPlotButton>0 && input.loc!==''",
					column(2, downloadButton("dl_plotDailyPrecipPNG", "Get PNG", class="btn-block btn-primary")),
					column(2, downloadButton("dl_plotDailyPrecipPDF", "Get PDF", class="btn-block btn-primary"))
				)
			),
			plotOutput("plotDailyPrecip", width="100%", height="auto"),
			br(), value="daily"),
		tabPanelAbout(),
		type="pills",
		id="tsp"
	)
)
