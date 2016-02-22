library(shiny)
library(dplyr)
library(leaflet)

setwd("/var/www/shiny-server/shiny-apps/idocs/ex_leaflet") # Eris server
load("nwt_locations.RData")

lon <- -119.25
lat <- 69.333

# @knitr ui01
ui <- bootstrapPage(
  tags$style(type="text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("Map", width="100%", height="100%"),
  absolutePanel(top=10, right=10,
    checkboxInput("show_communities", "Show communities", TRUE), # NEW LINE
    conditionalPanel("input.show_communities == true", # nested condition
      selectInput("location", "Community", c("", locs$loc), selected=""),
      conditionalPanel("input.location !== null && input.location !== ''",
        actionButton("button_plot_and_table", "View Plot/Table", class="btn-block"))
    )
  )
)

# @knitr server01
server <- function(input, output, session) {
  acm_defaults <- function(map, x, y) addCircleMarkers(map, x, y, radius=6, color="black", fillColor="orange", fillOpacity=1, opacity=1, weight=2, stroke=TRUE, layerId="Selected")

  output$Map <- renderLeaflet({
    leaflet() %>% setView(lon, lat, 4) %>% addTiles() %>%
      addCircleMarkers(data=locs, radius=6, color= ~"black", stroke=FALSE, fillOpacity=0.5, group="locations", layerId = ~loc)
  })

# @knitr server01observer
observe({ # show or hide location markers
  proxy <- leafletProxy("Map")
  if (input$show_communities) {
    proxy %>% showGroup("locations")
  } else {
    updateSelectInput(session, "location", selected="")
    proxy %>% hideGroup("locations") %>% removeMarker(layerId="Selected")
  }
})


# @knitr server01remainder
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
