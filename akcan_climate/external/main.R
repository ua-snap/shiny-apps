column(8,
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
		conditionalPanel(condition='input.plotButton > 0',
			div(class="row-fluid",
				div(class="span2", downloadButton("dlCurPlot1","Download graphic")),
				div(class="span2", downloadButton("dlCurTable1","Download table")),
				div(class="span8", tableOutput("subset.table"))
			)
		),
		value="communities"),
		tabPanel("Tab #2", uiOutput("debugging"), value="tab2"),
		tabPanelAbout(),
		id="tsp"
	)
)
