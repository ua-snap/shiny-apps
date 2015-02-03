library(shiny)
library(reshape2); library(raster); library(maps); library(maptools)

shinyServer(function(input, output, session){
	
	output$showMapPlot <- renderUI({
		if(length(input$showmap)) if(input$showmap) { list(plotOutput("mapPlot", width="100%", height="auto"), br()) }
	})
	
	windMagCheck <- reactive({ input$var[1]=="Wind" | (any(input$var=="Wind") & (input$cond=="Threshold" | input$cond=="Variable")) })
	
	output$CutW <- renderUI({
		if(length(input$var)){
			if(windMagCheck()){
				selectInput("cut.w", "Wind threshold (m/s):", choices=wind.cut[wind.cut>0], selected=wind.cut[wind.cut>0][1], multiple=T, width="100%")
			} else {
				selectInput("cut.w", "Wind threshold (m/s):", choices=wind.cut,selected=wind.cut[4], multiple=T, width="100%")
			}
		}
	})
	
	thresh <- reactive({
		if(length(input$var) & length(input$cut.t) & length(input$cut.w)){
			if(input$var[1]=="temperature") thresh <- input$cut.t else thresh <- input$cut.w
		} else {
			thresh <- NULL
		}
		thresh
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
		if(length(mo.vec())) selectInput("mohi", "Highlight months:", choices=c("None",mo.vec()), selected="None", multiple=T, width="100%")
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
	
	loadData <- reactive({
		if(length(input$loc)){
			if(length(input$loc)>=1 & input$cond=="Location"){
				for(i in 1:length(input$loc)) if(!exists(input$loc[i], envir=.GlobalEnv)) load(paste("data/",input$loc[i],".RData",sep=""), envir=.GlobalEnv)
			} else {
				if(!exists(input$loc[1], envir=.GlobalEnv)) load(paste("data/",input$loc[1],".RData",sep=""), envir=.GlobalEnv)
			}
		}
	})
	
	checkData <- reactive({
		loadData()
		if(length(input$loc)){
			exist <- c()
			if(length(input$loc)>=1 & input$cond=="Location"){
				for(i in 1:length(input$loc)) exist <- c(exist, exists(input$loc[i], envir=.GlobalEnv))
			} else {
				exist <- exists(input$loc[1], envir=.GlobalEnv)
			}
			return(all(exist))
		} else return(FALSE)
	})
	
	dat <- reactive({
		if(checkData()){
			if(length(input$loc)>=1 & input$cond=="Location"){
				dat <- c()
				for(i in 1:length(input$loc)) dat <- rbind(dat,get(input$loc[i], envir=.GlobalEnv))
			} else {
				dat <- get(input$loc[1], envir=.GlobalEnv)
			}
		} else dat <- NULL
		dat
	})
	
	doPlot <- function(...){
		if(length(input$mo) & length(input$mohi) & length(input$cond) & length(input$rcp)){
		if(checkData()){
			if(!(input$var[1]=="Wind" & any(thresh()<0))){
				yrs <- c(input$yrs[1],input$yrs[2])
				mos.sub <- match(mo.vec(),mos)
				mos.lines <- match(mos.lines.vec(),mos)
				if(length(input$direct)) if(input$direct=="Below threshold") direct <- input$direct else direct <- "Above threshold"
				if(input$cond=="Model") print(tsMoCond(dat(),cond="model",rcp=input$rcp,loc=input$loc[1],varid=input$var[1],threshold=thresh()[1],yrs=yrs,mo=mos.sub,plotfile=path[1],mo.lines=mos.lines,direct=direct,...))
				if(input$cond=="RCP") print(tsMoCond(dat(),cond="rcp",mod=input$mod,loc=input$loc[1],varid=input$var[1],threshold=thresh()[1],yrs=yrs,mo=mos.sub,plotfile=path[2],mo.lines=mos.lines,direct=direct,...))
				if(input$cond=="Location"){
					if(checkData())	print(tsMoCond(dat(),cond="location",mod=input$mod,rcp=input$rcp,varid=input$var[1],threshold=thresh()[1],yrs=yrs,mo=mos.sub,plotfile=path[3],mo.lines=mos.lines,direct=direct,...))
				}
				if(input$cond=="Variable"){
					thresh.tmp <- c(input$cut.t[1],rep(input$cut.w[1],length(var.nam)-1))[match(input$var,var.nam)]
					if(!( (any(input$var=="Wind") & any(input$var=="temperature") & any(thresh.tmp[-1]<0)) | (any(input$var=="Wind") & !any(input$var=="temperature") & any(thresh.tmp<0)) )){
						print(tsMoCond(dat(),cond="variable",mod=input$mod,rcp=input$rcp,loc=input$loc[1],varid=input$var,threshold=thresh.tmp,yrs=yrs,mo=mos.sub,plotfile=path[4],mo.lines=mos.lines,direct=direct,...))
					}
				}
				if(input$cond=="Threshold") print(tsMoCond(dat(),cond="threshold",mod=input$mod,rcp=input$rcp,loc=input$loc[1],varid=input$var[1],threshold=thresh(),yrs=yrs,mo=mos.sub,plotfile=path[5],mo.lines=mos.lines,direct=direct,...))
			}
		}
		}
	}
	
	output$plot <- renderPlot({
		doPlot(col=1)
	},
	height=function(){ w <- session$clientData$output_plot_width; round(0.8*w) }, width="auto"
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
	height=300, width="auto"
	)

	output$dlCurPlot <- downloadHandler(
		filename = 'curPlot.pdf',
		content = function(file){
			pdf(file = file, width=11, height=8.5, pointsize=8)
			doPlot(col=1,margins=c(8,8,8,1),cex.ax=1.3,cex.lb=1.5,cex.mn=2,cex.lg=1.8)
			dev.off()
		}
	)

})
