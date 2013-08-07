sidebarPanel(
	tags$head(
		tags$style(type="text/css", "select { max-width: 150px; }"),
		tags$style(type="text/css", "textarea { max-width: 150px; }"),
		tags$style(type="text/css", ".jslider { max-width: 300px; }"),
		tags$style(type='text/css', ".well { max-width: 300px; }")
	),
	wellPanel(
		checkboxInput("showWP1",h5("WP1"),FALSE),
		conditionalPanel(condition="input.showWP1",
			div(class="row-fluid",
				div(class="span11",uiOutput("email")),
				div(class="span1",helpPopup('Enter email address','...'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("dataset")),
				div(class="span1",helpPopup('Choose dataset',"..."))
			),
			uiOutput("goButton")
		)
	)
)
