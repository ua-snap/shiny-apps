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
			#uiOutput("dat.name"),
			div(class="row-fluid",
				div(class="span11",uiOutput("response")),
				div(class="span1",helpPopup('Choose a response variable','Currently, choices are restricted to categorical variables for classification until I find time to generalize the app to include regression.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("explanatory")),
				div(class="span1",helpPopup('Choose explanatory variables',"For convenience, I added a nifty button for selecting/deselecting all. I don't think it works on the first click though."))
			),
			uiOutput("selectDeselect")
		)
	),
	wellPanel(
		checkboxInput("showRFPanel1",h5("Random Forest"),FALSE),
		conditionalPanel(condition="input.showRFPanel1",
			uiOutput("ntrees"),
			uiOutput("goButton")
		)
	),
	h5(textOutput("pageviews"))
)
