column(8,
	tabsetPanel(
		tabPanel("Time Series",
			uiOutput("tsText"),
			plotOutput("plot1",height="auto"),
			uiOutput("tsTextSub"),
			uiOutput("ButtonsAndTable"),
			value="plot1"),
		tabPanel("Scatter Plot",
			uiOutput("spText"),
			plotOutput("plot2",height="auto"),
			uiOutput("spTextSub"),
			uiOutput("ButtonsAndTable2"),
			value="plot2"),
		tabPanel("Variability",
			uiOutput("varText"),
			plotOutput("plot3",height="auto"),
			uiOutput("varTextSub"),
			uiOutput("ButtonsAndTable3"),
			value="plot3"),
		tabPanelAbout(),
		id="tsp"
	)
)
