sidebarPanel_2(
	span="span3",
	tags$head(
		tags$style(type="text/css", "select { max-width: 500px; width: 100%; }"),
		tags$style(type="text/css", "textarea { max-width: 500px; width: 100%; }"),
		tags$style(type="text/css", ".jslider { max-width: 500px; width: 100%; }"),
		tags$style(type="text/css", ".well { max-width: 500px; }")
	),
	wellPanel(
		checkboxInput("showDataPanel1",h5("Data Selection"),TRUE),
		conditionalPanel(condition="input.showDataPanel1",
			#uiOutput("dat.name"),
			div(class="row-fluid",
				div(class="span11",uiOutput("response")),
				div(class="span1",helpPopup('Choose a response variable','<p style="text-align:justify">Currently, choices are restricted to categorical variables for classification until I find time to generalize the app to include regression.</p>'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("explanatory")),
				div(class="span1",helpPopup('Choose explanatory variables','<p style="text-align:justify">For convenience, I added a nifty button for selecting/deselecting all. I do not think it works on the first click though.</p>'))
			),
			uiOutput("selectDeselect")
		)
	),
	wellPanel(
		checkboxInput("showRFPanel1",h5("Random Forest"),TRUE),
		conditionalPanel(condition="input.showRFPanel1",
			uiOutput("ntrees"),
			uiOutput("goButton")
		)
	),
	navlistPanel(
		"Classification Information",
		tabPanel("Class Error", value="classError"),
		tabPanel("Class Margins", value="margins"),
		tabPanel("2-D MDS",value="mds"),
		tabPanel("Partial Dependence", value="pd"),
		tabPanel("Outliers", value="outliers"),
		"Importance Measures",
		tabPanel("Importance: OOB", value="impAcc"),
		tabPanel("Importance: Gini", value="impGini"),
		tabPanel("Importance: Table", value="impTable"),
		"Error and Variable Selection",
		tabPanel("Error Rate", value="errorRate"),
		tabPanel("Variable Use", value="varsUsed"),
		tabPanel("Number of Variables", value="numVar"),
		"About the App",
		tabPanel("About", value="about"),
		id="nlp",
		widths=c(12,1)
	),
	h5(textOutput("pageviews"))
)
