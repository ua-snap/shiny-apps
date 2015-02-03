column(8,
	tabsetPanel(
		tabPanel("Time series plots",
			plotOutput("plotByYear", width="100%", height="auto"),
			plotOutput("plotByDecade", width="100%", height="auto"),
			value="ts"),
		tabPanelAbout(),
		id="tsp"
	)
)
