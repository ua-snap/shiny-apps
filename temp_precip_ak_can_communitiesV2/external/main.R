mainPanel(
	tabsetPanel(
		tabPanel("Communities",
		plotOutput("plot1",height="auto"),
		div(class="row-fluid",
			div(class="span2", uiOutput("colorseq")),
			div(class="span2", uiOutput("colorpalettes")),
			div(class="span2", uiOutput("legendPos1")),
			div(class="span2", uiOutput("plotFontSize")),
			div(class="span2", uiOutput("bartype")),
			div(class="span2", uiOutput("bardirection"))
		),
		conditionalPanel(condition='input.goButton > 0',
			div(class="row-fluid",
				div(class="span2", downloadButton("dlCurPlot1","Download graphic")),
				div(class="span2", downloadButton("dlCurTable1","Download table")),
				div(class="span8", tableOutput("subset.table"))
			)
		),
		value="communities"),
		tabPanel("Regions", textOutput("show.gbm1.object.names.if.created.successfully"), value="regions"),
		tabPanelAbout(),
		id="tsp"
	)
)
