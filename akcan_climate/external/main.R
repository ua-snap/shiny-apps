column(8,
	tabsetPanel(
		tabPanel("Communities",
		plotOutput("plot1", width="100%", height="auto"),
		fluidRow(
			column(2, uiOutput("colorseq")),
			column(2, uiOutput("colorpalettes")),
			column(2, uiOutput("legendPos1")),
			column(2, uiOutput("plotFontSize")),
			column(2, uiOutput("bartype")),
			column(2, uiOutput("bardirection"))
		),
		conditionalPanel(condition='input.plotButton > 0',
			fluidRow(
				column(2, downloadButton("dlCurPlot1", "Get Plot", class="btn-block btn-info")),
				column(2, downloadButton("dlCurTable1", "Get Data", class="btn-block btn-info")),
				column(8, tableOutput("subset.table"))
			)
		),
		value="communities"),
		tabPanelAbout(),
		id="tsp"
	)
)
