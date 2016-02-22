library(shiny)
library(rgdal)
library(raster)
library(dplyr)
library(leaflet)

load("nwt_testing_subset.RData")
load("nwt_locations.RData")

decades <- seq(2010, 2090, by=10)
lon <- -119.25
lat <- 69.333

# @knitr ui02
ui <- bootstrapPage(
  tags$style(type="text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("Map", width="100%", height="100%"),
  absolutePanel(top=10, right=10,
    sliderInput("dec", "Decade", min=min(decades), max=max(decades), value=decades[1], step=10, sep="", post="s"), # NEW LINE
    checkboxInput("show_communities", "Show communities", TRUE),
    checkboxInput("legend", "Show legend", TRUE), # NEW LINE
    conditionalPanel("input.show_communities == true",
      selectInput("location", "Community", c("", locs$loc), selected=""),
      conditionalPanel("input.location !== null && input.location !== ''",
        actionButton("button_plot_and_table", "View Plot/Table", class="btn-block"))
    )
  )
)

# @knitr server02
server <- function(input, output, session) {
  acm_defaults <- function(map, x, y) addCircleMarkers(map, x, y, radius=6, color="black", fillColor="orange", fillOpacity=1, opacity=1, weight=2, stroke=TRUE, layerId="Selected")
# @knitr server02obj
ras <- reactive({ subset(x, which(decades==input$dec)) })
ras_vals <- reactive({ values(ras()) })
pal <- reactive({ colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), ras_vals(), na.color="transparent") })

# @knitr server02remainder1
  output$Map <- renderLeaflet({
    leaflet() %>% setView(lon, lat, 4) %>% addTiles() %>%
      addCircleMarkers(data=locs, radius=6, color="black", stroke=FALSE, fillOpacity=0.5, group="locations", layerId = ~loc)
  })

# @knitr server02obs
observe({
  proxy <- leafletProxy("Map")
  proxy %>% removeTiles(layerId="rasimg") %>% addRasterImage(ras(), colors=pal(), opacity=0.8, layerId="rasimg")
})

observe({
  proxy <- leafletProxy("Map")
  proxy %>% clearControls()
  if (input$legend) {
    proxy %>% addLegend(position="bottomright", pal=pal(), values=ras_vals(), title="Precipitation (mm)")
  }
})

# @knitr server02remainder2
  observe({ # show or hide location markers
    proxy <- leafletProxy("Map")
    if (input$show_communities) {
      proxy %>% showGroup("locations")
    } else {
      updateSelectInput(session, "location", selected="")
      proxy %>% hideGroup("locations") %>% removeMarker(layerId="Selected")
    }
  })

  observeEvent(input$Map_marker_click, { # update the map markers and view on map clicks
    p <- input$Map_marker_click
    proxy <- leafletProxy("Map")
    if(p$id=="Selected"){
      proxy %>% removeMarker(layerId="Selected")
    } else {
      proxy %>% setView(lng=p$lng, lat=p$lat, input$Map_zoom) %>% acm_defaults(p$lng, p$lat)
    }
  })

  observeEvent(input$Map_marker_click, { # update the location selectInput on map clicks
    p <- input$Map_marker_click
    if(!is.null(p$id)){
      if(is.null(input$location) || input$location!=p$id) updateSelectInput(session, "location", selected=p$id)
    }
  })

  observeEvent(input$location, { # update the map markers and view on location selectInput changes
    p <- input$Map_marker_click
    p2 <- subset(locs, loc==input$location)
    proxy <- leafletProxy("Map")
    if(nrow(p2)==0){
      proxy %>% removeMarker(layerId="Selected")
    } else if(length(p$id) && input$location!=p$id){
      proxy %>% setView(lng=p2$lon, lat=p2$lat, input$Map_zoom) %>% acm_defaults(p2$lon, p2$lat)
    } else if(!length(p$id)){
      proxy %>% setView(lng=p2$lon, lat=p2$lat, input$Map_zoom) %>% acm_defaults(p2$lon, p2$lat)
    }
  })

}

shinyApp(ui, server)
