# @knitr main
column(8,
	help_tabpanel_conditional,
	conditionalPanel(condition="input.tsp == 'plot_ts' && input.goButton !== null && input.goButton > 0",
		plotOutput("PlotTS", width="100%", height="auto"),
		uiOutput("tsTextSub"),
		uiOutput("TableTS")
	),
	conditionalPanel(condition="input.tsp == 'plot_scatter' && input.goButton !== null && input.goButton > 0",
		plotOutput("PlotScatter", width="100%", height="auto"),
		uiOutput("spTextSub"),
		uiOutput("TableScatter")
	),
	conditionalPanel(condition="input.tsp == 'plot_heatmap' && input.goButton !== null && input.goButton > 0",
		plotOutput("PlotHeatmap", width="100%", height="auto"),
		uiOutput("hmTextSub"),
		uiOutput("TableHeatmap")
	),
	conditionalPanel(condition="input.tsp == 'plot_variability' && input.goButton !== null && input.goButton > 0",
		plotOutput("PlotVariability", width="100%", height="auto"),
		uiOutput("varTextSub"),
		uiOutput("TableVariability")
	),
	conditionalPanel(condition="input.tsp == 'plot_spatial' && input.goButton !== null && input.goButton > 0",
		conditionalPanel(condition="input.loctype == 'Cities'", HTML('<h4>Spatial distributions cannot be shown for city locations.<br/>Select a regional scale option.</h4>')),
        conditionalPanel(condition="input.loctype != 'Cities'",
            plotOutput("PlotSpatial", width="100%", height="auto"),
            uiOutput("spatialTextSub"),
            uiOutput("TableSpatial")
        )
	)
)
