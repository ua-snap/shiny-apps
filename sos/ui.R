shinyUI(navbarPage(theme=shinytheme("cosmo"),
	title=HTML('<div><a href="http://snap.uaf.edu" target="_blank"><img src="./img/SNAP_acronym_100px.png" width="80%"></a></div>'),
	tabPanel("Home", value="home"),
    tabPanel("EDA & modeling", value="gbm"),
	tabPanel("Quantile mapping", value="qmap"),
    tabPanel("About", value="about"),
	windowTitle="SOS",
	collapsible=TRUE,
	id="tsp",
	tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),
	conditionalPanel("input.tsp=='home'",
	fluidRow(
		column(4, h2("Start of growing season in Alaska"), h3("Explore and model historical and projected growing season start dates")),
		column(8,
			fluidRow(
				#column(6, selectInput("location", "Community", c("", locs), selected="", multiple=F, width="100%")),
				#column(6, selectInput("dec", "Decades", dec.lab, selected=dec.lab[c(1,4,6,9)], multiple=TRUE, width="100%"))
			),
			fluidRow(
				#column(4, selectInput("variable", "Climate Variable", c("Temperature", "Precipitation"), selected="Temperature", multiple=F, width="100%")),
				#column(4, selectInput("units", "Units", c("C, mm", "F, in"), selected="C, mm", multiple=F, width="100%")),
				#column(4, selectInput("rcp", "RCP", c("4.5 (low)", "6.0 (medium)", "8.5 (high)"), selected="6.0 (medium)", multiple=F, width="100%"))
			)
		)
	)
    ),
    conditionalPanel("input.tsp=='gbm'",
	fluidRow(
		column(4, h2("Start of growing season in Alaska"), h3("Explore and model historical and projected growing season start dates")),
		column(8,
			fluidRow(
				#column(6, selectInput("location", "Community", c("", locs), selected="", multiple=F, width="100%")),
				#column(6, selectInput("dec", "Decades", dec.lab, selected=dec.lab[c(1,4,6,9)], multiple=TRUE, width="100%"))
			),
			fluidRow(
				#column(4, selectInput("variable", "Climate Variable", c("Temperature", "Precipitation"), selected="Temperature", multiple=F, width="100%")),
				#column(4, selectInput("units", "Units", c("C, mm", "F, in"), selected="C, mm", multiple=F, width="100%")),
				#column(4, selectInput("rcp", "RCP", c("4.5 (low)", "6.0 (medium)", "8.5 (high)"), selected="6.0 (medium)", multiple=F, width="100%"))
			)
		)
	)
    ),
    conditionalPanel("input.tsp=='qmap'",
	fluidRow(
		column(4, h2("Start of growing season in Alaska"), h3("Explore and model historical and projected growing season start dates")),
		column(8,
			fluidRow(
				#column(6, selectInput("location", "Community", c("", locs), selected="", multiple=F, width="100%")),
				#column(6, selectInput("dec", "Decades", dec.lab, selected=dec.lab[c(1,4,6,9)], multiple=TRUE, width="100%"))
			),
			fluidRow(
				#column(4, selectInput("variable", "Climate Variable", c("Temperature", "Precipitation"), selected="Temperature", multiple=F, width="100%")),
				#column(4, selectInput("units", "Units", c("C, mm", "F, in"), selected="C, mm", multiple=F, width="100%")),
				#column(4, selectInput("rcp", "RCP", c("4.5 (low)", "6.0 (medium)", "8.5 (high)"), selected="6.0 (medium)", multiple=F, width="100%"))
			)
		)
	),
    fluidRow(
        column(4,
            wellPanel(h4("Data"),
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
	#bsModal("modal_loc", "Alaska and western Canada communities", "help_loc_btn", size="large",
	#	HTML('
	#	<p style="text-align:justify">There about about 4,000 communities in the app.</p>'
	#)),
	
	#bsModal("modal_rcp", "Representative Concentration Pathways", "help_rcp_btn", size="large",
	#	HTML('
	#	<p style="text-align:justify">Together the RCPs...'
	#))
	#),
	conditionalPanel("input.tsp=='about'", source("about.R",local=T)$value)
))
