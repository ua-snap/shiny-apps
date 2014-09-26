# Source reactive expressions and other code
source("external/reactives.R",local=T) # source reactive expressions
#source("external/reactives_leaflet.R",local=T) # source reactive expressions for leaflet
source("external/io_sidebar.R",local=T) # source input/output objects associated with sidebar
source("external/io_mainPanel.R",local=T) # source input/output objects associated with mainPanel

tsPlot <- source("external/plot_ts.R",local=T)$value
scatterPlot <- source("external/plot_scatter.R",local=T)$value
varPlot <- source("external/plot_variability.R",local=T)$value
heatPlot <- source("external/plot_heatmap.R",local=T)$value

# Specific plot function setup
doPlot_ts <- function(...){
	if(permitPlot() & !is.null(input$group)){
		if(!(input$group!="None" & !length(input$colorpalettes))){
			tsPlot(d=dat(), x=input$xtime, y="Val", d.grp=datCollapseGroups(), d.pool=datCollapsePooled(), grp=input$group, n.grp=n.groups(), ingroup.subjects=subjectChoices(),
				panels=facet.panels(), facet.by=input$facet, vert.facet=input$vert.facet,
				fontsize=input$plotFontSize, colpal=input$colorpalettes, colseq=input$colorseq, mos=Months(),
				linePlot=input$linePlot, barPlot=input$barPlot, pts.alpha=input$alpha1, bartype=input$bartype, bardirection=input$bardirection,
				show.points=input$showpts, show.lines=input$showlines, show.overlay=input$showCRU, overlay=CRU(), jit=input$jitterXY,
				plot.title=plot_ts_title(), plot.subtitle=plot_ts_subtitle(), show.panel.text=input$showPanelText, show.title=input$showTitle, lgd.pos=input$legendPos1,
				units=currentUnits(), yrange=input$yrange, clbootbar=input$clbootbar, clbootsmooth=input$clbootsmooth,
				pooled.var=pooled.var(), plot.theme.dark=input$plotThemeDark, logo.mat=logo.mat, ...)
		} else NULL
	} else NULL
}

doPlot_scatter <- function(...){
	if(permitPlot() & !is.null(input$group2)){
		if(!(input$group2!="None" & !length(input$colorpalettes2))){
			scatterPlot(d=dat2(), form.string=input$xy, grp=input$group2, n.grp=n.groups2(),
				panels=facet.panels2(), facet.by=input$facet2, vert.facet=input$vert.facet2,
				fontsize=input$plotFontSize2, colpal=input$colorpalettes2, colseq=input$colorseq2, mos=Months(),
				show.points=input$showpts, contourlines=input$showlines, hexbin=input$hexbin, pts.alpha=input$alpha2, show.overlay=input$showCRU, overlay=CRU2(), jit=input$jitterXY,
				plot.title=plot_sp_title(), plot.subtitle=plot_sp_subtitle(), show.panel.text=input$showPanelText, show.title=input$showTitle,
				lgd.pos=input$legendPos2, units=currentUnits(),	pooled.var=pooled.var2(), plot.theme.dark=input$plotThemeDark, logo.mat=logo.mat, ...)
		} else NULL
	} else NULL
}

doPlot_heatmap <- function(...){
	if(permitPlot() & !is.null(input$heatmap_x) & !is.null(input$heatmap_y) & length(input$colorpalettesHeatmap)){
		heatPlot(d=dat(), d2=dat_heatmap(), x=input$heatmap_x, y=input$heatmap_y, z=input$statHeatmap,
			panels=facetPanelsHeatmap(), facet.by=input$facetHeatmap,
			fontsize=input$plotFontSizeHeatmap, colpal=input$colorpalettesHeatmap, reverse.colors=input$revHeatmapColors, aspect_1to1=input$aspect1to1, show.values=input$showHeatmapVals,
			show.overlay=input$showCRU, overlay=CRU(),
			plot.title=plot_hm_title(), plot.subtitle=plot_hm_subtitle(), show.panel.text=input$showPanelText, show.title=input$showTitle,
			lgd.pos=input$legendPosHeatmap, units=currentUnits(), pooled.var=pooledVarHeatmap(), plot.theme.dark=input$plotThemeDark, logo.mat=logo.mat, ...)
	} else NULL
}

doPlot_var <- function(...){
	if(permitPlot() & !is.null(pooled.var3()) & !is.null(input$group3)){
		if(!(input$group3!="None" & !length(input$colorpalettes3))){
			varPlot(d=dat(), x=input$xvar, y="Val", stat=stat(), around.mean=input$variability, d.grp=datCollapseGroups(), d.pool=datCollapsePooled(), grp=input$group3, n.grp=n.groups3(), ingroup.subjects=subjectChoices3(),
				panels=facet.panels3(), facet.by=input$facet3, vert.facet=input$vert.facet3,
				fontsize=input$plotFontSize3, colpal=input$colorpalettes3, colseq=input$colorseq3, mos=Months(),
				altplot=input$altplot, boxplots=input$boxplots, pts.alpha=input$alpha3, bartype=input$bartype3, bardirection=input$bardirection3,
				show.points=input$showpts, show.lines=input$showlines, show.overlay=input$showCRU, overlay=CRU(),
				jit=input$jitterXY, plot.title=plot_var_title(), plot.subtitle=plot_var_subtitle(), show.panel.text=input$showPanelText, show.title=input$showTitle, lgd.pos=input$legendPos3,
				units=currentUnits(), yrange=input$yrange, clbootbar=input$clbootbar, clbootsmooth=input$clbootsmooth,
				plot.theme.dark=input$plotThemeDark, logo.mat=logo.mat, ...)
		} else NULL
	} else NULL
}

