shinyUI(navbarPage(
	title=HTML('<div><a href="http://snap.uaf.edu" target="_blank"><img src="./img/SNAP_acronym_100px.png" width="80%"></a></div>'),
	tabPanel("Home", value="home"),
    tabPanel("GBM modeling", value="gbm"),
	tabPanel("Quantile mapping", value="qmap"),
    tabPanel("SOS predictions", value="qmap"),
    #tabPanel("About", value="about"),
	windowTitle="Alaska Growing Season",
	collapsible=TRUE,
	id="tsp",
  tags$head(includeScript("ga-gs.js"), includeScript("ga-allapps.js")),
	tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),
	conditionalPanel("input.tsp=='home'",
	fluidRow(
		column(4, h3("Modeling Alaska growing season start dates"),
            HTML(
            '<p style="text-align:justify">This app highlights analysis of historical and projected trends in Alaska growing season onset.
            Generalized boosted regression/gradient boosting machine (GBM) models are used to estimate start of season (SOS) as a function of surface air temperature.</p>

            <p style="text-align:justify">This is done using a derived proxy variable for temperature: the day of year on which cumulative thaw degree days for the year reaches a given percentile of climatological mean total thaw degree days (DOY TDD).
            Threshold percentiles considered are 5, 10, 15 and 20 percent.</p>

            <p style="text-align:justify">GBM models for SOS as a function of the four DOY TDD percentile variables are fitted separately for each of nine Alaska ecological regions.
            The GBM models use spatially explicit data. Results shown here are aggregated back to the ecoregion scale.</p>

            <p style="text-align:justify">In order to make projections of SOS based on DOY TDD with the GBM models,
            future daily temperature model outputs from global climate models (GCMs) are first quantile mapped to the 1979-2010 NARR-based DOY TDD data.</p>

            <p style="text-align:justify">Quantile mapping provides a robust method for bias and variance correction,
            mapping multiple properties of the GCM-based DOY TDD percentile variables\' distributions to correspond with those based on the NARR baseline data.
            This maps GCM data into the functional space of the GBM models built on NARR data,
            permitting more direct and meaningful comparison of NARR and GCM DOY TDD data in the context of estimating future growing season start dates.</p>'),

            HTML('
            <div style="clear: left;"><img src="http://www.gravatar.com/avatar/52c27b8719a7543b4b343775183122ea.png" alt="" style="float: left; margin-right:5px" /></div>
            <p>Matthew Leonawicz<br/>
            Statistician | useR<br/>
            <a href="http://leonawicz.github.io" target="_blank">Github.io</a> |
            <a href="http://blog.snap.uaf.edu" target="_blank">Blog</a> |
            <a href="https://twitter.com/leonawicz" target="_blank">Twitter</a> |
            <a href="http://www.linkedin.com/in/leonawicz" target="_blank">Linkedin</a> <br/>
            <a href="http://www.snap.uaf.edu/", target="_blank">Scenarios Network for Alaska & Arctic Planning</a>
            </p>')
        ),
		column(8,
			fluidRow(
				includeMarkdown("www/home.md")
			)
		)
	)
    ),
    conditionalPanel("input.tsp=='gbm'",
	    fluidRow(
        column(4,
            wellPanel(
                fluidRow(column(6, h4("GBM modeling")), column(6, actionButton("help_gbm_btn", "Details", class="btn-block")))
            ),
            wellPanel(
                fluidRow(column(6, h4("Graphs")), column(6, downloadButton("dl_Plot_GBM", "Get Plot", class="btn-default btn-block"))),
                selectInput("gbm_plottype", "Analysis figures", gbm_plot_types, gbm_plot_types[1], width="100%"),
                selectInput("gbm_region", "Region", regions, selected=regions[1], width="100%"),
                uiOutput("GBM_Region2_Choices")
            )
        ),
        column(8,
            plotOutput("Plot_GBM", width="100%", height="auto")
        )
    )
    ),
    conditionalPanel("input.tsp=='qmap'",
    fluidRow(
        column(4,
            wellPanel(
                fluidRow(column(6, h4("Data")), column(6, actionButton("help_qmap_btn", "Details", class="btn-block"))),
                fluidRow(
                    column(4, selectInput("clim_threshold", "Threshold", c("5%", "10%", "15%", "20%"), selected="5%", width="100%")),
                    column(4, selectInput("rcp", "Scenario", c("RCP 6.0", "RCP 8.5"), selected="Time series", width="100%")),
                    column(4, selectInput("gcm", "Model", c("GFDL-CM3", "IPSL-CM5A-LR", "MRI-CGCM3"), selected="GFDL-CM3", width="100%"))
                )
            ),
            wellPanel(
                fluidRow(column(6, h4("Graphs")), column(6, downloadButton("dl_Plot_QMAP_Nonspatial", "Get Plot", class="btn-default btn-block"))),
                selectInput("region_agg", "Region(s)", regions, selected="", multiple=TRUE, width="100%"),
                fluidRow(
                    column(6, selectInput("plot_qmap_nonspatial_type", "Plot type", c("Time series", "Historical distributions"), selected="Time series", multiple=F, width="100%")),
                    column(6, selectInput("plot_qmap_nonspatial_data", "Plot data as", c("Raw values", "Historical deltas"), selected="Raw values", multiple=F, width="100%"))
                ),
                fluidRow(
                    column(6, selectInput("spstat", "Spatial stat", c("Mean", "SD", "5th percentile", "95th percentile"), selected="Mean", width="100%"))
                )
            ),
            wellPanel(
                fluidRow(column(6, h4("Maps")), column(6, downloadButton("dl_Plot_QMAP_Spatial", "Get Plot", class="btn-default btn-block"))),
                fluidRow(
                    column(6, selectInput("region_map", "Region", c("", regions), selected="", width="100%")),
                    column(6, selectInput("timestat", "Temporal stat", c("Mean", "SD", "5th percentile", "95th percentile"), selected="Mean", width="100%"))
                )
            )
        ),
        column(8,
            plotOutput("Plot_QMAP_Nonspatial", width="100%", height="auto")
        )
    ),
    plotOutput("Plot_QMAP_Spatial", width="100%", height="auto"), br()
    ),
	#bsTooltip("location", "Enter a community. The menu will filter as you type. You may also select a community using the map.", "top", options = list(container="body")),
	#bsTooltip("dec", "Select decades for projected climate. A 30-year historical baseline is automatically included in the plot.", "top", options = list(container="body")),
	#bsTooltip("rcp", "Representative Concentration Pathways, covering a range of possible future climates based on atmospheric greenhouse gas concentrations.", "top", options = list(container="body")),
	#fluidRow(
	#column(4, leafletOutput("Map")),
	#column(8,
	#	showOutput("Chart1", "highcharts"),
	#	HTML('<style>.rChart {width: 100%; height: "auto"}</style>')
	#)
	#),
	#br(),
	#fluidRow(
	#	column(2, actionButton("help_loc_btn", "About communities", class="btn-block"), br()),
	#	column(2, actionButton("help_rcp_btn", "About RCPs", class="btn-block")),
	#	column(8, h5(HTML(paste(caption, '<a href="http://snap.uaf.edu" target="_blank">snap.uaf.edu</a>'))))
	#),
	bsModal("modal_gbm", "Generalized boosted regression models...", "help_gbm_btn", size="large",
		HTML('
		<p style="text-align:justify">This is a description...</p>'
	)),

	bsModal("modal_qmap", "Quantile mapping GCM data to NARR baseline", "help_qmap_btn", size="large",
		HTML('
		<p style="text-align:justify">This is a description...</p>'
	))#,
	#conditionalPanel("input.tsp=='about'", source("about.R",local=T)$value)
))
