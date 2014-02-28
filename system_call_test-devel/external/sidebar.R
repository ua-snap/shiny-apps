#div(style="background-color:#000000; opacity:0.9;",
sidebarPanel(
	tags$head(
		tags$link(rel="stylesheet", type="text/css", href="styles_black_lightblue.css"),
		#tags$link(rel="stylesheet", type="text/css", href="jquery.slider.min.css"),
		tags$style(type="text/css", "select { max-width: 240px; width: 100%; }"),
		tags$style(type="text/css", "textarea { max-width: 500px; width: 100%; }"),
		tags$style(type="text/css", ".jslider { max-width: 500px; width: 100%; }"),
		tags$style(type="text/css", ".well { max-width: 500px; }")
	),
	wellPanel(
		checkboxInput("showWP1",h5("WP1"),TRUE),
		conditionalPanel(condition="input.showWP1",
			div(class="row-fluid",
				div(class="span11",uiOutput("email")),
				div(class="span1",helpPopup('Enter email address','...'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("dataset")),
				div(class="span1",helpPopup('Choose dataset',"..."))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("FIF_Files")),
				div(class="span1",helpPopup('Choose .fif(s)',"..."))
			),
			uiOutput("goButton")
		)
	),
	wellPanel(
		checkboxInput("showWP2",h5("WP2"),TRUE),
		conditionalPanel(condition="input.showWP2",
			div(class="row-fluid",
				div(class="span11",uiOutput("fif_FireSensitivity")),
				div(class="span1",helpPopup('Fire Sensitivity','...'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("fif_IgnitionFactor")),
				div(class="span1",helpPopup('Ignition Factor',"..."))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("Update_fif_Defaults")),
				div(class="span1",helpPopup('Update .fif defaults',"..."))
			),
			actionButton("goButton_fif","Save .fif / run Alfresco") #uiOutput("goButton_fif")
		)
	),
	h5(textOutput("pageviews"))
#)
)
