library(shiny)
pkgs <- c("reshape","raster","maps","maptools")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
load("qmProc_all_large_20130304.RData", envir=.GlobalEnv)
library(reshape)
library(raster)
library(maps)
library(maptools)

shinyServer(function(input,output){

	output$showMap <- renderUI({
		checkboxInput("showmap","Show location grid",F)
	})
	
	output$showMapPlot <- renderUI({
		if(length(input$showmap)) if(input$showmap) plotOutput("mapPlot",height="100%")
	})

	output$Mod <- renderUI({
		selectInput("mod","Choose model:",choices=mod.nam,selected=mod.nam[1])
	})
	
	output$RCP <- renderUI({
		selectInput("rcp","Choose RCP:",choices=rcp.nam,selected=rcp.nam[1])
	})
	
	output$Var <- renderUI({
		selectInput("var","Choose variable:",choices=var.nam,selected=var.nam[1],multiple=T)
	})
	
	output$Loc <- renderUI({
		selectInput("loc","Choose location:",choices=loc.nam,selected=loc.nam[1],multiple=T)
	})
	
	output$CutT <- renderUI({
		selectInput("cut.t","Choose temperature (C) threshold:",choices=temp.cut,selected=temp.cut[1],multiple=T)
	})
	
	output$CutW <- renderUI({
		selectInput("cut.w","Choose wind (m/s) threshold:",choices=wind.cut,selected=wind.cut[1],multiple=T)
	})
	
	output$Cond <- renderUI({
		selectInput("cond","Choose a conditional variable:",choices=c("Model","RCP","Location","Threshold","Variable"),selected="Model")
	})
	
	thresh <- reactive({
		if(length(input$var) & length(input$cut.t) & length(input$cut.w)){
			if(input$var=="temperature") thresh <- input$cut.t else thresh <- input$cut.w
		} else {
			thresh <- NULL
		}
		thresh
	})
	
	output$Direction <- renderUI({
		selectInput("direct","Days per month:",choices=c("Above threshold(s)","Below threshold(s)"),selected="Above threshold(s)")
	})
	
	output$Mo <- renderUI({
		selectInput("mo","Show months:",choices=c("All",mos),selected="Jan",multiple=T)
	})
	
	mo.vec <- reactive({
		if(length(input$mo)){
			if(input$mo[1]=="All") mo.vec <- mos else mo.vec <- input$mo
		} else {
			mo.vec <- NULL
		}
		mo.vec
	})
	
	output$MoHi <- renderUI({
		if(length(mo.vec())) selectInput("mohi","Highlight months:",choices=c("None",mo.vec()),selected="None",multiple=T)
	})
	
	mos.lines.vec <- reactive({
		if(length(input$mohi)){
			if(input$mohi[1]=="None"){
				mos.lines.vec <- NULL
			} else {
				mos.lines.vec <- input$mohi
			}
		} else {
			mos.lines.vec <- NULL
		}
		mos.lines.vec
	})
	
	dat <- reactive({
		if(length(input$loc)){
			if(length(input$loc)>=1 & input$cond=="Location"){
				dat <- c()
				for(i in 1:length(input$loc)) dat <- rbind(dat,get(input$loc[i]))
			} else {
				dat <- get(input$loc[1])
			}
		} else dat <- NULL
		dat
	})
	
	output$plot <- renderPlot({
	if(length(input$mo) & length(input$mohi) & length(input$cond) & length(input$rcp)){
		yrs <- c(input$yrs[1],input$yrs[2])
		mos.sub <- match(mo.vec(),mos)
		mos.lines <- match(mos.lines.vec(),mos)
		if(length(input$direct)) if(input$direct=="Below threshold(s)") direct <- input$direct else direct <- "Above threshold(s)"
		if(input$cond=="Model") print(tsMoCond(dat(),cond="model",rcp=input$rcp,loc=input$loc[1],varid=input$var[1],threshold=thresh()[1],yrs=yrs,mo=mos.sub,plotfile=path[1],mo.lines=mos.lines,direct=direct))
		if(input$cond=="RCP") print(tsMoCond(dat(),cond="rcp",mod=input$mod,loc=input$loc[1],varid=input$var[1],threshold=thresh()[1],yrs=yrs,mo=mos.sub,plotfile=path[2],mo.lines=mos.lines,direct=direct))
		if(input$cond=="Location") print(tsMoCond(dat(),cond="location",mod=input$mod,rcp=input$rcp,varid=input$var[1],threshold=thresh()[1],yrs=yrs,mo=mos.sub,plotfile=path[3],mo.lines=mos.lines,direct=direct))
		if(input$cond=="Variable") print(tsMoCond(dat(),cond="variable",mod=input$mod,rcp=input$rcp,loc=input$loc[1],varid=input$var,threshold=c(input$cut.t[1],rep(input$cut.w[1],length(var.nam)-1)),yrs=yrs,mo=mos.sub,plotfile=path[4],mo.lines=mos.lines,direct=direct))
		if(input$cond=="Threshold") print(tsMoCond(dat(),cond="threshold",mod=input$mod,rcp=input$rcp,loc=input$loc[1],varid=input$var[1],threshold=thresh(),yrs=yrs,mo=mos.sub,plotfile=path[5],mo.lines=mos.lines,direct=direct))
	}
	},
	height=800
	)
	
	cells.active <- reactive({
		cells.active <- cells[match(input$loc,loc.nam)]
		cells.active
	})
	
	locs.active <- reactive({
		locs.active <- match(cells.active(),cells)
		locs.active
	})
	
	output$mapPlot <- renderPlot({
		r.tmp[] <- NA
		par(mar=c(0,0,0,0)+0.1)
		image(r.tmp,xlim=xlm,ylim=ylm,main="",xlab="PC Lon",ylab="Lat",cex.lab=1.2,cex.axis=1.2)
		abline(h=seq(ymin(r),ymax(r),by=res(r)[1]),v=seq(xmin(r),xmax(r),by=res(r)[1]),col="#00000050",lty=2,lwd=1)
		lines(m,col="#00000090",lwd=2)
		r.tmp[cells] <- 1
		image(r.tmp,col="#FFA50099",axes=F,ann=F,add=T)
		r.tmp[] <- NA
		r.tmp[cells.active()] <- 1
		image(r.tmp,col="#8B250099",axes=F,ann=F,add=T)
		legend("bottomright",c("Available locations","Currently selected"),pch=22,pt.bg=c("#FFA50099","#8B250099"),pt.cex=2,cex=1)
		points(cells.lonlat[locs.active(),1], cells.lonlat[locs.active(),2], pch="*",cex=2)
		clrs <- rep("darkgray",length(cells))
		clrs[locs.active()] <- "black"
		pointLabel(cells.lonlat[,1], cells.lonlat[,2], labels=loc.nam, col=clrs, cex=1)
	},
	height=300, width=480
	)

	output$header <- renderUI({
		h4(paste("CMIP5 quantile-mapped GCM daily data"))
	})
	
	output$datname <- renderPrint({ # this is used for lazy debugging by printing specific information to the headerPanel
		x <- c(input$cut.t[1],rep(input$cut.w[1],length(var.nam)-1))
		x
	})
})
