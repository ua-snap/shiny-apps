library(shiny)
library(shinyBS)
library(raster)
library(data.table)
library(dplyr)
library(leaflet)
library(ggplot2)

load("nwt_testing_subset.RData")
load("nwt_locations.RData")

decades <- seq(2010, 2090, by=10)
lon <- -119.25
lat <- 69.333
d <- d.cru$Locs[[2]] %>% filter(Month=="Jun")

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
  ),
  bsModal("Plot_and_table", "Plot and Table", "button_plot_and_table", size = "large",
    plotOutput("TestPlot"),
    dataTableOutput("TestTable")
  )
)

# @knitr server03
server <- function(input, output, session) {

  ras <- reactive({ subset(x, which(decades==input$dec)) })
  ras_vals <- reactive({ values(ras()) })
  pal <- reactive({ colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), ras_vals(), na.color="transparent") })

  output$Map <- renderLeaflet({
    leaflet() %>% setView(lon, lat, 4) %>% addTiles() %>%
      addCircleMarkers(data=locs, radius = ~10, color= ~"#000000", stroke=FALSE, fillOpacity=0.5, group="locations", layerId = ~loc)
  })

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
      proxy %>% setView(lng=p$lng, lat=p$lat, input$Map_zoom) %>% addCircleMarkers(p$lng, p$lat, radius=10, color="black", fillColor="orange", fillOpacity=1, opacity=1, stroke=TRUE, layerId="Selected")
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
      proxy %>% setView(lng=p2$lon, lat=p2$lat, input$Map_zoom) %>% addCircleMarkers(p2$lon, p2$lat, radius=10, color="black", fillColor="orange", fillOpacity=1, opacity=1, stroke=TRUE, layerId="Selected")
    } else if(!length(p$id)){
      proxy %>% setView(lng=p2$lon, lat=p2$lat, input$Map_zoom) %>% addCircleMarkers(p2$lon, p2$lat, radius=10, color="black", fillColor="orange", fillOpacity=1, opacity=1, stroke=TRUE, layerId="Selected")
    }
  })

# @knitr server03pointdata
Data <- reactive({ d %>% filter(Location==input$location) })

output$TestPlot <- renderPlot({ ggplot(Data(), aes(value, Year)) + geom_line() + geom_smooth() })

output$TestTable <- renderDataTable({
  Data()
}, options = list(pageLength=5))
# @knitr server03remainder
}

shinyApp(ui, server)
