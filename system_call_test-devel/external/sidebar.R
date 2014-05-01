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
	conditionalPanel(condition="input.tsp!=='rcode'",
		wellPanel(
			checkboxInput("showWP1",h5("WP1"),TRUE),
			conditionalPanel(condition="input.showWP1",
				div(class="row-fluid",
					div(class="span6",uiOutput("UserEmail")),
					#div(class="span1",helpPopup('Enter your email address','Results from the Alfresco run will be emailed to you.')),
					div(class="span6",uiOutput("AddEmail"))#,
					#div(class="span1",helpPopup('Enter additional email addresses','Results from the Alfresco run will be emailed to each address. For the time being, you must separate each email address with a comma and/or space.'))
				),
				div(class="row-fluid",
					div(class="span12",uiOutput("FIF_Files"))#,
					#div(class="span1",helpPopup('Choose .fif','Select a FIF from the list to use in your Alfresco run.'))
				)#,
				#uiOutput("goButton")
			)
		),
		wellPanel(
			checkboxInput("showWP2",h5("WP2"),TRUE),
			conditionalPanel(condition="input.showWP2",
				div(class="row-fluid",
					div(class="span6",uiOutput("fif_FireSensitivity")),
					div(class="span6",uiOutput("fif_IgnitionFactor"))
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
		)
	),
	conditionalPanel(condition="input.tsp==='rcode'",
		navlistPanel(
			"Top-level Code",
			tabPanel("Global", value="nlp_globalR"),
			tabPanel("UI", value="nlp_uiR"),
			tabPanel("Server", value="nlp_serverR"),
			"Mid-level Code",
			tabPanel("App", value="nlp_appR"),
			#tabPanel("Header", value="nlp_headerR"), # cannot include "header" if it contains Google Analytics tracking code
			tabPanel("Sidebar", value="nlp_sidebarR"),
			tabPanel("Main", value="nlp_mainR"),
			tabPanel("About", value="nlp_aboutR"),
			"Bottom-level Code",
			tabPanel("Well Panel 1", value="nlp_io.sidebar.wp1R"),
			tabPanel("Well Panel 2", value="nlp_io.sidebar.wp2R"),
			tabPanel("Reactives", value="nlp_reactivesR"),
			id="nlp",
			widths=c(12,1)
		),
		div(class="row-fluid",
			div(class="span6", uiOutput("HLTheme")),
			div(class="span6", uiOutput("HLFontSize"))
		),
		uiOutput("CodeDescription")
	),
	conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
)
#)