# Primary outputs
# Time series plot
output$PlotTS <- renderPlot({
	if(anyBtnNullOrZero()) return()
	isolate({
		progress <- Progress$new(session, min=1, max=10)
		on.exit(progress$close())
		progress$set(message="Plotting, please wait", detail="Generating plot...")
		doPlot_ts(show.logo=F)
	})
}, height=function(){ if(anyBtnNullOrZero()) 0 else 700 }, width=1200)

output$dlCurPlotTS <- downloadHandler(
	filename='timeseries.pdf',
	content=function(file){ pdf(file = file, width=1.5*12, height=1.5*7, pointsize=12, onefile=FALSE); doPlot_ts(show.logo=T); dev.off() }
)

output$dlCurTableTS <- downloadHandler(
	filename=function(){ 'timeseries_data.csv' }, content=function(file){ write.csv(dat(), file) }
)

# Scatterplot
plot_scatter_ht <- function(){
	if(anyBtnNullOrZero()) return(0)
	ht <- 700
	if(!is.null(facet.panels2())){
		cols <- ceiling(sqrt(facet.panels2()))
		rows <- ceiling(facet.panels2()/cols)
		ht <- ht*(rows/cols)
	}
	ht
}

output$PlotScatter <- renderPlot({
	if(anyBtnNullOrZero()) return()
	isolate({
		progress <- Progress$new(session, min=1, max=10)
		on.exit(progress$close())
		progress$set(message="Plotting, please wait", detail="Generating plot...")
		doPlot_scatter(show.logo=F)
		})
}, height=plot_scatter_ht, width=700)

output$dlCurPlotScatter <- downloadHandler(
	filename='scatterplot.pdf',
	content=function(file){ pdf(file = file, width=1.5*12, height=1.5*12, pointsize=12, onefile=FALSE); doPlot_scatter(show.logo=T); dev.off() }
)

output$dlCurTableScatter <- downloadHandler(
	filename=function(){ 'scatterplot_data.csv' }, content=function(file){ write.csv(dat2(), file) }
)

# Variability plot
output$PlotVariability <- renderPlot({
	if(anyBtnNullOrZero()) return()
	isolate({
		progress <- Progress$new(session, min=1, max=10)
		on.exit(progress$close())
		progress$set(message="Plotting, please wait", detail="Generating plot...")
		doPlot_var(show.logo=F)
		})
}, height=function(){ if(anyBtnNullOrZero()) 0 else 700 }, width=1200)

output$dlCurPlotVariability <- downloadHandler(
	filename='variability.pdf',
	content=function(file){ pdf(file = file, width=1.5*12, height=1.5*7, pointsize=12, onefile=FALSE); doPlot_var(show.logo=T); dev.off() }
)

output$dlCurTableVariability <- downloadHandler(
	filename=function(){ 'variability_data.csv' }, content=function(file){ write.csv(dat(), file) }
)

# Heatmap plot
output$PlotHeatmap <- renderPlot({
	if(anyBtnNullOrZero()) return()
	isolate({
		progress <- Progress$new(session, min=1, max=10)
		on.exit(progress$close())
		progress$set(message="Plotting, please wait", detail="Generating plot...")
		doPlot_heatmap(show.logo=F)
		})
}, height=function(){ if(anyBtnNullOrZero()) 0 else 700 }, width=1200)

output$dlCurPlotHeatmap <- downloadHandler(
	filename='heatmap.pdf',
	content=function(file){ pdf(file = file, width=1.5*12, height=1.5*7, pointsize=12, onefile=FALSE); doPlot_heatmap(show.logo=T); dev.off() }
)

output$dlCurTableHeatmap <- downloadHandler(
	filename=function(){ 'heatmap_data.csv' }, content=function(file){ write.csv(dat(), file) }
)

############################## Leaflet testing
# Create the map; this is not the "real" map, but rather a proxy
# object that lets us control the leaflet map on the page.
#map <- createLeafletMap(session, 'map')

#observe({
#	if(is.null(input$map_click)) return()
#	selectedCity <<- NULL
#})

#radiusFactor <- 1000
#observe({
#	map$clearShapes()
#	cities <- topCitiesInBounds()
#	if(nrow(cities) == 0) return()

#	map$addCircle(
#		cities$Lat,
#		cities$Lon,
#		sqrt(cities$Population)*radiusFactor/max(5, input$map_zoom)^2,
#		cities$Domain,
#		list(weight=1.2, fill=TRUE, color='#8B008B')
#	)
#})

#observe({
#	event <- input$map_shape_click
#	if(is.null(event)) return()
#	map$clearPopups()
    
#	isolate({
#		cities <- topCitiesInBounds()
#		city <- cities[cities$Domain == event$id,]
#		selectedCity <<- city
#		content <- as.character(tagList(
#			tags$strong(city$Domain),
#			tags$br(),
#			sprintf("Estimated population, %s:", 2010), #2010?
#			tags$br(),
#			prettyNum(city$Population, big.mark=',')
#		))
#		map$showPopup(event$lat, event$lng, content, event$id)
#	})
#})

#output$desc <- reactive({
#	if(is.null(input$map_bounds)) return(list())
#	list(
#		lat=mean(c(input$map_bounds$north, input$map_bounds$south)),
#		lng=mean(c(input$map_bounds$east, input$map_bounds$west)),
#		shownCities=nrow(topCitiesInBounds()),
#		totalCities=nrow(citiesInBounds())
#	)
#})

#output$citydata <- renderTable({
#	if(nrow(topCitiesInBounds()) == 0) return(NULL)
#	topCitiesInBounds()
#}, include.rownames = FALSE)
###################################################
