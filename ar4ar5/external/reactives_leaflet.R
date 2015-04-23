makeReactiveBinding('selectedCity')

# Define some reactives for accessing the data

# The cities that are within the visible bounds of the map
citiesInBounds <- reactive({
if (is.null(input$map_bounds)) return(cities.meta[FALSE,])
	bounds <- input$map_bounds
	latRng <- range(bounds$north, bounds$south)
	lngRng <- range(bounds$east, bounds$west)
	subset(cities.meta, Lat >= latRng[1] & Lat <= latRng[2] & Lon >= lngRng[1] & Lon <= lngRng[2])
})

# The top N cities (by population) that are within the visible bounds
# of the map
topCitiesInBounds <- reactive({
	cities <- citiesInBounds()
	cities <- head(cities[order(cities[["Population"]], decreasing=TRUE),], as.numeric(input$maxCities))
})
