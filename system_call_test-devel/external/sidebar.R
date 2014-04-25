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
				div(class="span11",uiOutput("UserEmail")),
				div(class="span1",helpPopup('Enter your email address','Results from the Alfresco run will be emailed to you.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("AddEmail")),
				div(class="span1",helpPopup('Enter additional email addresses','Results from the Alfresco run will be emailed to each address. For the time being, you must separate each email address with a comma and/or space.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("FIF_Files")),
				div(class="span1",helpPopup('Choose .fif','Select a FIF from the list to use in your Alfresco run.'))
			),
			uiOutput("goButton")
		)
	),
	wellPanel(
		checkboxInput("showWP2",h5("WP2"),TRUE),
		conditionalPanel(condition="input.showWP2",
			div(class="row-fluid",
				div(class="span11",uiOutput("fif_FireSensitivity")),
				div(class="span1",helpPopup('Fire Sensitivity','Set the fire sensitivity parameter in the FIF.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("fif_IgnitionFactor")),
				div(class="span1",helpPopup('Ignition Factor','Set the fire ignition factor parameter in the FIF.'))
			),
			div(class="row-fluid",
				div(class="span6",uiOutput("FRP_pts")),
				div(class="span6",uiOutput("FRP_buffers"))
			),
			div(class="row-fluid",
				div(class="span6",uiOutput("Update_fif_Defaults")),
				div(class="span6",uiOutput("SkipAlf"))#,
				#div(class="span1",helpPopup('Update .fif defaults','Check this box if you want to modify the FIF defaults file with your current parameter specifications when you submit your Alfresco run.
				#	If checked, next time the app is launched, it will populate the parameter fields with your previous specifications.'))
			),
			actionButton("goButton_fif","Save .fif / run Alfresco") #uiOutput("goButton_fif")
		)
	),
	h5(textOutput("pageviews"))
#)
)
