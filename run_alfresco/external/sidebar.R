#div(style="background-color:#000000; opacity:0.9;",
column(4,
	tags$head(
		tags$link(rel="stylesheet", type="text/css", href="styles_black_lightblue.css")
	),
	conditionalPanel(condition="input.tsp!=='rcode'",
		wellPanel(
			fluidRow(
				column(6, textInput("useremail","Your email:", value="paul.duffy@neptuneinc.org")),
				#column(1, helpPopup('Enter your email address','Results from the Alfresco run will be emailed to you.')),
				column(6, textInput("addemail","Also send results to:",value="mfleonawicz@alaska.edu"))#,
				#column(1, helpPopup('Enter additional email addresses','Results from the Alfresco run will be emailed to each address. For the time being, you must separate each email address with a comma and/or space.'))
			),
			fluidRow(
				column(6, selectInput("json_files", "Select JSON:", c("", JSON_files), "", width="100%")),
				column(6, selectInput("mapset", "Map set", c("3-GBM (unified CAVM)", "5-GBM (diversified CAVM)"), ""))#,
				#column(1, helpPopup('Choose .fif','Select a FIF from the list to use in your Alfresco run.'))
			),
			fluidRow(
				column(6, selectInput("climMod", "Climate model:", choices=c("CRU31", "CCSM4", "GFDL-CM3", "GISS-E2-R", "IPSL-CM5A-LR", "MRI-CGCM3"), selected="CRU31", width="100%")),
				column(6, selectInput("climPeriod", "Time Period/RCP:", choices=c("historical", "RCP 4.5", "RCP 6.0", "RCP 8.5"), selected="historical", width="100%"))
			),
			fluidRow(
				column(6, textInput("year_start", "Start year:", value="1")),
				column(6, textInput("year_end", "End year:", value="2013"))
				#column(1, helpPopup('Choose .fif','Select a FIF from the list to use in your Alfresco run.'))
			)
			#,
			#uiOutput("goButton")
		),
		wellPanel(
			fluidRow(
				column(6, numericInput("FireSensitivity", "Fire Sensitivity", value=default_Fire.Sensitivity, min=1, max=100000)),
				column(6, numericInput("IgnitionFactor", "Fire Ignition Factor", value=default_Fire.IgnitionFactor, min=0.00001, max=0.1))
			),
			fluidRow(
				column(6, selectInput("frp_pts", "Fire Return Period locations", c("", list.files("pts", pattern=".csv$")), width="100%")),
				column(6, textInput("frp_buffers", "Fire Return Period buffers", value="0,5,10,25,50,100"))
			),
			fluidRow(
				column(6, selectInput("fire_cause", "Empirical fire sources:", choices=c("Lightning", "All"), selected="Lightning", width="100%")),
				column(6, numericInput("randseed", "Random Seed", value=1234799211))
			),
			fluidRow(
				column(6, checkboxInput("update_json_defaults", "Save Sen/Ign as new defaults", TRUE)),
				column(6, checkboxInput("skipAlf", "Skip Alfresco/Rerun R", FALSE))#,
				#column(1, helpPopup('Update .fif defaults','Check this box if you want to modify the FIF defaults file with your current parameter specifications when you submit your Alfresco run.
				#	If checked, next time the app is launched, it will populate the parameter fields with your previous specifications.'))
			),
			fluidRow(
				column(6, checkboxInput("group_runs", "Check if grouping runs", TRUE))#,
				#column(6, textInput("group_name", "Group name for multiple runs:", value="myRuns"))
			),
			fluidRow(
				column(6, textInput("group_name", "Group name for multiple runs:", value="myRuns")),
				column(6, textInput("run_name", "Unique run name:", value="run1"))
			),
			actionButton("goButton_JSON","Save .JSON / run Alfresco", class="btn-block") #uiOutput("goButton_fif")
		)
	),
	conditionalPanel(condition="input.tsp==='rcode'",
	#	navlistPanel(
	#		"Top-level Code",
	#		tabPanel("Global", value="nlp_globalR"),
	#		tabPanel("UI", value="nlp_uiR"),
	#		tabPanel("Server", value="nlp_serverR"),
	#		"Mid-level Code",
	#		tabPanel("App", value="nlp_appR"),
	#		tabPanel("Header", value="nlp_headerR"), # cannot include "header" if it contains Google Analytics tracking code
	#		tabPanel("Sidebar", value="nlp_sidebarR"),
	#		tabPanel("Main", value="nlp_mainR"),
	#		tabPanel("About", value="nlp_aboutR"),
	#		"Bottom-level Code",
	#		tabPanel("Well Panel 1", value="nlp_iosidebarwp1R"),
	#		tabPanel("Well Panel 2", value="nlp_iosidebarwp2R"),
	#		tabPanel("Reactives", value="nlp_reactivesR"),
	#		id="nlp",
	#		widths=c(12,1)
	#	),
	#	fluidRow(
	#		column(6,  selectInput("hltheme", "Code highlighting theme:", getAceThemes(), selected="clouds_midnight", width="100%")),
	#		column(6,  selectInput("hlfontsize", "Font size:", seq(8,24,by=2), selected=12, width="100%"))
	#	),
		uiOutput("CodeDescription")
	)#,
	#conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
)
#) 
