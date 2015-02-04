column(8,
	progressInit(),
	tabsetPanel(
		tabPanel("Map",
			plotOutput("PlotMap", width="100%", height="auto"),
			br(), value="map_plot"),
		tabPanelAbout(),
		id="tsp",
		type="pill",
		selected="map_plot"
	)
)
