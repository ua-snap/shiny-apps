lapply(list("gbm", "tidyr", "grid", "gridExtra", "ggplot2", "rasterVis", "leaflet", "data.table", "dplyr"), function(x) library(x, character.only=T))

rTheme <- function(pch = 19, cex = 0.7, region=colorRampPalette(rev(c("darkred", "firebrick1", "white", "royalblue", "darkblue")))(19), ...){
    theme <- custom.theme.2(pch = pch, cex = cex, region = region, ...)
    theme$strip.background$col <- theme$strip.shingle$col <- theme$strip.border$col <- "transparent"
    theme$panel.background$col <- "gray20"
    theme$add.line$lwd = 0.4
    theme$layout.heights=list(top.padding=1, bottom.padding=1, left.padding=-10, right.padding=-10)
    theme
}

get_preds <- function(data, model, newdata, n.trees, type.err="test"){
    m <- model[[1]]
    grp <- as.character(groups(data))
    for(i in 1:length(grp)) newdata <- filter_(newdata, .dots=list(paste0(grp[i], "==\'", data[[grp]][1], "\'")))
    n.trees <- if(type.err=="test") n.trees[[1]]$Test else if(type.err=="cv") n.trees[[1]]$CV else stop("type.err must be 'test' or 'cv'.")
    predict(m, newdata=newdata, n.trees=n.trees)
}

get_swapped_gbm_preds <- function(model, data, regions){
    d <- filter(data, Region %in% regions)
    d2 <- copy(d)
    d.gbm1 <- filter(model, Region %in% regions) %>% group_by(Region)
    d.gbm2 <- copy(d.gbm1) %>% group_by %>% mutate(Region=rev(Region)) %>% group_by(Region)
    d.gbm1 <- do(d.gbm1, Pred=get_preds(., model=GBM1, newdata=d, n.trees=BI)) %>% group_by(Region)
    d.gbm2 <- do(d.gbm2, Pred=get_preds(., model=GBM1, newdata=d, n.trees=BI)) %>% group_by(Region)
    d$Pred <- unnest(d.gbm1)$Pred
    d2$Pred <- unnest(d.gbm2)$Pred
    d <- select(d, Region, Year, SOS, Pred) %>% setnames(c("Region", "Year", "Observed", "Predicted")) %>%
        melt(id.vars=c("Region", "Year"), value.name="SOS") %>% data.table %>% setnames(c("Region", "Year", "Source", "SOS")) %>%
        group_by(Region, Year, Source) %>% summarise(SOS=round(mean(SOS)))
    d2 <- select(d2, Region, Year, SOS, Pred) %>% setnames(c("Region", "Year", "Observed", "Swap GBMs")) %>%
        melt(id.vars=c("Region", "Year"), value.name="SOS") %>% data.table %>% setnames(c("Region", "Year", "Source", "SOS")) %>%
        group_by(Region, Year, Source) %>% summarise(SOS=round(mean(SOS)))
    d <- rbind(d, filter(d2, Source!="Observed")) %>% mutate(Region=factor(Region, levels=unique(Region)))
    d
}

