# @knitr sidebar
column(6,
	tags$head(
		tags$link(rel="stylesheet", type="text/css", href="styles_black_lightblue.css")
	),
	conditionalPanel(condition="input.tsp!=='rcode'",
		wellPanel(
			fluidRow(
				column(6, textInput("useremail","Your email:", value="paul.duffy@neptuneinc.org")),
				column(6, textInput("addemail","Also send results to:",value="mfleonawicz@alaska.edu"))#,
			),
			fluidRow(
				column(6, selectInput("json_files", "Select JSON:", c("", JSON_files), width="100%")),
				column(6, selectInput("mapset", "Map set", 
				                      c("3m trunc + Lcoef", "3m trunc + Lmap", "5m trunc + Lcoef", "5m trunc + Lmap")))
			),
			fluidRow(
				column(6, selectInput("climMod", "Climate model:", 
				                      choices=c("CRU32", "CCSM4", "GFDL-CM3", "GISS-E2-R", "IPSL-CM5A-LR", "MRI-CGCM3"), 
				                      selected="CRU32", width="100%")),
				column(6, selectInput("climPeriod", "Time Period/RCP:", 
				                      choices=c("historical", "RCP 4.5", "RCP 6.0", "RCP 8.5"), selected="historical", width="100%"))
			),
			fluidRow(
				column(6, textInput("year_start", "Start year:", value="1")),
				column(6, textInput("year_end", "End year:", value="2013"))
			)
		),
		wellPanel(
			fluidRow(
				column(4, numericInput("FireSensitivity", "Fire Sensitivity", value=default_Fire.Sensitivity, min=1, max=100000)),
				column(4, selectInput("FireSensFMO", "Sens. FMO", c("None", "15-km buffered"), width="100%")),
				column(4, sliderInput("FireSensFMOMax", "Max suppression", 0, 1, 0, 0.01, width="100%"))
				
			),
			fluidRow(
			  column(4, numericInput("IgnitionFactor", "Fire Ignition Factor", value=default_Fire.IgnitionFactor, min=0.00001, max=0.1)),
			  column(4, selectInput("IgnitFacFMO", "Ignit. FMO", c("None", "Refuges"), width="100%")),
			  column(4, sliderInput("IgnitFacFMOMax", "Max suppression", 0, 1, 0, 0.01, width="100%"))
			),
			fluidRow(
				column(4, selectInput("frp_pts", "Fire Return Period locations", c("", list.files("pts", pattern=".csv$")), width="100%")),
				column(4, textInput("frp_buffers", "Fire Return Period buffers", value="0,1,2,4,8")),
				column(4, selectInput("fire_cause", "Empirical fire sources:", choices=c("Lightning", "All"), selected="Lightning", width="100%"))
			),
			fluidRow(
			  column(4, checkboxInput("include_fseByVeg", "FSE by vegetation", TRUE)),
			  column(4, checkboxInput("include_frp", "Include FRP", TRUE)),
			  column(4, checkboxInput("group_runs", "Check if grouping runs", TRUE))
			),
			fluidRow(
			  column(4, numericInput("n_sims", "Number of Sims", value=32, min=32, max=192)),
			  column(4, textInput("group_name", "Group name for multiple runs:", value="myRuns")),
			  column(4, textInput("run_name", "Unique run name:", value="run1"))
			),
			fluidRow(
			  column(4, numericInput("randseed", "Random Seed", value=1234799211)),
				column(4, checkboxInput("update_json_defaults", "Save Sen/Ign as new defaults", TRUE)),
				column(4, checkboxInput("skipAlf", "Skip Alfresco/Rerun R", FALSE))
			),
			actionButton("goButton_JSON","Save .JSON / run Alfresco", class="btn-block")
		)
	)
)
