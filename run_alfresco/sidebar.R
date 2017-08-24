# @knitr sidebar
column(6,
	tags$head(
		tags$link(rel="stylesheet", type="text/css", href="styles_black_lightblue.css")
	),
	conditionalPanel(condition="input.tsp!=='rcode'",
		wellPanel(
			fluidRow(
			  column(6, textInput("useremail","Email results to:", value="paul.duffy@neptuneinc.org")),
				column(6, selectInput("json_files", "JSON", all_json_files, "cruSW5m.JSON", width="100%"))
			),
			fluidRow(
			  column(3, uiOutput("RCP_opts")),
			  column(3, uiOutput("Model_opts")),
			  column(6, uiOutput("Year_opts"))
			),
			hr(style="border-color:#000000;"),
			fluidRow(
				column(4, numericInput("FireSensitivity", "Fire Sensitivity", value=default_Fire.Sensitivity, min=1, max=100000)),
				column(4, selectInput("FireSensFMO", "Sens. FMO", c("None", "15-km buffered"), width="100%")),
				column(4, sliderInput("FireSensFMOMax", "Max suppression", 0, 1, 0, 0.01, width="100%"))
				
			),
			fluidRow(
			  column(4, numericInput("IgnitionFactor", "Fire Ignition Factor", value=default_Fire.IgnitionFactor, min=0.00001, max=0.1)),
			  column(4, selectInput("IgnitFacFMO", "Ignit. FMO", c("None", "15-km buffered"), width="100%")),
			  column(4, sliderInput("IgnitFacFMOMax", "Max suppression", 0, 1, 0, 0.01, width="100%"))
			),
			hr(style="border-color:#000000;"),
			fluidRow(
				column(4, uiOutput("PointLocs")),
				column(4, textInput("frp_buffers", "Fire Return Period buffers", value="0,1,2,4,8")),
				column(4, selectInput("fire_cause", "Empirical fire sources", choices=c("Lightning", "All"), selected="Lightning", width="100%"))
			),
			fluidRow(
			  column(4, checkboxInput("include_fseByVeg", "FSE by vegetation", TRUE)),
			  column(4, checkboxInput("include_frp", "Include FRP", TRUE)),
			  column(4, checkboxInput("group_runs", "Check if grouping runs", TRUE))
			),
			hr(style="border-color:#000000;"),
			fluidRow(
			  column(4, numericInput("n_sims", "Number of Sims", value=32, min=32, max=192)),
			  column(4, uiOutput("GroupName")),
			  column(4, uiOutput("RunName"))
			),
			fluidRow(
			  column(4, numericInput("randseed", "Random Seed", value=1234799211)),
				column(4, checkboxInput("update_json_defaults", "Save Sen/Ign as new defaults", TRUE)),
				column(4, checkboxInput("skipAlf", "Skip Alfresco/Rerun R", FALSE))
			),
			fluidRow(
			  column(6, 
			    actionButton("msy_btn","Map years options", class="btn-block"),
			    bsTooltip("msy_btn", "Set starting years from each type of map output."),
			    bsModal("msy", "Additional plot settings", "msy_btn", size="large", uiOutput("msy_input_panel"))
			  ),
			  column(6, actionButton("goButton_JSON","Save .JSON / run Alfresco", class="btn-block"))
			)
		)
	)
)
