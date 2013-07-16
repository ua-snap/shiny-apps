mainPanel_2(
	span="span10",
	conditionalPanel(condition='input.goButton > 0',
	tabsetPanel(
		tabPanel("Class Error", 
			div(class="row-fluid",
				div(class="span10", uiOutput("tp.classError")),
				div(class="span2", downloadButton("dl_classErrorPlot","Download graphic"))
			),
			plotOutput("classErrorPlot",height="auto"), value="classError"),
		tabPanel("Importance: OOB",
			div(class="row-fluid",
				div(class="span10", uiOutput("tp.impAcc")),
				div(class="span2", downloadButton("dl_impAccPlot","Download graphic"))
			),
			plotOutput("impAccPlot",height="auto"), value="impAcc"),
		tabPanel("Importance: Gini",
			div(class="row-fluid",
				div(class="span10", uiOutput("tp.impGini")),
				div(class="span2", downloadButton("dl_impGiniPlot","Download graphic"))
			),
			plotOutput("impGiniPlot",height="auto"), value="impGini"),
		tabPanel("Importance: Table",
			div(class="row-fluid",
				div(class="span10", uiOutput("tp.impTable")),
				div(class="span2", downloadButton("dl_impTablePlot","Download graphic"))
			),
			plotOutput("impTablePlot",height="auto"), value="impTable"),
		tabPanel("2-D MDS",
			div(class="row-fluid",
				div(class="span10", uiOutput("tp.mds")),
				div(class="span2", downloadButton("dl_mdsPlot","Download graphic"))
			),
			plotOutput("mdsPlot",height="auto"), value="mds"),
		tabPanel("Class Margins",
			div(class="row-fluid",
				div(class="span10", uiOutput("tp.margins")),
				div(class="span2", downloadButton("dl_marginPlot","Download graphic"))
			),
			plotOutput("marginPlot",height="auto"), value="margins"),
		tabPanel("Partial Dependence",
			div(class="row-fluid",
				div(class="span6", uiOutput("tp.pd")),
				div(class="span2", uiOutput("responseclass")),
				div(class="span2", uiOutput("predictor")),
				div(class="span2", downloadButton("dl_pdPlot","Download graphic"))
			),
			plotOutput("pdPlot",height="auto"), value="pd"),
		tabPanel("Outliers",
			div(class="row-fluid",
				div(class="span8", uiOutput("tp.outliers")),
				div(class="span2", uiOutput("n.outliers")),
				div(class="span2", downloadButton("dl_outlierPlot","Download graphic"))
			),
			plotOutput("outlierPlot",height="auto"), value="outliers"),
		tabPanel("Error Rate",
			div(class="row-fluid",
				div(class="span10", uiOutput("tp.errorRate")),
				div(class="span2", downloadButton("dl_errorRatePlot","Download graphic"))
			),
			plotOutput("errorRatePlot",height="auto"), value="errorRate"),
		tabPanel("Variable Use",
			div(class="row-fluid",
				div(class="span10", uiOutput("tp.varsUsed")),
				div(class="span2", downloadButton("dl_varsUsedPlot","Download graphic"))
			),
			plotOutput("varsUsedPlot",height="auto"), value="varsUsed"),
		tabPanel("# of Variables",
			div(class="row-fluid",
				div(class="span6", uiOutput("tp.numVar")),
				div(class="span2", uiOutput("n.reps")),
				div(class="span2", uiOutput("cvRepsButton")),
				div(class="span2", downloadButton("dl_numVarPlot","Download graphic"))
			),
			plotOutput("numVarPlot",height="auto"), value="numVar"),
		tabPanelAbout(),
		id="tsp"
	)
	)
)
