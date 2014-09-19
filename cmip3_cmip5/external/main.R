column(8,
	progressInit(),
	tabsetPanel(
		tabPanel("Time Series",
			help_tabpanel_conditional,
			conditionalPanel(condition="input.goButton !== null && input.goButton > 0",
				plotOutput("PlotTS",height="auto"),
				uiOutput("tsTextSub"),
				uiOutput("TableTS")
			),
			value="plot_ts"),
		tabPanel("Scatter Plot",
			help_tabpanel_conditional,
			conditionalPanel(condition="input.goButton !== null && input.goButton > 0",
				plotOutput("PlotScatter",height="auto"),
				uiOutput("spTextSub"),
				uiOutput("TableScatter")
			),
			value="plot_scatter"),
		tabPanel("Heat Map",
			help_tabpanel_conditional,
			conditionalPanel(condition="input.goButton !== null && input.goButton > 0",
				plotOutput("PlotHeatmap",height="auto"),
				uiOutput("hmTextSub"),
				uiOutput("TableHeatmap")
			),
			value="plot_heatmap"),
		tabPanel("Variability",
			help_tabpanel_conditional,
			conditionalPanel(condition="input.goButton !== null && input.goButton > 0",
				plotOutput("PlotVariability",height="auto"),
				uiOutput("varTextSub"),
				uiOutput("TableVariability")
			),
			value="plot_variability"),
		tabPanelAbout(),
		type="pill",
		id="tsp"
	)
)
