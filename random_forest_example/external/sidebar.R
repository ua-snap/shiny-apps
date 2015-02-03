column(3,
	wellPanel(
		checkboxInput("showDataPanel1",h5("Data Selection"),TRUE),
		conditionalPanel(condition="input.showDataPanel1",
			#uiOutput("dat.name"),
			fluidRow(
				column(12, uiOutput("response"))
			),
			fluidRow(
				column(12, uiOutput("explanatory"))
			),
			uiOutput("selectDeselect")
		)
	),
	wellPanel(
		checkboxInput("showRFPanel1", h5("Random Forest"), TRUE),
		conditionalPanel(condition="input.showRFPanel1",
			uiOutput("ntrees"),
			uiOutput("goButton")
		)
	)
)
