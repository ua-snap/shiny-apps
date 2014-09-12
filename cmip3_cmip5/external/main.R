column(8,
	progressInit(),
	tabsetPanel(
		tabPanel("Time Series",
			conditionalPanel(condition="input.vars == null || (input.doms == null && input.cities == '') ||
				( (input.cmip3scens == null || input.cmip3models == null) && (input.cmip5scens == null || input.cmip5models == null) )", uiOutput("tsText")),
			plotOutput("plot1",height="auto"),
			uiOutput("tsTextSub"),
			uiOutput("Table1"),
			value="plot1"),
		tabPanel("Scatter Plot",
			conditionalPanel(condition="input.vars == null || (input.doms == null && input.cities == '') ||
				( (input.cmip3scens == null || input.cmip3models == null) && (input.cmip5scens == null || input.cmip5models == null) )", uiOutput("spText")),
			plotOutput("plot2",height="auto"),
			uiOutput("spTextSub"),
			uiOutput("Table2"),
			value="plot2"),
		tabPanel("Variability",
			conditionalPanel(condition="input.vars == null || (input.doms == null && input.cities == '') ||
				( (input.cmip3scens == null || input.cmip3models == null) && (input.cmip5scens == null || input.cmip5models == null) )", uiOutput("varText")),
			plotOutput("plot3",height="auto"),
			uiOutput("varTextSub"),
			uiOutput("Table3"),
			value="plot3"),
		tabPanelAbout(),
		type="pill",
		id="tsp"
	)
)
