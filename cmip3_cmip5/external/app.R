# Source reactive expressions and other code
source("external/appSourceFiles/reactives.R",local=T) # source reactive expressions
source("external/appSourceFiles/reactives_leaflet.R",local=T) # source reactive expressions for leaflet
#source("external/appSourceFiles/io.sidebar.wp1.R",local=T) # source input/output objects associated with sidebar wellPanel 1
source("external/appSourceFiles/io.sidebar.wp2.R",local=T) # source input/output objects associated with sidebar wellPanel 2
source("external/appSourceFiles/io.mainPanel.tp1.R",local=T) # source input/output objects associated with mainPanel tabPanel 1

tsPlot <- source("external/appSourceFiles/doPlot1.R",local=T)$value
scatterPlot <- source("external/appSourceFiles/doPlot2.R",local=T)$value
varPlot <- source("external/appSourceFiles/doPlot3.R",local=T)$value

# Specific plot function setup
doPlot_ts <- function(...){
	if(permitPlot() & !is.null(input$group)){
		if(!(input$group!="None/Force Pool" & !length(input$colorpalettes))){
			tsPlot(d=dat(), x=input$xtime, y="Val", d.grp=datCollapseGroups(), d.pool=datCollapsePooled(), grp=input$group, n.grp=n.groups(), ingroup.subjects=subjectSelected(),
				panels=facet.panels(), facet.by=input$facet, vert.facet=input$vert.facet,
				fontsize=input$plotFontSize, colpal=input$colorpalettes, colseq=input$colorseq, mos=Months(),
				altplot=input$altplot, pts.alpha=input$alpha1, bartype=input$bartype, bardirection=input$bardirection, show.points=input$showpts, show.overlay=input$showCRU, overlay=CRU(), jit=input$jitterXY,
				plot.title=plot_ts_title(), plot.subtitle=plot_ts_subtitle(), lgd.pos=input$legendPos1,
				units=currentUnits(), yrange=input$yrange, clbootbar=input$clbootbar, clbootsmooth=input$clbootsmooth,
				pooled.var=pooled.var(), logo.mat=logo.mat, ...)
		} else NULL
	} else NULL
}

doPlot_scatter <- function(...){
	if(permitPlot() & !is.null(input$group2)){
		if(!(input$group2!="None/Force Pool" & !length(input$colorpalettes2))){
			scatterPlot(d=dat2(), form.string=input$xy, grp=input$group2, n.grp=n.groups2(),
				panels=facet.panels2(), facet.by=input$facet2, vert.facet=input$vert.facet2,
				fontsize=input$plotFontSize2, colpal=input$colorpalettes2, colseq=input$colorseq2, mos=Months(),
				contourlines=input$conplot, hexbin=input$hexbin, pts.alpha=input$alpha2, show.overlay=input$showCRU, overlay=CRU2(), jit=input$jitterXY, plot.title=plot_sp_title(), plot.subtitle=plot_sp_subtitle(),
				lgd.pos=input$legendPos2, units=currentUnits(),	pooled.var=pooled.var2(), logo.mat=logo.mat, ...)
		} else NULL
	} else NULL
}

doPlot_var <- function(...){
	if(permitPlot() & !is.null(pooled.var3()) & !is.null(input$group2)){
		if(!(input$group3!="None/Force Pool" & !length(input$colorpalettes3))){
			varPlot(d=dat(), x=input$xvar, y="Val", stat=stat(), around.mean=input$variability, d.grp=datCollapseGroups(), d.pool=datCollapsePooled(), grp=input$group3, n.grp=n.groups3(), ingroup.subjects=subjectSelected3(),
				panels=facet.panels3(), facet.by=input$facet3, vert.facet=input$vert.facet3,
				fontsize=input$plotFontSize3, colpal=input$colorpalettes3, colseq=input$colorseq3, mos=Months(),
				altplot=input$altplot, boxplots=input$boxplots, pts.alpha=input$alpha3, bartype=input$bartype3, bardirection=input$bardirection3, show.points=input$showpts, show.overlay=input$showCRU, overlay=CRU(),
				jit=input$jitterXY, plot.title=plot_var_title(), plot.subtitle=plot_var_subtitle(), lgd.pos=input$legendPos3,
				units=currentUnits(), yrange=input$yrange, clbootbar=input$clbootbar, clbootsmooth=input$clbootsmooth,
				logo.mat=logo.mat, ...)
		} else NULL
	} else NULL
}

# Primary outputs
# Time series plot
output$plot1 <- renderPlot({
	if(is.null(input$plotButton) || input$plotButton==0) return()
	#input$colorpalettes
	#input$alpha1
	####input$altplot
	#input$bartype
	#input$bardirection
	#input$legendPos1
	#input$plotFontSize
	isolate({
		progress <- Progress$new(session, min=1, max=10)
		on.exit(progress$close())
		progress$set(message="Plotting, please wait", detail="Generating plot...")
		doPlot_ts(show.logo=F)
	})
}, height=700, width=1200)

