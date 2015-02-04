column(10,
	tabsetPanel(
		tabPanel("Monty Hall probabilities",
			plotOutput("mhplot", width="100%", height="auto"),
			br(), value="ts"),
		tabPanelAbout(),
		id="tsp"
	)
)