shinyServer(function(input, output, session){

DataLoaded <- reactive({
    if(!exists("d.gbm1")){
        prog <- Progress$new(session, min=0, max=2)
        on.exit(prog$close())
        prog$set(message="Loading GBM modeling data...", value=1)
        load(paste0("appdata_gbm.RData"), envir=.GlobalEnv)
        prog$set(message="Loading thaw degree day data...", value=2)
        load(paste0("appdata_qmap.RData"), envir=.GlobalEnv)
    }
    return(TRUE)
})
observe(DataLoaded())

GBM_Plottype <- reactive({ if(is.null(input$gbm_plottype)) NULL else input$gbm_plottype })
GBM_Region <- reactive({ if(is.null(input$gbm_region)) NULL else input$gbm_region })

output$GBM_Region2_Choices <- renderUI({
    if(!is.null(GBM_Plottype()) && GBM_Plottype()=="Exchangeability"){
        x <- regions[regions!=GBM_Region()]
        selectInput("gbm_region2", "Second region", x, selected=x[1], width="100%")
    }
})

GBM_Region2 <- reactive({ if(is.null(input$gbm_region2)) NULL else input$gbm_region2 })

GBM_RI_AllRegions_ggObj <- reactive({
    d <- unnest(d.gbm1, RI) %>% data.table %>% filter(Method=="CV") %>% group_by(Region) %>%
        mutate(barorder=as.numeric(strsplit(paste(RI, collapse=","), ",")[[1]][1])) %>% mutate(Region=factor(Region, levels=unique(Region)[order(unique(barorder))]))
    d$Predictor <- factor(gsub("_", "\n", as.character(d$Predictor)), levels=gsub("_", "\n", as.character(levels(d$Predictor))))
    d$Region <- factor(gsub(" ", "\n", as.character(d$Region)), levels=gsub(" ", "\n", as.character(levels(d$Region))))
    g <- ggplot(d, aes(Region, RI, fill=Predictor)) + geom_bar(stat="identity", position="stack") +
        scale_fill_manual("", values=clrs[2:5]) + coord_flip() + ggtitle("All regions") +
        theme_gray(base_size=16) + theme(legend.position="bottom", legend.box="horizontal", strip.background=element_blank())
    g
})
observe(GBM_RI_AllRegions_ggObj())

# Plots: quantile mapping of GCMs
doPlot_gbm <- function(model, preds, data, regions, clrs, inplot=NULL){
    if(is.null(GBM_Plottype())) return()
    region <- regions[1]
    if(GBM_Plottype()=="Error curves"){ # GBM train, test, and cross=validation error curves
        b <- filter(model, Region==region)$BI[[1]]$CV
        m <- filter(model, Region==region)$GBM1[[1]]
        n <- m$n.trees
        d <- data.table(Trees=1:n, `Training Error`=m$train.error, `Test Error`=m$valid.error)
        d$`CV Error` <- m$cv.error
        be <- d$`CV Error`[b]
        d2 <- data.table(`Number of Trees`=b, Error=be)
        d <- melt(d,id="Trees")
        setnames(d, c("Number of Trees","Type of Error","Error"))
        g <- ggplot(d, aes(`Number of Trees`, Error, group=`Type of Error`, colour=`Type of Error`)) + geom_line(size=1) +
            scale_colour_manual("", values=clrs) + ggtitle(paste(region, "predictive error by GBM trees")) +
            geom_point(data=d2, aes(group=NULL, colour=NULL), size=2, colour="black") +
            geom_text(data=d2, aes(group=NULL, colour=NULL), label="Optimal\nCV trees", colour="black") +
            theme_gray(base_size=16) + theme(legend.position="bottom", legend.box="horizontal", strip.background=element_blank())
    }
    if(GBM_Plottype()=="Predictor strength"){ # Predictor relative influence
        d <- unnest(model, RI) %>% data.table %>% filter(Method=="CV") %>% group_by(Region) %>%
            mutate(barorder=as.numeric(strsplit(paste(RI, collapse=","), ",")[[1]][1])) %>% mutate(Region=factor(Region, levels=unique(Region)[order(unique(barorder))]))
        d$Predictor <- factor(gsub("_", "\n", as.character(d$Predictor)), levels=gsub("_", "\n", as.character(levels(d$Predictor))))
        g1 <- ggplot(filter(d, Region==region), aes(Predictor, RI)) + geom_bar(stat="identity") + ggtitle(region) +
            theme_gray(base_size=16) + theme(legend.position="bottom", legend.box="horizontal", strip.background=element_blank())
        if(is.null(inplot)){
            d$Region <- factor(gsub(" ", "\n", as.character(d$Region)), levels=gsub(" ", "\n", as.character(levels(d$Region))))
            g2 <- ggplot(d, aes(Region, RI, fill=Predictor)) + geom_bar(stat="identity", position="stack") +
                scale_fill_manual("", values=clrs) + coord_flip() + ggtitle("All regions") +
                theme_gray(base_size=16) + theme(legend.position="bottom", legend.box="horizontal", strip.background=element_blank())
        } else g2 <- inplot
        g <- grid.arrange(g1, g2, ncol=2, widths=c(0.8, 1.2), top=grid.text("Predictor relative influence on start of growing season", gp=gpar(fontsize=20)))
    }
    if(GBM_Plottype()=="Partial dependence"){ # Partial dependence of predictors
        g <- ggplot(filter(model, Region==region)$PD[[1]] %>% mutate(Ymin=min(Prob)), aes(x=Val)) + facet_wrap(~Var, switch="x", scales="free") +
            geom_ribbon(aes(ymin=Ymin, ymax=Prob), fill="orange") + geom_line(aes(x=x, y=y), size=1) +
            labs(title=paste("Partial dependence of", region, "start of season on predictors"), x="DOY TDD", y="Estimated SOS") +
            theme_gray(base_size=16) + theme(legend.position="bottom", legend.box="horizontal", strip.background=element_blank())
    }
    if(GBM_Plottype()=="GBM predictions"){ # Time series and scatter plot of observed and fitted values
        d <- filter(preds, Region==region)
        g1 <- ggplot(d, aes(x=Year, y=SOS, colour=Source)) + scale_colour_manual("", values=clrs) + geom_line(size=1) + geom_point() +
            ggtitle("Observed and modeled start of growing season") +
            scale_x_continuous(breaks=c(1982,1990,2000,2010)) + facet_wrap(~Region, switch="x", scales="free") +
            theme_gray(base_size=16) + theme(legend.position="bottom", legend.box="horizontal", strip.background=element_blank())
        d <- dcast(d, Region + Year ~ Source, value.var="SOS")
        setnames(d, c("Region", "Year", "Observed", "Predicted"))
        g2 <- ggplot(d, aes(x=Predicted, y=Observed)) + geom_point() + geom_smooth(method='lm',formula=y~x, colour="black") +
            ggtitle("Observed vs. fitted values") + facet_wrap(~Region, switch="x", scales="free") +
            theme_gray(base_size=16) + theme(legend.position="bottom", legend.box="horizontal", strip.background=element_blank())
        g <- grid.arrange(g1, g2, ncol=2)
    }
    if(GBM_Plottype()=="Exchangeability"){ # Time series and scatter plot of observed and fitted values using swapped GBM models
        if(is.null(GBM_Region2()) || GBM_Region2()=="") return()
        d <- get_swapped_gbm_preds(model, data, regions)
        f1 <- function(d){
            ggplot(d, aes(x=Year, y=SOS, colour=Source)) + scale_colour_manual("", values=clrs) + geom_line(size=1) + geom_point() +
                scale_x_continuous(breaks=c(1982,1990,2000,2010)) + facet_grid(~Region, switch="x") +
                theme_gray(base_size=16) + theme(legend.position="bottom", legend.box="horizontal", strip.background=element_blank())
        }
        g1a <- f1(filter(d, Region==regions[1]))
        g1b <- f1(filter(d, Region==regions[2]))
        d1 <- dcast(d %>% filter(Source!="Swap GBMs"), Region + Year ~ Source, value.var="SOS") %>% mutate(GBM="Original")
        d2 <- dcast(d %>% filter(Source!="Predicted"), Region + Year ~ Source, value.var="SOS") %>% mutate(GBM="Swapped")
        names(d2)[4] <- names(d1)[4] <- "Fitted"
        d <- rbind(d1, d2)
        f2 <- function(d){
            ggplot(d, aes(x=Fitted, y=Observed, colour=GBM)) + scale_colour_manual("", values=clrs[-1]) + geom_point() + geom_smooth(method='lm',formula=y~x) +
                scale_x_continuous(breaks=c(1982,1990,2000,2010)) + facet_grid(~Region, switch="x") +
                theme_gray(base_size=16) + theme(legend.position="bottom", legend.box="horizontal", strip.background=element_blank())
        }
        g2a <- f2(filter(d, Region==regions[1]))
        g2b <- f2(filter(d, Region==regions[2]))
        g1 <- grid.arrange(g1a, g2a, ncol=2, top=grid.text("Observed and modeled start of growing season when swapping regional GBM models", gp=gpar(fontsize=20)))
        g2 <- grid.arrange(g1b, g2b, ncol=2)
        g <- grid.arrange(g1, g2, ncol=1)
    }
    print(g)
}

GBM_plotheight <- reactive({
    if(is.null(GBM_Plottype())) return(0)
    x <- match(GBM_Plottype(), gbm_plot_types)
    switch(x, 0.7, 0.7, 0.7, 0.6, 1.2)
})

GBM_colors <- reactive({
    if(is.null(GBM_Plottype())) return(clrs)
    x <- match(GBM_Plottype(), gbm_plot_types)
    switch(x, clrs[c(1,5,4)], clrs[2:5], clrs, clrs[c(1,4)], clrs[c(1,4,5)])
})

doPlot_gbm_wrapper <- function() doPlot_gbm(d.gbm1, d.gbm.preds, d.gbm.data, c(GBM_Region(), GBM_Region2()), GBM_colors(), GBM_RI_AllRegions_ggObj())

output$Plot_GBM <- renderPlot({ doPlot_gbm_wrapper() }, height=function(){ GBM_plotheight()*session$clientData$output_Plot_GBM_width }, width="auto")

GBM_plot_filename <- reactive({ # input$gbm_plottype and GBM_Region2() don't update from with server-side UI selectInput
    #paste0("gbmResults_", gsub(" ", "", input$gbm_plottype), "_", gsub(" ", "", GBM_Region()), gsub(" ", "", GBM_Region2()), ".pdf")
    "current_gbm_results.pdf"
})

output$dl_Plot_GBM <- downloadHandler(
	filename=GBM_plot_filename(),
	content=function(file){	pdf(file=file, width=15, height=GBM_plotheight()*15, pointsize=6); print(doPlot_gbm_wrapper()); dev.off() }
)

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
QMAP_rasters <- reactive({
    get_qmap_rasters <- function(rlist, msk, model, region, regions, stat, pct){
        if(is.null(region) || region=="") return()
        msk[msk!=match(region, regions)] <- NA
        prog$inc(1)
        stats <- c("mean", "SD", "pct05", "pct95")
        ind <- match(stat, stats)
        r1 <- subset(rlist[[model]]$diffx1x0[[pct]], ind)
        r2 <- subset(rlist[[model]]$diffx1mx0[[pct]], ind)
        prog$inc(1)
        r1[is.nan(r1)] <- NA
        prog$inc(1)
        r2[is.nan(r2)] <- NA
        prog$inc(1)
        s <- stack(r1, r2)
        prog$inc(1)
        s <- mask(s, msk)
        prog$inc(1)
        names(s) <- c("Original", "Mapped")
        trim(s)
    }
    
    if(input$region_map!=""){
        prog <- Progress$new(session, min=0, max=7)
        on.exit(prog$close())
        prog$set(message="Compiling map data...", value=1)
        get_qmap_rasters(maplist, ecomask, input$gcm, QMAP_Spatial_Region(), regions, Timestat(), Clim_Threshold())
    } else NULL
})

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
