column(9,
conditionalPanel(condition='input.goButton > 0',
	conditionalPanel(condition="input.tsp == 'classError'",
		fluidRow( column(10, uiOutput("tp.classError")), column(2, downloadButton("dl_classErrorPlot","Get Plot", class="btn-block btn-warning")) ),
		plotOutput("classErrorPlot", width="100%", height="auto")
	),
	conditionalPanel(condition="input.tsp == 'impAcc'",
		fluidRow( column(10, uiOutput("tp.impAcc")), column(2, downloadButton("dl_impAccPlot","Get Plot", class="btn-block btn-warning")) ),
		plotOutput("impAccPlot", width="100%", height="auto")
	),
	conditionalPanel(condition="input.tsp == 'impGini'",
		fluidRow( column(10,  uiOutput("tp.impGini")), column(2, downloadButton("dl_impGiniPlot","Get Plot", class="btn-block btn-warning")) ),
		plotOutput("impGiniPlot", width="100%", height="auto")
	),
	conditionalPanel(condition="input.tsp == 'impTable'",
		fluidRow( column(10, uiOutput("tp.impTable")), column(2, downloadButton("dl_impTablePlot","Get Plot", class="btn-block btn-warning")) ),
		plotOutput("impTablePlot", width="100%", height="auto")
	),
	conditionalPanel(condition="input.tsp == 'mds'",
		fluidRow( column(10, uiOutput("tp.mds")), column(2, downloadButton("dl_mdsPlot","Get Plot", class="btn-block btn-warning")) ),
		plotOutput("mdsPlot", width="100%", height="auto")
	),
	conditionalPanel(condition="input.tsp == 'margins'",
		fluidRow( column(10, uiOutput("tp.margins")), column(2, downloadButton("dl_marginPlot","Get Plot", class="btn-block btn-warning")) ),
		plotOutput("marginPlot", width="100%", height="auto")
	),
	conditionalPanel(condition="input.tsp == 'pd'",
		fluidRow( column(6, uiOutput("tp.pd")), column(2, uiOutput("responseclass")), column(2, uiOutput("predictor")), column(2, downloadButton("dl_pdPlot","Get Plot", class="btn-block btn-warning")) ),
		plotOutput("pdPlot", width="100%", height="auto")
	),
	conditionalPanel(condition="input.tsp == 'outliers'",
		fluidRow( column(8, uiOutput("tp.outliers")), column(2, uiOutput("n.outliers")), column(2, downloadButton("dl_outlierPlot","Get Plot", class="btn-block btn-warning")) ),
		plotOutput("outlierPlot", width="100%", height="auto")
	),
	conditionalPanel(condition="input.tsp == 'errorRate'",
		fluidRow( column(10, uiOutput("tp.errorRate")), column(2, downloadButton("dl_errorRatePlot","Get Plot", class="btn-block btn-warning")) ),
		plotOutput("errorRatePlot", width="100%", height="auto")
	),
	conditionalPanel(condition="input.tsp == 'varsUsed'",
		fluidRow( column(10, uiOutput("tp.varsUsed")), column(2, downloadButton("dl_varsUsedPlot","Get Plot", class="btn-block btn-warning")) ),
		plotOutput("varsUsedPlot", width="100%", height="auto")
	),
	conditionalPanel(condition="input.tsp == 'numVar'",
		fluidRow( column(6, uiOutput("tp.numVar")), column(2, uiOutput("n.reps")), column(2, uiOutput("cvRepsButton")), column(2, downloadButton("dl_numVarPlot","Get Plot", class="btn-block btn-warning")) ),
		fluidRow("Also take care if you copy this app and run on your local machine. This replicated, nested cross-validation can consume 100% of your CPU resources while running."),
		plotOutput("numVarPlot", width="100%", height="auto")
	),
	conditionalPanel(condition="input.tsp == 'about'", tabPanelAbout())
)
)
