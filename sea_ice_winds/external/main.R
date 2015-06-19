column(8,
	tabsetPanel(
		tabPanel("Time series plots",
			plotOutput("plotByYear", width="100%", height="auto"),
			plotOutput("plotByDecade", width="100%", height="auto"), br(), br(),
			fluidRow(
				column(6, downloadButton("dl_plotByYear","Annual graphic", class="btn-block btn-primary"), br()),
				column(6, downloadButton("dl_plotByDecade","Decadal graphic", class="btn-block btn-primary"))
			),
			value="ts"),
		tabPanelAbout(),
		id="tsp"
	)
)
