# @knitr ui
tabPanelAbout <- source("external/about.R",local=T)$value

shinyUI(fluidPage(
	#theme=shinytheme("cosmo"),
	#tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),
	theme="cyborg_bootstrap.css",
	tags$head(tags$link(rel="stylesheet", type="text/css", href="mystyles.css")),
	navbarPage(
		title=div(a(img(src="./img/SNAP_acronym_100px.png", width="80%"), "", href="http://snap.uaf.edu", target="_blank")),
		tabPanel("Home", includeMarkdown("www/home.md"), value="home"),
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
				tabPanel("Graphing: Variability", includeMarkdown("www/help05_04_graphVar.md")),
				tabPanel("Graphing: Spatial Distributions", includeMarkdown("www/help05_05_graphSpatial.md"))
			#)
		),
		tabPanelAbout(),
		windowTitle="AKCAN AR4/AR5",
		collapsible=TRUE,
		#inverse=TRUE,
		id="tsp"
	),
	fluidRow(
		source("external/sidebar.R",local=T)$value,
		source("external/main.R",local=T)$value
	)
))
