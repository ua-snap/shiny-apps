column(9,
	tabsetPanel(
		tabPanel("Correlation Plots",
			plotOutput("macorplot", width="100%", height="auto"),
			br(), value="ts"),
		tabPanelAbout(),
		id="tsp"
	)
)
