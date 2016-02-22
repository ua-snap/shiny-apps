acm_defaults <- function(map, x, y) addCircleMarkers(map, x, y, radius=6, color="black", fillColor="orange", fillOpacity=1, opacity=1, weight=2, stroke=TRUE, layerId="Selected")

shinyServer(function(input, output, session) {

  # setup
  Monthly <- reactive({ input$toy %in% month.abb })
  Mos <- reactive({ if(Monthly()) input$toy else month.abb[sea.idx[[input$toy]]] })
  mon_index <- reactive({ match(Mos(), month.abb) })

  Variable <- reactive({ vars[var.labels==input$variable] })

  RCPs <- reactive({ rcps[rcp.labels==input$rcp] })

  sea_func <- reactive({ if(Variable()=="pr") sum else mean })

  stat_func <- reactive({
    p <- input$mod_or_stat
    if(p %in% models) return()
    switch(p, Mean=mean,  Min=function(x,...) min(x,...), Max=function(x,...) max(x,...),
      Spread=function(x,...) range(x,...))
  })

  CRU_ras <- reactive({
    idx <- match(input$toy, names(cru6190[[Variable()]]))
    subset(cru6190[[Variable()]], idx)
  })

  # prepping GCM/CRU, raw/deltas, months/seasons, models/stats, temp/precip
  ras <- reactive({
    dec.idx <- which(decades==input$dec)
    mon.idx <- switch(input$toy, Winter=c(1,2,12), Spring=3:5, Summer=6:8, Fall=9:11)
    p <- input$mod_or_stat

    mung_models <- function(x, monthly, mo, dec, mo2, f_sea){
      if(monthly){
        x[[mo]] %>% subset(dec)
      } else {
        calc(brick(lapply(x[mo2], function(x, idx) subset(x, idx), idx=dec)), f_sea) %>% round(1)
      }
    }

    mung_stats <- function(x, monthly, mo, dec, mo2, f_sea, f_stat, statid){
      if(!monthly) mo <- mo2
      x <- x %>% do(., Maps=.$Maps[[1]][mo] %>% purrr::map(~subset(.x, dec)) %>% brick %>% calc(f_sea))
      x <- f_stat(brick(x$Maps))
      if(statid=="Spread") x <- calc(x, function(x) x[2]-x[1])
      round(x, 1)
    }

    if(!(p %in% models)){
      x <- filter(d, Var==Variable() & RCP==RCPs()) %>% group_by(Model, add=T) %>%
        mung_stats(Monthly(), mon_index(), dec.idx, mon.idx, sea_func(), stat_func(), p)
      return(x)
    }

    if(p %in% models){
      x <- filter(d, Var==Variable() & RCP==RCPs() & Model==p)$Maps[[1]]
      x <- mung_models(x, Monthly(), mon_index(), dec.idx, mon.idx, sea_func())
      if(input$deltas & Variable()=="pr"){
        x <- round(x / CRU_ras(), 2)
        x[is.infinite(x)] <- NA
      }
      if(input$deltas & Variable()=="tas") x <- x - CRU_ras()
    }

    x[is.nan(x)] <- NA
    x
  })

  # store raster values once, separate from raster object
  ras_vals <- reactive({ values(ras()) })

  # Colors and color palettes
  Colors <- reactive({
    req(input$colpal)
    pal <- input$colpal
    custom.colors <- c(input$col_low, input$col_med, input$col_high)
    if(pal %in% sq) custom.colors <- custom.colors[c(1,3)]
    if(pal %in% c("Custom div", "Custom seq")) custom.colors else pal
  })

  pal <- reactive({
    colorNumeric(Colors(), ras_vals(), na.color="transparent")
  })

  # Map legend title, also used for spatial summary density plot
  Legend_Title <- reactive({
    p <- input$variable=="Precipitation"
    d <- input$deltas
    if(p & d) "Precip. deltas" else if(p) "Precipitation (mm)" else if(!p & d) "Temp. deltas (C)" else "Temperature (C)"
  })

  # Initialize map
  output$Map <- renderLeaflet({
    leaflet() %>% setView(lon, lat, 4) %>% addTiles() %>%
      addCircleMarkers(data=locs, radius=6, color="black", stroke=FALSE, fillOpacity=0.5, group="locations", layerId = ~loc)
  })

  #### Map-related observers ####
  observe({ # raster layers
    proxy <- leafletProxy("Map")
    proxy %>% removeTiles(layerId="rasimg") %>% addRasterImage(ras(), colors=pal(), opacity=0.8, layerId="rasimg")
  })

  observe({ # legend
    proxy <- leafletProxy("Map")
    proxy %>% clearControls()
    if (input$legend) {
      proxy %>% addLegend(position="bottomright", pal=pal(), values=ras_vals(), title=Legend_Title())
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
  #### END Map-related observers ####

  # Location data
  Loc_Var <- reactive({ vars[var.labels==input$loc_variable] })

  Loc_RCPs <- reactive({ rcps[rcp.labels==input$loc_rcp] })

  Data <- reactive({
    x <- select(d, Var, RCP, Model, Locs) %>% group_by(RCP, Model, Var) %>%
      filter(Var==Loc_Var() & RCP==Loc_RCPs()) %>%
      arrange(Var, RCP, Model) %>%
      do(Locs=filter(.$Locs[[1]], Location==input$location)) %>% unnest

    x <- group_by(d.cru, Var) %>% do(Locs=filter(.$Locs[[1]], Location==input$location)) %>% unnest %>%
      filter(Var==Loc_Var()) %>% mutate(RCP="historical", Model="CRU 3.2") %>% bind_rows(x) %>%
      select(Location, Var, RCP, Model, Year, Month, value) %>%
      mutate(Model=factor(Model, levels=unique(Model))) %>%
      group_by(Location, Var, RCP, Model, Month)
    x
  })

  Data_sub <- reactive({ # subset data
    p <- input$loc_toy
    monthly <- p %in% month.abb
    mos <- if(monthly) p else month.abb[sea.idx[[input$loc_toy]]]
    x <- Data() %>% filter(Month %in% mos)
    if(monthly){
      x <- group_by(x)
    } else {
      f_sea <- if(Loc_Var()=="pr") sum else mean
      rnd <- ifelse(Loc_Var()=="pr", 0, 1)
      if(p=="Winter"){
        x <- mutate(x, PrevYear=c(NA, value[1:(length(value)-1)])) %>%
          mutate(value=ifelse(Month=="Dec", PrevYear, value))
      }
      x <- mutate(x, Season=factor(season.labels.long[match(Month, month.abb)], levels=season.labels)) %>%
        group_by(Location, Var, RCP, Model, Year, Season) %>% summarise(value=f_sea(value)) %>% group_by %>%
        mutate(value=round(value, rnd))
    }
    x
  })

  Data_sub2 <- reactive({ # transform to deltas and/or remove CRU 3.2 if required
    x <- Data_sub()
    cru.mean <- (filter(x, Model=="CRU 3.2" & Year %in% 1961:1990) %>% summarise(Mean=mean(value)))$Mean
    if(input$loc_deltas){
      x <- group_by(x, Model)
      if(Loc_Var()=="pr"){
         x <- mutate(x, value=round(value / cru.mean, 2))
        #x[is.infinite(x)] <- NA
      } else {
        x <- mutate(x, value=round(value - cru.mean, 2))
      }
    }
    if(!input$loc_cru) x <- filter(x, Model!="CRU 3.2")
    x
  })

  loc_data_filename <- reactive({ # input$gbm_plottype and GBM_Region2() don't update from with server-side UI selectInput
    #paste0("gbmResults_", gsub(" ", "", input$gbm_plottype), "_", gsub(" ", "", GBM_Region()), gsub(" ", "", GBM_Region2()), ".pdf")
    "current_plot_data.csv"
  })

  # Outputs for location modal
  output$dl_loc_data <- downloadHandler(
    filename=loc_data_filename(),
    content=function(file){	write.csv(Data_sub2(), file, quote=FALSE, row.names=FALSE) }
  )

  do_tsplot <- reactive({
    req(input$modal_loc)
    if(!input$modal_loc) return()
    d <- Data_sub2()
    d2 <- filter(d, Model!="CRU 3.2")
    p <- Loc_Var()=="pr"
    del <- input$loc_deltas
    clrs <- c("darkgray", "cornflowerblue", "orange", "purple", "dodgerblue4", "firebrick")
    if(!input$loc_cru){
      clrs <- clrs[-1]
      d <- d2
    }
    ylb <- if(p & del) "Precipitation deltas" else if(p) "Precipitation (mm)" else if(!p & del) "Temperature deltas (C)" else "Temperature (C)"
    g <- ggplot(d, aes(Year, value, colour=Model)) + scale_color_manual("", values=clrs) + labs(y=ylb) +
      theme_gray(base_size=16) + theme1
    if(input$loc_stat=="All GCMs") g <- g + geom_line()
    if(input$loc_stat=="Both"){
      g <- g + geom_line() + stat_summary(data=d2, aes(colour=NULL), fun.y=mean, geom="line", colour="black", size=1)
    } else if(input$loc_stat=="Mean GCM"){
      if(input$loc_cru) g <- g + geom_line(data=filter(d, Model=="CRU 3.2"))
      g <- g + stat_summary(data=d2, aes(colour=NULL), fun.y=mean, geom="line", colour="black", size=1)
    }
    if(input$loc_trend) g <- g + geom_smooth(aes(colour=NULL), colour="black", size=1)
    g
  })

  output$TS_Plot <- renderPlot({ do_tsplot() })

  tsplot_filename <- reactive({ # input$gbm_plottype and GBM_Region2() don't update from with server-side UI selectInput
    #paste0("gbmResults_", gsub(" ", "", input$gbm_plottype), "_", gsub(" ", "", GBM_Region()), gsub(" ", "", GBM_Region2()), ".pdf")
    "current_plot.pdf"
  })

  tsplot_h <- reactive({ session$clientData$output_TS_Plot_height })
  tsplot_w <- reactive({ session$clientData$output_TS_Plot_width })

  output$dl_tsplot <- downloadHandler(
    filename=tsplot_filename(),
    content=function(file){	pdf(file=file, width=15, height=15*tsplot_h()/tsplot_w(), pointsize=6); print(do_tsplot()); dev.off() }
  )

  # Spatial distribution density plot
  output$sp_density_plot <- renderPlot({
    x <- ras_vals()
    x <- data.table(`Spatial Distribution`=x[!is.na(x)])
    ggplot(x, aes(`Spatial Distribution`)) + geom_density(fill="#33333350") + theme1 + labs(x=Legend_Title())
  }, width=300, height=300, bg="transparent")

  observe({ # no deltas allowed when comparing across models
    if(!(input$mod_or_stat %in% models)){
      updateCheckboxInput(session, "deltas", value=FALSE)
    }
  })

  # tooltips
  observe({
    if(length(input$ttips) && input$ttips){
      addTooltip(session, "dec", "Maps show decadal averages of projected climate.", "left", options=list(container="body"))
      addTooltip(session, "toy", "3-month seasons or specific months. Winter is Dec-Feb and so on.", "left", options=list(container="body"))
      addTooltip(session, "rcp", "Representative Concentration Pathways, covering a range of possible future climates based on atmospheric greenhouse gas concentrations.", "left", options=list(container="body"))
      addTooltip(session, "mod_or_stat", "Individual climate models or a statistic combining all five.", "left", options=list(container="body"))
      addTooltip(session, "location", "Enter a community. Menu filters as you type. Or select a community on map.", "left", options=list(container="body"))
      addTooltip(session, "deltas", "Display projected change from 1961-1990 baseline average instead of raw climate values.", "right", options=list(container="body"))
    } else {
      removeTooltip(session, "dec")
      removeTooltip(session, "toy")
      removeTooltip(session, "rcp")
      removeTooltip(session, "mod_or_stat")
      removeTooltip(session, "location")
      removeTooltip(session, "deltas")
    }
  })

})
