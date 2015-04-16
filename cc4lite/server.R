shinyServer(function(input, output, session){
if(!exists("d.2km")) load(paste0("cc4lite_akcan2km.RData"), envir=.GlobalEnv)
Dec <- reactive({
	x <- sort(as.numeric(substr(input$dec, 1, 4)))
	if(any(is.na(x))) return(NULL) else return(c("1961-1990", paste(x, x+9, sep="-")))
})
nDec <- reactive({ length(Dec()) })
Colors <- reactive({ if(input$variable=="Temperature" & nDec()) c("#666666", colorRampPalette(c("gold", "orange", "orangered", "darkred"))(nDec()-1)) else c("#666666", colorRampPalette(c("aquamarine", "dodgerblue4"))(nDec()-1)) })
RCPLabel <- reactive({ switch(input$rcp, "r45"="Low-Range Emissions (RCP 4.5)", "r60"="Mid-Range Emissions (RCP 6.0)", "r85"="High-Range Emissions (RCP 8.5)") })
FreezePoint <- reactive({ ifelse(input$units=="Fin", 32, 0) })
Thresh <- reactive({ ifelse(input$variable=="Precipitation", 0, FreezePoint()) })
Unit <- reactive({ if(input$variable=="Temperature") paste0("°", substr(input$units, 1, 1)) else substr(input$units, 2, 3) })
PRISM <- reactive({ if(input$variable=="Temperature") return(prism.t[prism.cities==input$location,]) else return(prism.p[prism.cities==input$location,]) })

d1_loc <- reactive({ subset(d.2km, Location==input$location) })
d2_var <- reactive({ subset(d1_loc(), Var==input$variable) })
d3_scen <- reactive({
	x <- subset(d2_var(), Scenario==substr(RCPLabel(), nchar(RCPLabel())-7, nchar(RCPLabel())-1))
	x <- rbind(x[1:12,], x)
	x$Decade[1:12] <- "1961-1990"
	x$Min[1:12] <- x$Max[1:12] <- x$SD[1:12] <- NA
	if(input$units=="Fin") { if(input$variable=="Temperature") { x[,6:8] <- x[,6:8]*(9/5) + 32; x[,9] <- x[,9]*(9/5) } else x[,6:9] <- x[,6:9]/25.4 }
	x
})
d4_dec <- reactive({ subset(d3_scen(), Decade %in% Dec()) })

observe({ lapply(c("variable", "units", "rcp", "err"), function(x) updateButtonGroup(session, x, value=input[[x]])) })

output$Chart1 <- renderChart2({
	if(!length(input$location) || input$location=="") return(Highcharts$new())
	if(!length(input$dec) || input$dec=="") return(Highcharts$new())
	p <- hPlot(x="Month", y="Mean", data=d4_dec(), type="column", group="Decade")
	p$colors(Colors())
	p$title(text=paste("Average Monthly", input$variable, "for", input$location), style=list(color="#000000"))
	p$subtitle(text=paste("Historical PRISM and 5-Model Projected Average,", RCPLabel()), style=list(color="gray"))
	p$legend(verticalAlign="top", y=50, borderWidth=1, borderColor="gray", borderRadius=5, itemMarginBottom=-5, itemMarginBottom=-5, itemStyle=list(color="gray"))
	p$xAxis(categories=month.abb, title=list(text=caption, style=list(color="gray", fontWeight="normal", fontSize="8px")))
	p$yAxis(title=list(text=paste0(input$variable, " (", Unit(), ")"), style=list(color="gray")))
	p$plotOptions(column=list(threshold=Thresh()))
	if(input$err!="none"){
		for(k in 1:nDec()) p$params$series[[k]]$id <- paste0("series", k)
		d <- d4_dec()[c(5,6,8)]
		ddply(d, .(Decade), function(x) {
			g <- unique(x$Decade); x$Decade <- NULL; json <- toJSONArray2(x, json=F, names=F)
			if(input$err=="overlay") p$series(data=json, name=g, type="errorbar", linkedTo=paste0("series", which(unique(d$Decade)==g))) else p$series(data=json, name=g, type="columnrange")
			return(NULL)
		})
	}
	p$exporting(enabled=F, scale=4)
	p$chart(width=1000, height=600)
	p
})

})
