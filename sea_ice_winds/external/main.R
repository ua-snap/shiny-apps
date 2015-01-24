column(8,
	tabsetPanel(
		tabPanel("Time series plots",
			plotOutput("plotByYear",height="auto"),
			plotOutput("plotByDecade",height="auto"),
			value="ts"),
		tabPanelAbout(),
		id="tsp"
	)
)
