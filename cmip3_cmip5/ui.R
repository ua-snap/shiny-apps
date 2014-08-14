tabPanelAbout <- source("external/about.R",local=T)$value
headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}

library(leaflet)
library(ShinyDash)

shinyUI(fluidPage(
	source("external/header.R",local=T)$value,
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
  fluidRow(
    column(3,
      #selectInput('year', 'Year', c(2000:2010), 2010),
      selectInput('maxCities', 'Maximum cities to display', choices=c(
        1, 5, 25, 50, 100, 200, 500, 2000, 5000, 10000, All = 100000
      ), selected = 1)
    #),
    #column(4,
    #  h5('Visible cities'),
    #  tableOutput('citydata')
    )
	),
	################################################################
	fluidRow(
		source("external/sidebar.R",local=T)$value,
		source("external/main.R",local=T)$value
	)
))
