shinyServer(function(input, output, session){

output$Map <- renderLeaflet({
	leaflet() %>% addProviderTiles("CartoDB.Positron") %>% setView(lng=-140, lat=57, zoom=4) %>%
		addCircleMarkers(data=cities.meta, radius = ~sqrt(10*PopClass), color = ~palfun(PopClass), stroke=FALSE, fillOpacity=0.5, layerId = ~Location)
})

observeEvent(input$Map_marker_click, {
    p <- input$Map_marker_click
	if(p$id=="Selected"){
		leafletProxy("Map") %>% removeMarker(layerId="Selected")
	} else {
		leafletProxy("Map") %>% setView(lng=p$lng, lat=p$lat, input$Map_zoom) %>% addCircleMarkers(p$lng, p$lat, radius=10, color="black", fillColor="orange", fillOpacity=1, opacity=1, stroke=TRUE, layerId="Selected")
	}
})

observeEvent(input$location, {
	p <- input$Map_marker_click
	p2 <- subset(cities.meta, Location==input$location)
	if(nrow(p2)==0){
		leafletProxy("Map") %>% removeMarker(layerId="Selected")
	} else {
		leafletProxy("Map") %>% setView(lng=p2$Lon, lat=p2$Lat, input$Map_zoom) %>% addCircleMarkers(p2$Lon, p2$Lat, radius=10, color="black", fillColor="orange", fillOpacity=1, opacity=1, stroke=TRUE, layerId="Selected")
	}
})

observeEvent(input$Map_marker_click, {
	p <- input$Map_marker_click
	if(!is.null(p$id)){
		if(is.null(input$location)) updateSelectInput(session, "location", selected=p$id)
		if(!is.null(input$location) && input$location!=p$id) updateSelectInput(session, "location", selected=p$id)
	}
})

Dec <- reactive({
	x <- sort(as.numeric(substr(input$dec, 1, 4)))
	if(any(is.na(x))) return(NULL) else return(c("1960-1989", paste(x, x+9, sep="-")))
})
nDec <- reactive({ length(Dec()) })
Colors <- reactive({ if(input$variable=="Temperature" & nDec()) c("#666666", colorRampPalette(c("gold", "orange", "orangered", "darkred"))(nDec()-1)) else c("#666666", colorRampPalette(c("aquamarine", "dodgerblue4"))(nDec()-1)) })
RCPLabel <- reactive({ switch(input$rcp, "4.5 (low)"="Low-Range Emissions (RCP 4.5)", "6.0 (medium)"="Mid-Range Emissions (RCP 6.0)", "8.5 (high)"="High-Range Emissions (RCP 8.5)") })
Unit <- reactive({ if(input$variable=="Temperature") paste0("°", substr(input$units, 1, 1)) else substr(input$units, 4, 5) })
Min <- reactive({ if(input$variable=="Temperature") NULL else 0 })

CRU_loc <- reactive({ subset(d.cru32, Location==input$location) })
CRU_var <- reactive({ subset(CRU_loc(), Var==input$variable) })

d0 <- reactive({
	if(input$variable=="Temperature" | input$variable=="Precipitation" ){
		if(!exists("d")){
			prog <- Progress$new(session, min=0, max=1)
			on.exit(prog$close())
			prog$set(message="Loading data...", value=1)
			load(paste0("cc4lite_2km_plus_NWT10min.RData"), envir=.GlobalEnv)
		}
		return(d)
	}
})
d1_loc <- reactive({ subset(d0(), Location==input$location) })
d2_var <- reactive({ subset(d1_loc(), Var==input$variable) })
d3_scen <- reactive({
	x <- rbind(CRU_var(), subset(d2_var(), Scenario==substr(RCPLabel(), nchar(RCPLabel())-7, nchar(RCPLabel())-1)))
	if(input$units=="Fin") { if(input$variable=="Temperature") { x[,6:7] <- x[,6:7]*(9/5) + 32 } else x[,6:7] <- x[,6:7]/25.4 }
	x
})
d4_dec <- reactive({ if(is.null(d3_scen())) NULL else subset(d3_scen(), Decade %in% Dec()) })

output$Chart1 <- renderChart2({
	if(is.null(d4_dec())) return(Highcharts$new())
	if(!length(input$location) || input$location=="") return(Highcharts$new())
	if(!length(input$dec) || input$dec=="") return(Highcharts$new())
	p <- Highcharts$new()
	p$colors(Colors())
	p$title(text=paste("Average Monthly", input$variable, "for", input$location), style=list(color="#000000"))
	p$subtitle(text=paste("Historical CRU 3.2 and 5-Model Projections using", RCPLabel()), style=list(color="gray"))
	p$legend(verticalAlign="top", y=50, itemStyle=list(color="gray"))
	p$xAxis(categories=month.abb)
	p$yAxis(title=list(text=paste0(input$variable, " (", Unit(), ")"), style=list(color="gray")), min=Min())
	d <- d4_dec()[5:7]
	ddply(d, .(Decade), function(x) {
		g <- unique(x$Decade); x$Decade <- NULL; json <- toJSONArray2(x, json=F, names=F)
		p$series(data=json, name=g, type="columnrange")
		return(NULL)
	})
	p$exporting(enabled=F, scale=4)
	p$set(height=400)
	print(input$location)
	p
})

})
