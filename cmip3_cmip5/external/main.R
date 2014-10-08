column(8,
	help_tabpanel_conditional,
	conditionalPanel(condition="input.tsp == 'plot_ts' && input.goButton !== null && input.goButton > 0",
		plotOutput("PlotTS",height="auto"),
		uiOutput("tsTextSub"),
		uiOutput("TableTS")
	),
	conditionalPanel(condition="input.tsp == 'plot_scatter' && input.goButton !== null && input.goButton > 0",
		plotOutput("PlotScatter",height="auto"),
		uiOutput("spTextSub"),
		uiOutput("TableScatter")
	),
	conditionalPanel(condition="input.tsp == 'plot_heatmap' && input.goButton !== null && input.goButton > 0",
		plotOutput("PlotHeatmap",height="auto"),
		uiOutput("hmTextSub"),
		uiOutput("TableHeatmap")
	),
	conditionalPanel(condition="input.tsp == 'plot_variability' && input.goButton !== null && input.goButton > 0",
		plotOutput("PlotVariability",height="auto"),
		uiOutput("varTextSub"),
		uiOutput("TableVariability")
	),
	conditionalPanel(condition="input.tsp == 'plot_spatial' && input.goButton !== null && input.goButton > 0",
		plotOutput("PlotSpatial",height="auto"),
		uiOutput("spatialTextSub"),
		uiOutput("TableSpatial")
	)
)
