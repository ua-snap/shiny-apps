tabPanelAbout <- source("external/about.R",local=T)$value
headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}

#library(leaflet)
#library(ShinyDash)

shinyUI(fluidPage(
	#source("external/header.R",local=T)$value,
	
	#tags$head(HTML(
	#	'<script>
	#	(function(i,s,o,g,r,a,m){i[\'GoogleAnalyticsObject\']=r;i[r]=i[r]||function(){
	#	(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	#	m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	#	})(window,document,\'script\',\'//www.google-analytics.com/analytics.js\',\'ga\');
	#	ga(\'create\', \'UA-46129458-2\', \'rstudio.com\');
	#	ga(\'send\', \'pageview\');
	#	
	#	$(document).ready(function() { 
	#		$("#mystyles li a").click(function() { 
	#			$("link[rel=\'stylesheet\']").attr("href",$(this).attr("rel"));
	#			return false;
	#		});
	#	});
	#	</script>'
	#)),
	#tags$head(HTML(
	#	'<ul id="mystyles">
	#		<li><a href="#" rel="http://bootswatch.com/2/cosmo/bootstrap.css">Light Theme</a></li>
	#		<li><a href="#" rel="http://bootswatch.com/2/cyborg/bootstrap.css">Dark Theme</a></li>
	#	</ul>'
	#)),
	
	########################################## leaflet testing
	#leafletMap(
	#"map", "100%", 200,
	#initialTileLayer = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
	#initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>'),
	#options=list(
	#  center = c(57.45, -120),
	#  zoom = 4,
	#  maxBounds = list(list(-90, -180), list(90, 180))
	#)
	#),
	#fluidRow(
	#  column(8, offset=3,
	#    h5('Population of US cities'),
	#    htmlWidgetOutput(
	#      outputId = 'desc',
	#      HTML(paste(
	#        'The map is centered at <span id="lat"></span>, <span id="lng"></span>',
	#        'with a zoom level of <span id="zoom"></span>.<br/>',
	#        'Top <span id="shownCities"></span> out of <span id="totalCities"></span> visible cities are displayed.'
	#      ))
	#    )
	#  )
	#),
	#hr(),
	
	progressInit(),
	navbarPage(
		title=div(a(img(src="./img/SNAP_acronym_100px.png", width="50%"), "", href="http://snap.uaf.edu", target="_blank")),
		tabPanel("Home", h4("Alaska and western Canada downscaled CMIP3/CMIP5 GCM comparison"), value="home"),
		tabPanel("Time Series", value="plot_ts"),
		tabPanel("Scatter Plot", value="plot_scatter"),
		tabPanel("Heat Map", value="plot_heatmap"),
		tabPanel("Variability", value="plot_variability"),
		tabPanel("Spatial Distributions", value="plot_spatial"),
		navbarMenu("Help", 
			tabPanel("Getting Started", includeMarkdown("www/help01_start.md")),
			tabPanel("Working With Data", includeMarkdown("www/help02_data.md")),
			tabPanel("Graphical Options", includeMarkdown("www/help03_plotOptions.md")),
			tabPanel("Updating Settings", includeMarkdown("www/help04_updating.md")),
			#navbarMenu("Graphing", # Nested navbarMenu not functional in Shiny at this time
				tabPanel("Graphing: Time Series", includeMarkdown("www/help05_01_graphTS.md")),
				tabPanel("Graphing: Scatter Plots", includeMarkdown("www/help05_02_graphScatter.md")),
				tabPanel("Graphing: Heat Maps", includeMarkdown("www/help05_03_graphHeat.md")),
				tabPanel("Graphing: Variability", includeMarkdown("www/help05_04_graphVar.md"))
			#)
		),
		tabPanelAbout(),
		windowTitle="AKCAN CMIP3/CMIP5",
		collapsable=TRUE,
		#inverse=TRUE,
		id="tsp"
	),
    ##fluidRow(column(3,
    ##  #selectInput('year', 'Year', c(2000:2010), 2010),
    ##  selectInput('maxCities', 'Maximum cities to display', choices=c(
    ##    1, 5, 25, 50, 100, 200, 500, 2000, 5000, 10000, All = 100000
    ##  ), selected = 1)
    #),
    #column(4,
    #  h5('Visible cities'),
    #  tableOutput('citydata')
	##)),
	################################################################
	#tags$head(tags$link(rel="stylesheet", type="text/css", href="http://bootswatch.com/2/cyborg/bootstrap.css")),
	tags$head(tags$link(rel="stylesheet", type="text/css", href="http://bootswatch.com/2/cosmo/bootstrap.css")),
	tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),
	fluidRow(
		source("external/sidebar.R",local=T)$value,
		source("external/main.R",local=T)$value
	)
))
