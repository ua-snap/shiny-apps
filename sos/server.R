rTheme <- function(pch = 19, cex = 0.7, region=colorRampPalette(c("navyblue", "gray90", "darkred"))(9), ...){
    theme <- custom.theme.2(pch = pch, cex = cex, region = region, ...)
    theme$strip.background$col <- theme$strip.shingle$col <- theme$strip.border$col <- "transparent"
    theme$panel.background$col <- "gray20"
    theme$add.line$lwd = 0.4
    theme$layout.heights=list(top.padding=1, bottom.padding=1, left.padding=-10, right.padding=-10)
    theme
}

shinyServer(function(input, output, session){

Clim_Threshold <- reactive({ switch(input$clim_threshold, "5%"="0.05", "10%"="0.1", "15%"="0.15", "20%"="0.2") })
SPstat <- reactive({ switch(input$spstat, "Mean"="Mean", "SD"="SD", "5th percentile"="5%", "95th percentile"="95%") })
Timestat <- reactive({ switch(input$timestat, "Mean"="mean", "SD"="SD", "5th percentile"="pct05", "95th percentile"="pct95") })
QMAP_Nonspatial_Region <- reactive({ if(is.null(input$region_agg) || input$region_agg[1]=="") regions else input$region_agg })
QMAP_Spatial_Region <- reactive({ if(is.null(input$region_map) || input$region_map=="") NULL else input$region_map })

QmapUseTS <- reactive({ input$plot_qmap_nonspatial_type=="Time series" })
QmapUseDen <- reactive({ input$plot_qmap_nonspatial_type=="Historical distributions" })
QmapUseRaw <- reactive({ input$plot_qmap_nonspatial_data=="Raw values" })
QmapUseDeltas <- reactive({ input$plot_qmap_nonspatial_data=="Historical deltas" })

QMAP_Nonsp_Plottype <- reactive({
    x <- NULL
    if(QmapUseTS()){
        if(QmapUseRaw()) x <- "ts_raw"
        if(QmapUseDeltas()) x <- "ts_deltas"
    } else if(QmapUseDen()) {
        if(QmapUseRaw()) x <- "den_raw"
        if(QmapUseDeltas()) x <- "den_deltas"
    }
    x
})

Data_qmap <- reactive({ filter(d.qmap, Scenario %in% c("Historical", input$rcp) & Model %in% c("NARR", input$gcm) & Region %in% QMAP_Nonspatial_Region() & Pct==Clim_Threshold() & Stat==SPstat()) })

PlotLabs_qmap <- reactive({
    stat <- input$spstat
    if(stat=="Mean") stat <- "mean"
    gcm <- input$gcm
    pct <- input$clim_threshold
    title.raw <- paste("original and quantile-mapped regional", stat, "DOY TDD", pct)
    title.deltas <- paste(gcm, "original and quantile-mapped regional", stat, "DOY TDD", pct, "deltas")
    if(QMAP_Nonsp_Plottype()=="ts_raw"){
        x <- labs(y="DOY TDD 10%", title=paste("NARR baseline and", gcm, input$rcp, title.raw))
    } else if(QMAP_Nonsp_Plottype()=="ts_deltas"){
        x <- labs(y=expression(DOY[GCM]-mean(DOY[NARR])), title=title.deltas)
    } else if(QMAP_Nonsp_Plottype()=="den_raw"){
        x <- labs(x=paste("DOY TDD", input$clim_threshold), title=paste("NARR baseline and historical", gcm, title.raw))
    } else if(QMAP_Nonsp_Plottype()=="den_deltas"){
        x <- labs(x=expression(DOY[GCM]-DOY[NARR[mean]]), title=title.deltas)
    } else x <- NULL
    x
})

# Plots: quantile mapping of GCMs
doPlot_qmapNonspatial <- function(){
    if(is.null(Data_qmap())) return()
    if(QMAP_Nonsp_Plottype()=="ts_raw"){
        g <- ggplot(Data_qmap(), aes(x=Year, y=`DOY TDD`, group=interaction(Model, Map), colour=Map)) +
            geom_line(data=Data_qmap() %>% filter(Model=="NARR"), size=1) + geom_line()
    }
    if(QMAP_Nonsp_Plottype()=="ts_deltas"){
        g <- ggplot(Data_qmap() %>% filter(Year %in% 1979:2010), aes(x=Year, y=`DOY TDD Deltas`, group=interaction(Model, Map), colour=Map)) +
            geom_line(data=Data_qmap() %>% filter(Model=="NARR"), size=1) + geom_line()
    }
    if(QMAP_Nonsp_Plottype()=="den_raw"){
        g <- ggplot(Data_qmap() %>% filter(Scenario=="Historical"), aes(x=`DOY TDD`, group=interaction(Pct, Map), colour=Map)) + geom_line(stat="density", size=1)
    }
    if(QMAP_Nonsp_Plottype()=="den_deltas"){
        g <- ggplot(Data_qmap() %>% filter(Scenario=="Historical"), aes(x=`DOY TDD Deltas`, group=interaction(Pct, Map), colour=Map)) + geom_line(stat="density", size=1)
    }
    g <- g + scale_colour_manual(values=clrs) + theme_gray(base_size=16) + theme(legend.position="bottom", legend.box="horizontal") + facet_wrap(~ Region, scales="free_y") + PlotLabs_qmap()
    print(g)
}

output$Plot_QMAP_Nonspatial <- renderPlot({ doPlot_qmapNonspatial() }, height=function(){ 0.7*session$clientData$output_Plot_QMAP_Nonspatial_width }, width="auto")

QMAP_nonspatial_plot_filename <- reactive({
    x <- paste0(QMAP_Nonsp_Plottype(), "_doytdd", gsub("%", "", input$clim_threshold), "_", input$gcm)
    if(QMAP_Nonsp_Plottype()=="ts_raw") x <- paste0(x, "_", gsub("[. ]", "", input$rcp))
    x <- paste0(x, ".pdf")
    x
})

output$dl_Plot_QMAP_Nonspatial <- downloadHandler(
	filename=QMAP_nonspatial_plot_filename(),
	content=function(file){	pdf(file=file, width=15, height=10.5, pointsize=6); doPlot_qmapNonspatial(); dev.off() }
)

# Maps: quantile mapping of GCMs
get_qmap_rasters <- function(rlist, msk, model, region, regions, stat, pct){
    if(is.null(region) || region=="") return()
    msk[msk!=match(region, regions)] <- NA
    stats <- c("mean", "SD", "pct05", "pct95")
    ind <- match(stat, stats)
    r1 <- subset(rlist[[model]]$diffx1x0[[pct]], ind)
    r2 <- subset(rlist[[model]]$diffx1mx0[[pct]], ind)
    r1[is.nan(r1)] <- NA
    r2[is.nan(r2)] <- NA
    s <- stack(r1, r2)
    s <- mask(s, msk)
    names(s) <- c("Original", "Mapped")
    trim(s)
}

QMAP_rasters <- reactive({ get_qmap_rasters(maplist, ecomask, input$gcm, QMAP_Spatial_Region(), regions, Timestat(), Clim_Threshold()) })

doPlot_qmapSpatial <- function(s, shp, model, region, stat, pct.lab, theme){
    if(is.null(s)) return()
    stat2 <- switch(stat, "mean"="mean", "SD"="SD", "pct05"="5th percentile", "pct95"="95th percentile")
    rng <- range(as.numeric(cellStats(s, range)))
    at.vals <- seq(-max(abs(rng)), max(abs(rng)), length=30)
    colkey <- list(at=at.vals, labels=list(labels=round(at.vals), at=at.vals), space="bottom")
    p <- levelplot(s, maxpixels=ncell(s), main=paste(region, "DOY TDD", pct.lab, "deltas for historical", model, "original and quantile-mapped", stat2),
        na.col="black", par.settings=theme, contour=T, margin=F, scales=list(draw=FALSE), at=at.vals, colorkey=colkey) + layer(sp.polygons(shp, col='gray70'), data=list(shp=shp))
    p
}

QMAP_mapheight <- reactive({
    x <- QMAP_rasters()
    asp <- nrow(x)/ncol(x)
    if(is.null(x)) 0 else if(asp > 1) 0.5*asp else 0.5*asp*(1+(1-asp)/2)
})

doPlot_qmapSpatial_wrapper <- function(){
    doPlot_qmapSpatial(QMAP_rasters(), eco_shp, input$gcm, QMAP_Spatial_Region(), Timestat(), input$clim_threshold, rTheme)
}

output$Plot_QMAP_Spatial <- renderPlot({ doPlot_qmapSpatial_wrapper() }, height=function(){ QMAP_mapheight()*session$clientData$output_Plot_QMAP_Spatial_width }, width="auto")

QMAP_spatial_plot_filename <- reactive({ # region doesn't update from NULL or empty string when using a "" default selection in UI selectInput
    paste0("map_deltas_doytdd", gsub("%", "", input$clim_threshold), "_", gsub(" ", "", QMAP_Spatial_Region()), "_historical_", Timestat(), "_", input$gcm, ".pdf")
})

output$dl_Plot_QMAP_Spatial <- downloadHandler(
	filename=QMAP_spatial_plot_filename(),
	content=function(file){	pdf(file=file, width=15, height=QMAP_mapheight()*15, pointsize=6); print(doPlot_qmapSpatial_wrapper()); dev.off() }
)

})
