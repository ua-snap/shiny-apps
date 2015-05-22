shinyUI(navbarPage(theme=shinytheme("cosmo"),
	title=HTML('<div><a href="http://snap.uaf.edu" target="_blank"><img src="./img/SNAP_acronym_100px.png" width="80%"></a></div>'),
	tabPanel("Community Charts", value="commChart"),
	tabPanel("About", value="about"),
	windowTitle="CC4L",
	collapsible=TRUE,
	id="tsp",
	tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),
	conditionalPanel("input.tsp=='commChart'",
	fluidRow(
		column(4, h2("Community Charts v4 Lite"), h3("Explore the climate outlook for your community")),
		column(8,
			fluidRow(
				column(6, selectInput("location", "Community", c("", locs), selected="", multiple=F, width="100%")),
				column(6, selectInput("dec", "Decades", dec.lab, selected=dec.lab[c(1,4,6,9)], multiple=TRUE, width="100%"))
			),
			fluidRow(
				column(4, selectInput("variable", "Climate Variable", c("Temperature", "Precipitation"), selected="Temperature", multiple=F, width="100%")),
				column(4, selectInput("units", "Units", c("C, mm", "F, in"), selected="C, mm", multiple=F, width="100%")),
				column(4, selectInput("rcp", "RCP", c("4.5 (low)", "6.0 (medium)", "8.5 (high)"), selected="6.0 (medium)", multiple=F, width="100%"))
			)
		)
	),
	bsTooltip("location", "Enter a community. The menu will filter as you type. You may also select a community using the map.", "top", options = list(container="body")),
	bsTooltip("dec", "Select decades for projected climate. A 30-year historical baseline is automatically included in the plot.", "top", options = list(container="body")),
	bsTooltip("rcp", "Representative Concentration Pathways, covering a range of possible future climates based on atmospheric greenhouse gas concentrations.", "top", options = list(container="body")),
	fluidRow(
	column(4, leafletOutput("Map")),
	column(8,
		showOutput("Chart1", "highcharts"),
		HTML('<style>.rChart {width: 100%; height: "auto"}</style>')
	)
	),
	br(),
	fluidRow(
		column(2, actionButton("help_loc_btn", "About communities", class="btn-block"), br()),
		column(2, actionButton("help_rcp_btn", "About RCPs", class="btn-block")),
		column(8, h5(HTML(paste(caption, '<a href="http://snap.uaf.edu" target="_blank">snap.uaf.edu</a>'))))
	),
	bsModal("modal_loc", "Alaska and western Canada communities", "help_loc_btn", size="large",
		HTML('
		<p style="text-align:justify">There about about 4,000 communities in the app.
		Communities are not truly point data, e.g., weather station data.
		Rather, they are based on SNAP\'s downscaled climate data sets and a "community" refers to the <em>grid cell</em> which contains a community\'s coordinates.
		Communities are included from Alaska as well as the Canadian provinces Alberta, British Columbia, Manitoba, Saskatchewan, and Yukon and Northwest territories.</p>
		
		<p style="text-align:justify">Downscaled climate is on a 2-km by 2-km grid for all but the Northwest Territories, which is restricted to a 10-minute by 10-minute resolution.
		It is especially in the latter case that the data in this app cannot be thought of as community-level data.
		There are other minor annoyances with the data such as some communities not having the most precise coordinates.
		However, this is a negligible source of error compared to the uncertainty in future climate and is further smoothed out by the decadal time scale to which the data are averaged.</p>
		
		<p style="text-align:justify">All communities make use of a 30-year historical baseline (1960-1989) using SNAP\'s downscaled CRU data.
		While there is a range of decadal averages based on multiple climate models for a given future decade,
		there is also a range depicted for the 30-year baseline window to highlight inter-annual variability during the historical period.</p>
		
		<p style="text-align:justify">Both the source CRU data and climate models are downscaled to higher resolution climatologies (either 2-km PRISM or 10-minute CRU climatologies), which are based on historical weather station observations.
		When viewing a plot for a given community, both the historical baseline and the future decadal modeled projections come from downscaled data at a common resolution.
		The distinction to make note of is that NWT communities are derived from much coarser data since the NWT region falls outside the 2-km PRISM extent, leaving the 10-minute scale data as the only option.
		More information can be found in the documentation related to this app. See the <code>About</code> tab at the top of the page for links.</p>
		
		<p style="text-align:justify">In the map, the relative size and particularly the color (blue, purple, and red),
		are there to assist with spotting larger landmark cities by eye if using the map.
		Purple represents moderately sized cities and red is reserved for the few large cities. Any location with a population under 50,000 remains blue.</p>'
	)),
	
	bsModal("modal_rcp", "Representative Concentration Pathways", "help_rcp_btn", size="large",
		HTML('
		<p style="text-align:justify">Together the RCPs show a range of possible future atmospheric greenhouse gas concentrations driven by human activity.
		The RCP values represent radiative forcing (W/m^2) in 2100 relative to pre-industrial levels.
		For example, greenhouse gas concentrations in 2100 which lead to the net solar energy absorbed by each square meter of Earth 
		averaging 4.5 W/m^2 greater than pre-industrial levels is referred to as RCP 4.5.</p>
		
		<p style="text-align:justify">RCP 4.5 (low). This pathway assumes that emissions peak around 2040, and that radiative forcing is stabilized shortly after 2100. SNAP terms this the "low" scenario.
		RCP 6.0 (medium). The "medium" RCP assumes technologies and strategies for reducing greenhouse gas emissions are developed,
		allowing emissions to peak around 2080, then decline, with total radiative forcing stabilized shortly after 2100.
		RCP 8.5 (high). The "high" RCP is characterized by increasing greenhouse gas emissions continuing through the 21st century.
		RCP 2.6 assumes greenhouse gas emissions peak between 2010 and 2020 and decline substantially thereafter. It is unrealistic so it is not included.</p>
		More information on these RCPs can be found in the 2014 IPCC fifth Assessment Report.'
	))
	),
	conditionalPanel("input.tsp=='about'", source("about.R",local=T)$value)
))
