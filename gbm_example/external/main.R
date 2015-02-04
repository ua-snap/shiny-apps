column(8,
	tabsetPanel(
		tabPanel("Relative Influence", plotOutput("PlotRI", width="100%", height="auto"), 
			dataTableOutput("RITable"),
			#fluidRow(column(4, dataTableOutput("RITableOOB")), column(4, dataTableOutput("RITableTest")), column(4, dataTableOutput("RITableCV"))),
			value="ri"),
		tabPanel("Error Curves", plotOutput("PlotBestIter", width="100%", height="auto"), dataTableOutput("BestIterTable"), value="error"),
		tabPanelAbout(),
		type="pills",
		id="tsp"
	)
)
