shinyServer(function(input, output, session){

Colors <- reactive({ if(input$variable=="Temperature") c("#666666", colorRampPalette(c("gold", "orange", "orangered", "darkred"))(4)) else c("#666666", colorRampPalette(c("aquamarine", "dodgerblue4"))(4)) })
RCPLabel <- reactive({ switch(input$rcp, "r45"="Low-Range Emissions (RCP 4.5)", "r60"="Mid-Range Emissions (RCP 6.0)", "r85"="High-Range Emissions (RCP 8.5)") })
FreezePoint <- reactive({ ifelse(input$units=="Fin", 32, 0) })
Thresh <- reactive({ ifelse(input$variable=="Precipitation", 0, FreezePoint()) })
Unit <- reactive({ if(input$variable=="Temperature") paste0("°", substr(input$units, 1, 1)) else substr(input$units, 2, 3) })
PRISM <- reactive({ if(input$variable=="Temperature") return(prism.t[prism.cities==input$location,]) else return(prism.p[prism.cities==input$location,]) })

CRU31 <- reactive({ if(input$res=="10min") d.cru31.10min else d.cru31.2km })
CRU32 <- reactive({ if(input$res=="10min") d.cru32.10min else d.cru32.2km })
CRU <- reactive({ if(input$baseline!="CRU 3.1") CRU32() else CRU31() })
CRU_loc <- reactive({ subset(CRU(), Location==input$location) })
CRU_var <- reactive({ subset(CRU_loc(), Var==input$variable) })

d0 <- reactive({ if(input$res=="10min") d.10min else d.2km })
d1_loc <- reactive({ subset(d0(), Location==input$location) })
NoData <- reactive({ all(is.na(d1_loc()$Mean)) })
d2_var <- reactive({ if(NoData()) NULL else subset(d1_loc(), Var==input$variable) })
d3_scen <- reactive({
print(input$location)
	if(is.null(d2_var())) return(NULL)
	x <- subset(d2_var(), Scenario==substr(RCPLabel(), nchar(RCPLabel())-7, nchar(RCPLabel())-1))
	if(input$baseline=="PRISM"){
		gap <- if(input$errtype=="sd") min(x$SD)/5 else min(x$SD)/2
		x <- rbind(x[1:12,], x)
		x$Decade[1:12] <- "1961-1990"
		x[1:12, 6:9] <- PRISM() + rep(c(-gap, 0, gap, gap), each=length(PRISM()))
		if(input$err!="exclusive"){ x$Min[1:12] <- x$Max[1:12] <- x$SD[1:12] <- NA }
	} else if(input$baseline!="PRISM") {
		x <- rbind(CRU_var(), x)
	}
	if(input$units=="Fin") { if(input$variable=="Temperature") { x[,6:8] <- x[,6:8]*(9/5) + 32; x[,9] <- x[,9]*(9/5) } else x[,6:9] <- x[,6:9]/25.4 }
	if(input$errtype=="sd"){
		if(input$baseline=="PRISM") a <- 13 else a <- 1
		x[a:nrow(x), c(6,8)] <- x[a:nrow(x), 7] + rep(c(-1,1), each=nrow(x)-a+1)*x[a:nrow(x), 9]
	}
	x
})

output$No2km <- renderUI({ if(input$location!="" & input$res=="2km" & NoData()) h4(paste("2-km resolution data not available for", input$location)) })
output$No10min <- renderUI({ if(input$location!="" & input$res=="10min" & NoData()) h4(paste("10-minute resolution data not available for", input$location)) })

observe({ lapply(c("variable", "units", "rcp", "err", "errtype", "baseline", "res"), function(x) updateButtonGroup(session, x, value=input[[x]])) })

output$Chart1 <- renderChart2({
	if(is.null(d3_scen())) return(Highcharts$new())
	if(!length(input$location) || input$location=="") return(Highcharts$new())
	p <- if(input$err=="exclusive") Highcharts$new() else hPlot(x="Month", y="Mean", data=d3_scen(), type="column", group="Decade")
	p$colors(Colors())
	p$title(text=paste("Average Monthly", input$variable, "for", input$location), style=list(color="#000000"))
	p$subtitle(text=paste("Historical", input$baseline, "and 5-Model Projected Average,", RCPLabel()), style=list(color="gray"))
	p$legend(verticalAlign="top", y=50, borderWidth=1, borderColor="gray", borderRadius=5, itemMarginBottom=-5, itemMarginBottom=-5, itemStyle=list(color="gray"))
	p$xAxis(categories=month.abb, title=list(text=caption, style=list(color="gray", fontWeight="normal", fontSize="8px")))
	p$yAxis(title=list(text=paste0(input$variable, " (", Unit(), ")"), style=list(color="gray")))
	if(input$err!="exclusive") p$plotOptions(column=list(threshold=Thresh()))
	if(input$err!="none"){
		if(input$err=="overlay") for(k in 1:5) p$params$series[[k]]$id <- paste0("series", k)
		d <- d3_scen()[c(5,6,8)]
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
