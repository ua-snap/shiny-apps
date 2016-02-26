shpPolyInput <- function(id, label, btn){
  ns <- NS(id)
  tagList(
    bsModal(ns("modal_shp"), "Mask climate map overlays to a shapefile", btn, size="large",
      fluidRow(
        column(12,
          fileInput(ns("shp_file"), label=label, accept=c(".shp",".dbf",".sbn",".sbx",".shx",".prj"), multiple=TRUE, width="100%")
        )
      ),
      tabsetPanel(
        tabPanel("Original shapefile", plotOutput(ns("Shp_Plot"), height="auto"), value="original"),
        tabPanel("Final overlay", leafletOutput(ns("Map")), value="final"),
        tabPanel("Summary", verbatimTextOutput(ns("Map_Summary")), value="final_summary"),
        tabPanel("Data", dataTableOutput(ns("Map_Table")), value="final_table"),
        id=ns("tp_shp")
      ),
      br(),
      uiOutput(ns("Mask_Btn")),
      uiOutput(ns("Mask_Complete"))
    )
  )
}

shpPoly <- function(input, output, session, r=NULL){
  ns <- session$ns
  userFile <- reactive({
    validate(need(input$shp_file, message=FALSE))
    input$shp_file
  })
  tp <- reactive({
    validate(need(input$tp_shp, message=FALSE))
    input$tp_shp
  })

  shp <- reactive({
    req(input$shp_file)
    if(!is.data.frame(userFile())) return()
    infiles <- userFile()$datapath
    dir <- unique(dirname(infiles))
    outfiles <- file.path(dir, userFile()$name)
    purrr::walk2(infiles, outfiles, ~file.rename(.x, .y))
    x <- try(readOGR(dir, strsplit(userFile()$name[1], "\\.")[[1]][1]), TRUE)
    if(class(x)=="try-error") NULL else x
  })

  valid_proj <- reactive({ req(shp()); if(is.na(proj4string(shp()))) FALSE else TRUE })

  shp_wgs84 <- reactive({
    req(shp(), valid_proj())
    if(valid_proj()) spTransform(shp(), CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")) else NULL
  })

  valid_domain <- reactive({
    req(shp_wgs84())
    if(is.null(r)) return(TRUE)
    if(!is.null(raster::intersect(extent(r), extent(shp_wgs84())))){
      r.masked <- try(crop(r, shp_wgs84()) %>% mask(shp_wgs84()), TRUE)
      if(!(class(r.masked)=="try-error") && length(which(!is.na(r.masked[]))) > 2) return(TRUE)
    }
    FALSE
  })

  lon <- reactive({ if(valid_proj()) (xmin(shp_wgs84()) + xmax(shp_wgs84()))/2 else 0 })
  lat <- reactive({ if(valid_proj()) (ymin(shp_wgs84()) + ymax(shp_wgs84()))/2 else 0 })
  plot_ht <- reactive({ if(is.null(shp())) 0 else 400 })
  eb <- element_blank()
  theme_blank <- theme(axis.line=eb, axis.text.x=eb, axis.text.y=eb, axis.ticks=eb, axis.title.x=eb, axis.title.y=eb,
    legend.position="none", panel.background=eb, panel.border=eb, panel.grid.major=eb, panel.grid.minor=eb, plot.background=eb)

  output$Shp_Plot <- renderPlot({
    if(!is.null(shp())){
      ggplot(fortify(shp()), aes(x=long, y=lat, group=group)) +
        geom_polygon(fill="steelblue4") + geom_path(colour="black") + coord_equal() + theme_blank
    }
  }, height=function() plot_ht())
  output$Map <- renderLeaflet({ leaflet() %>% setView(0, 0, zoom=2) %>% addTiles() })
  output$Map_Summary <- renderPrint({ req(shp_wgs84()); summary(shp_wgs84()) })
  output$Map_Table <- renderDataTable({ shp_wgs84()@data }, options=list(orderClasses=TRUE, lengthMenu=c(5, 10, 25, 50), pageLength=5), rownames=F, selection="none", filter="none")
  output$Mask_Btn <- renderUI({
    #if(!is.null(input$mask_btn) && input$mask_btn==1) return()
    if(valid_domain()) actionButton(ns("mask_btn"), "Mask to Shapefile", class="btn-block") else NULL
  })

  output$Mask_Complete <- renderUI({
    if(!length(input$shp_file)) return(h4("No shapefile uploaded."))
    if(is.null(shp())) return(HTML("<h4>Invalid file(s).</h4><h5>Upload all six required shapefile components:</h5><p><em>.shp, .dbf, .sbn, .sbx, .shx and .prj</em></p>"))
    if(!valid_proj()) return(h4("Shapefile is missing projection."))
    if(!valid_domain()) return(h4("Shapefile does not overlap map data."))
    if(!is.null(input$mask_btn) && input$mask_btn==0) return(h4("Shapefile loaded. Click to apply mask."))
    if(!is.null(out())) return(h4("Mask complete. You may close this window."))
    #if(!is.null(input$mask_btn) && input$mask_btn > 0)
  })

  observe({
    if(!is.null(shp()) && tp()=="final"){
      leafletProxy(ns("Map")) %>% clearShapes() %>% setView(lon(), lat(), zoom=2) %>% addPolygons(data=shp_wgs84(), weight=2)
    }
  })

  out <- reactive({
    if(is.null(input$mask_btn) || input$mask_btn==0 || !valid_domain()) NULL else list(shp=shp_wgs84(), shp_original=shp())
  })
  out
}
