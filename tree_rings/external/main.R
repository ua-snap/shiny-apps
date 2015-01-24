column(9,
	tabsetPanel(
		tabPanel("Correlation Plots",
			plotOutput("macorplot",height="auto"),
			br(), value="ts"),
		tabPanelAbout(),
		id="tsp"
	)
)
