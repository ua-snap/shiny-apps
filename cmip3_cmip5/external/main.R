column(8,
	progressInit(),
	tabsetPanel(
		tabPanel("Time Series",
			conditionalPanel(condition="input.vars == null || (input.doms == null && input.cities == '') ||
				( (input.cmip3scens == null || input.cmip3models == null) && (input.cmip5scens == null || input.cmip5models == null) )", uiOutput("tsText")),
			plotOutput("PlotTS",height="auto"),
			uiOutput("tsTextSub"),
			uiOutput("TableTS"),
			value="plot_ts"),
		tabPanel("Scatter Plot",
			conditionalPanel(condition="input.vars == null || (input.doms == null && input.cities == '') ||
				( (input.cmip3scens == null || input.cmip3models == null) && (input.cmip5scens == null || input.cmip5models == null) )", uiOutput("spText")),
			plotOutput("PlotScatter",height="auto"),
			uiOutput("spTextSub"),
			uiOutput("TableScatter"),
			value="plot_scatter"),
			tabPanel("Heat Map",
			conditionalPanel(condition="input.vars == null || (input.doms == null && input.cities == '') ||
				( (input.cmip3scens == null || input.cmip3models == null) && (input.cmip5scens == null || input.cmip5models == null) )", uiOutput("hmText")),
			plotOutput("PlotHeatmap",height="auto"),
			uiOutput("hmTextSub"),
			uiOutput("TableHeatmap"),
			value="plot_heatmap"),
		tabPanel("Variability",
			conditionalPanel(condition="input.vars == null || (input.doms == null && input.cities == '') ||
				( (input.cmip3scens == null || input.cmip3models == null) && (input.cmip5scens == null || input.cmip5models == null) )", uiOutput("varText")),
			plotOutput("PlotVariability",height="auto"),
			uiOutput("varTextSub"),
			uiOutput("TableVariability"),
			value="plot_variability"),
		tabPanelAbout(),
		type="pill",
		id="tsp"
	)
)
