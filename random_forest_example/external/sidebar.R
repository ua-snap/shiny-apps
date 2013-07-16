sidebarPanel_2(
	span="span2",
	tags$head(
		tags$style(type="text/css", "select { max-width: 150px; }"),
		tags$style(type="text/css", "textarea { max-width: 150px; }"),
		tags$style(type="text/css", ".jslider { max-width: 300px; }"),
		tags$style(type='text/css', ".well { max-width: 300px; }")
	),
	wellPanel(
		checkboxInput("showDataPanel1",h5("Data Selection"),FALSE),
		conditionalPanel(condition="input.showDataPanel1",
			uiOutput("dat.name"),
			uiOutput("response"),
			uiOutput("explanatory"),
			uiOutput("selectDeselect")
		)
	),
	wellPanel(
		checkboxInput("showRFPanel1",h5("Random Forest"),FALSE),
		conditionalPanel(condition="input.showRFPanel1",
			uiOutput("ntrees"),
			uiOutput("goButton")
		)
	)
)