output$dlCurPlot1 <- downloadHandler(
	filename='timeseries.pdf',
	content=function(file){ pdf(file = file, width=1.5*12, height=1.5*7, pointsize=12, onefile=FALSE); doPlot_ts(show.logo=T); dev.off() }
)

output$dlCurTable1 <- downloadHandler(
	filename=function(){ 'timeseries_data.csv' }, content=function(file){ write.csv(dat(), file) }
)

# Scatterplot
plot2ht <- function(){
	ht <- 1000
	if(!is.null(facet.panels2())){
		cols <- ceiling(sqrt(facet.panels2()))
		rows <- ceiling(facet.panels2()/cols)
		ht <- ht*(rows/cols)
	}
	ht
}

output$plot2 <- renderPlot({ # render plot from doPlot1 for mainPanel tabsetPanel tabPanel 1
	if(is.null(input$plotButton) || input$plotButton==0) return()
	#input$colorpalettes2
	#input$alpha2
	####input$conplot
	#input$legendPos2
	#input$plotFontSize2
	isolate({
		progress <- Progress$new(session, min=1, max=10)
		on.exit(progress$close())
		progress$set(message="Plotting, please wait", detail="Generating plot...")
		doPlot_scatter(show.logo=F)
		})
}, height=plot2ht, width=1000)

output$dlCurPlot2 <- downloadHandler(
	filename='scatterplot.pdf',
	content=function(file){ pdf(file = file, width=1.5*12, height=1.5*12, pointsize=12, onefile=FALSE); doPlot_scatter(show.logo=T); dev.off() }
)

output$dlCurTable2 <- downloadHandler(
	filename=function(){ 'scatterplot_data.csv' }, content=function(file){ write.csv(dat2(), file) }
)

# Variability plot
output$plot3 <- renderPlot({ # render plot from doPlot1 for mainPanel tabsetPanel tabPanel 1
	if(is.null(input$plotButton) || input$plotButton==0) return()
	#input$colorpalettes3
	#input$alpha3
	####input$altplot
	#input$bartype3
	#input$bardirection3
	#input$legendPos3
	#input$plotFontSize3
	isolate({
		progress <- Progress$new(session, min=1, max=10)
		on.exit(progress$close())
		progress$set(message="Plotting, please wait", detail="Generating plot...")
		doPlot_var(show.logo=F)
		})
}, height=700, width=1200)

output$dlCurPlot3 <- downloadHandler(
	filename='variability.pdf',
	content=function(file){ pdf(file = file, width=1.5*12, height=1.5*7, pointsize=12, onefile=FALSE); doPlot_var(show.logo=T); dev.off() }
)

output$dlCurTable3 <- downloadHandler(
	filename=function(){ 'variability_data.csv' }, content=function(file){ write.csv(dat(), file) }
)

############################## Leaflet testing
# Create the map; this is not the "real" map, but rather a proxy
# object that lets us control the leaflet map on the page.
map <- createLeafletMap(session, 'map')

observe({
	if(is.null(input$map_click)) return()
	selectedCity <<- NULL
})

radiusFactor <- 1000
observe({
	map$clearShapes()
	cities <- topCitiesInBounds()
	if(nrow(cities) == 0) return()

	map$addCircle(
		cities$Lat,
		cities$Lon,
		sqrt(cities$Population)*radiusFactor/max(5, input$map_zoom)^2,
		cities$Domain,
		list(weight=1.2, fill=TRUE, color='#8B008B')
	)
})

observe({
	event <- input$map_shape_click
	if(is.null(event)) return()
	map$clearPopups()
    
	isolate({
		cities <- topCitiesInBounds()
		city <- cities[cities$Domain == event$id,]
		selectedCity <<- city
		content <- as.character(tagList(
			tags$strong(city$Domain),
			tags$br(),
			sprintf("Estimated population, %s:", 2010), #2010?
			tags$br(),
			prettyNum(city$Population, big.mark=',')
		))
		map$showPopup(event$lat, event$lng, content, event$id)
	})
})

output$desc <- reactive({
	if(is.null(input$map_bounds)) return(list())
	list(
		lat=mean(c(input$map_bounds$north, input$map_bounds$south)),
		lng=mean(c(input$map_bounds$east, input$map_bounds$west)),
		zoom=input$map_zoom,
		shownCities=nrow(topCitiesInBounds()),
		totalCities=nrow(citiesInBounds())
	)
})

output$citydata <- renderTable({
	if(nrow(topCitiesInBounds()) == 0) return(NULL)
	topCitiesInBounds()
}, include.rownames = FALSE)


###################################################

# Visitor counter for About tab
output$pageviews <-	renderText({
	if (!file.exists("pageviews.Rdata")) pageviews <- 0 else load(file="pageviews.Rdata")
	pageviews <- pageviews + 1
	save(pageviews,file="pageviews.Rdata")
	paste("Visits:",pageviews)
})
