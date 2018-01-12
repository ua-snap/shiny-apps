# @knitr sidebar
column(6,
	tags$head(
		tags$link(rel="stylesheet", type="text/css", href="styles_black_lightblue.css")
	),
	conditionalPanel(condition="input.tsp!=='info'",
		wellPanel(
			fluidRow(
			  column(6,
			    textInput("useremail","Email results to:", value="paul.duffy@neptuneinc.org"),
			    bsTooltip("useremail", "Results will be emailed when the job is finished, including a url to a new Shiny app for an interactive look at the model outputs.")
			   ),
				column(6,
				  selectInput("json_files", "JSON", all_json_files, "cruSW5m.JSON", width="100%"),
				  bsTooltip("json_files", "ALFRESCO parameters from the selected file can be viewed on the next tab. They are updated in real time as input settings below are changed. Various input fields update and populate with defaults based on the naming convention of the input file. The current file is sent to the Atlas cluster when ALFRESCO is launched.", 
				            placement="right", options=list(container="body"))
				)
			),
			fluidRow(
			  column(3, uiOutput("RCP_opts")),
			  column(3, uiOutput("Model_opts")),
			  column(3, uiOutput("Year_opts1")),
			  column(3, uiOutput("Year_opts2"))
			),
			hr(style="border-color:#000000;"),
			fluidRow(
				column(4, numericInput("FireSensitivity", "Fire Sensitivity", value=default_Fire.Sensitivity, min=1, max=100000)),
				column(4, selectInput("FireSensFMO", "Sens. FMO", c("None", "Standard", "15-km buffered"), width="100%")),
				column(4, sliderInput("FireSensFMOMax", "Max suppression", 0, 1, 0, 0.01, width="100%"))
				
			),
			fluidRow(
			  column(4, numericInput("IgnitionFactor", "Fire Ignition Factor", value=default_Fire.IgnitionFactor, min=0.00001, max=0.1)),
			  column(4, selectInput("IgnitFacFMO", "Ignit. FMO", c("None", "Standard", "15-km buffered"), width="100%")),
			  column(4, sliderInput("IgnitFacFMOMax", "Max suppression", 0, 1, 0, 0.01, width="100%"))
			),
			hr(style="border-color:#000000;"),
			fluidRow(
				column(4, uiOutput("PointLocs")),
				column(4, textInput("frp_buffers", "Fire Return Period buffers", value="5")),
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
				column(4, checkboxInput("update_json_defaults", "Save Sen/Ign as new defaults", FALSE)),
				column(4, checkboxInput("skipAlf", "Skip Alfresco/Rerun R", FALSE))
			),
			fluidRow(
			  column(4, 
			    actionButton("msy_btn","Output map options", class="btn-block"),
			    bsTooltip("msy_btn", "Select output map types and starting years.", placement="top"),
			    bsModal("msy", "Output map options", "msy_btn", size="large", uiOutput("msy_input_panel"))
			  ),
			  column(4, 
			    actionButton("secrun_btn","Secondary run options", class="btn-block"),
			    bsTooltip("secrun_btn", "Setup a secondary run that starts from final-year outputs of an existing run.", placement="top"),
			    bsModal("secrun", "Secondary runs", "secrun_btn", size="large", 
            fluidRow(
              column(6,
                checkboxInput("secrun_use", "Run is secondary", FALSE),
                bsTooltip("secrun_use", "If checked, this run is assumed to follow an existing run whose final-year map outputs have been prepared on the Atlas cluster for use as first-year inputs to this run. Ensure the start year for this run is set appropriately. Prior year outputs from the previous run are assumed available as inputs.")
              ),
              column(6,
                textInput("prev_run_name", "Previous run name", value=default_prev_run_name),
                bsTooltip("secrun_use", "Edit the default previous run name if necessary.")
              )
            )
			    )
			  ),
			  column(4,
			    actionButton("goButton_JSON", "Run Alfresco", class="btn-block"),
			    bsTooltip("goButton_JSON", "ALFRESCO will launch on the Atlas cluster only if running this app from the Eris server. Please wait a moment for the call to complete. When successful, a printout of the command line call to sbatch on Atlas will apear to the right.", placement="top")
			  )
			),
			style="background-color: rgba(255, 255, 255, 0.9);")
	)
)
