library(shiny)
pkgs <- c("reshape2","raster","maps","maptools")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
load("qm.RData", envir=.GlobalEnv)
library(reshape2)
library(raster)
library(maps)
library(maptools)

condPlot <- function(d,cond,varid,threshold,file,yrs,mo,main,mo.lines=NULL,alpha=90,direct,margins=c(5,5,4,1),cex.ax=1.3,cex.lb=1.5,cex.mn=2,...){
mo.nam <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
clrs <- paste(rep(c("#1E90FF","#FFA500","#551A8B","#32CD32","#FF4500","#FF69B4"),2),alpha,sep="")
nv <- ncol(d)-2
n <- nrow(d)
ylm <- c(0,1.05*max(d[-c(1,2)]))
if(direct=="Above threshold") symb <- ">" else symb <- "<"
if(cond=="variable"){
ylb <- c(bquote("Events per month"~.(symb)~.(threshold[1])~degree~C),
 bquote("Events per month"~.(symb)~.(threshold[2])~m/s),
 bquote("Events per month"~.(symb)~.(threshold[3])~m/s),
 bquote("Events per month"~.(symb)~.(threshold[3])~m/s))
} else {
ylb <- list()
if(length(threshold)==1) threshold <- rep(threshold,nv)
if(varid=="temperature"){
for(k in 1:nv) ylb[[k]] <- bquote("Events per month"~.(symb)~.(threshold[k])~degree~C)
} else if(varid=="WE wind"|varid=="NS wind"|varid=="Wind"){
for(k in 1:nv) ylb[[k]] <- bquote("Events per month"~.(symb)~.(threshold[k])~m/s)
}
}
layout(matrix(1:nv,nv,1))
par(mar=margins)
for(i in 1:nv){
if(i==nv) xlb=paste(yrs[1],yrs[2],sep=" - ") else xlb <- ""
bp <- barplot(d[,2+i],ylim=ylm,
main="",xlab=xlb,ylab=ylb[[i]],cex.axis=cex.ax,cex.lab=cex.lb,...)
if(i==1) title(main=main,cex.main=cex.mn)
if(is.numeric(mo.lines)){
for(j in 1:length(mo.lines)){
ind <- which(rep(mo,n/length(mo))==mo.lines[j])
lines(bp[ind],d[ind,2+i],lwd=3,col=clrs[j])
}
par(xpd=T)
if(cond!="threshold") text(-0.08*nrow(d),1.075*ylm[2],names(d[-c(1:2)])[i],pos=4,cex=1.1)
if(length(mo.lines)) legend(-0.08*nrow(d),-2/ylm[2],mo.nam[mo.lines],lwd=2,col=clrs[1:length(mo.lines)],bty="n",cex=cex.ax,xjust=0,horiz=T)
par(xpd=F)
}
}
}

tsMoCond <- function(dat,cond,mod=NULL,rcp=NULL,loc=NULL,varid=NULL,threshold=NULL,yrs,mo,plotfile,direct=NULL,...){
d <- switch(cond,
"model"=dcast(subset(dat,RCP==rcp & Loc==loc & Var==varid & Cut==threshold[1]),Year+Month~Mod),
"rcp"=dcast(subset(dat,Mod==mod & Loc==loc & Var==varid & Cut==threshold[1]),Year+Month~RCP),
"location"=dcast(subset(dat,Mod==mod & RCP==rcp & Var==varid & Cut==threshold[1]),Year+Month~Loc),
"variable"=dcast(subset(dat,Mod==mod & RCP==rcp & Loc==loc & (Cut==threshold[1]|Cut==threshold[2])),Year+Month~Var),
"threshold"=dcast(subset(dat,Mod==mod & RCP==rcp & Loc==loc & Var==varid),Year+Month~Cut)
)
if(cond=="threshold") d <- d[,c(1:2,2+match(threshold,names(d)[-c(1:2)]))]
if(cond=="variable") d <- d[,c(1:2,2+match(varid,names(d)[-c(1:2)]))]
d <- d[d$Year>=yrs[1] & d$Year<=yrs[2],]
d <- d[!is.na(match(d$Month,mo)),]
if(direct=="Below threshold"){
mo.ind <- unique(d$Month)
for(z in 1:length(mo.ind)) d[d$Month==mo.ind[z],3:ncol(d)] <- dpm[mo.ind[z]] - d[d$Month==mo.ind[z],3:ncol(d)]
}
rownames(d) <- NULL
main <- switch(cond,
"model"=paste(loc,rcp,"extreme",varid,"events by",cond),
"rcp"=paste(loc,mod,"extreme",varid,"events by",toupper(cond)),
"location"=paste(mod,rcp,"extreme",varid,"events by",cond),
"variable"=paste(loc,mod,rcp,"extreme events by",cond),
"threshold"=paste(loc,mod,rcp,"extreme",varid,"events by",cond)
)
p <- condPlot(d,cond,varid,threshold=threshold,plotfile,yrs=yrs,mo=mo,main=main,direct=direct,...)
p
}

shinyServer(function(input,output){

	output$showMap <- renderUI({
		checkboxInput("showmap","Show location grid",F)
	})
	
	output$showMapPlot <- renderUI({
		if(length(input$showmap)) if(input$showmap) { list(plotOutput("mapPlot",height="100%"), br()) }
	})

	output$Mod <- renderUI({
		selectInput("mod","Climate model:",choices=mod.nam,selected=mod.nam[1])
	})
	
	output$RCP <- renderUI({
		selectInput("rcp","RCP:",choices=rcp.nam,selected=rcp.nam[1])
	})
	
	output$Var <- renderUI({
		selectInput("var","Climate variable:",choices=var.nam,selected=var.nam[1],multiple=T)
	})
	
	output$Loc <- renderUI({
		selectInput("loc","Geographic location:",choices=loc.nam,selected=loc.nam[1],multiple=T)
	})
	
	output$CutT <- renderUI({
		selectInput("cut.t","Temp. threshold (C):",choices=temp.cut,selected=temp.cut[1],multiple=T)
	})
	
	output$CutW <- renderUI({
		selectInput("cut.w","Wind threshold (m/s):",choices=wind.cut,selected=wind.cut[1],multiple=T)
	})
	
	output$Cond <- renderUI({
		selectInput("cond","Conditional variable:",choices=c("Model","RCP","Location","Threshold","Variable"),selected="Model")
	})
	
	thresh <- reactive({
		if(length(input$var) & length(input$cut.t) & length(input$cut.w)){
			if(input$var[1]=="temperature") thresh <- input$cut.t else thresh <- input$cut.w
		} else {
			thresh <- NULL
		}
		thresh
	})
	
	output$Direction <- renderUI({
		selectInput("direct","Days per month:",choices=c("Above threshold","Below threshold"),selected="Above threshold")
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
	
	doPlot <- function(...){
	if(length(input$mo) & length(input$mohi) & length(input$cond) & length(input$rcp)){
		yrs <- c(input$yrs[1],input$yrs[2])
		mos.sub <- match(mo.vec(),mos)
		mos.lines <- match(mos.lines.vec(),mos)
		if(length(input$direct)) if(input$direct=="Below threshold") direct <- input$direct else direct <- "Above threshold"
		if(input$cond=="Model") print(tsMoCond(dat(),cond="model",rcp=input$rcp,loc=input$loc[1],varid=input$var[1],threshold=thresh()[1],yrs=yrs,mo=mos.sub,plotfile=path[1],mo.lines=mos.lines,direct=direct,...))
		if(input$cond=="RCP") print(tsMoCond(dat(),cond="rcp",mod=input$mod,loc=input$loc[1],varid=input$var[1],threshold=thresh()[1],yrs=yrs,mo=mos.sub,plotfile=path[2],mo.lines=mos.lines,direct=direct,...))
		if(input$cond=="Location") print(tsMoCond(dat(),cond="location",mod=input$mod,rcp=input$rcp,varid=input$var[1],threshold=thresh()[1],yrs=yrs,mo=mos.sub,plotfile=path[3],mo.lines=mos.lines,direct=direct,...))
		if(input$cond=="Variable") print(tsMoCond(dat(),cond="variable",mod=input$mod,rcp=input$rcp,loc=input$loc[1],varid=input$var,threshold=c(input$cut.t[1],rep(input$cut.w[1],length(var.nam)-1)),yrs=yrs,mo=mos.sub,plotfile=path[4],mo.lines=mos.lines,direct=direct,...))
		if(input$cond=="Threshold") print(tsMoCond(dat(),cond="threshold",mod=input$mod,rcp=input$rcp,loc=input$loc[1],varid=input$var[1],threshold=thresh(),yrs=yrs,mo=mos.sub,plotfile=path[5],mo.lines=mos.lines,direct=direct,...))
	}
	}
	
	output$plot <- renderPlot({
	doPlot()
	},
	height=800, width=1000
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

	output$dlCurPlot <- downloadHandler(
		filename = 'curPlot.pdf',
		content = function(file){
			pdf(file = file, width=11, height=8.5, pointsize=8)
			doPlot(margins=c(7,7,7,1),cex.ax=1.3,cex.lb=1.5,cex.mn=2)
			dev.off()
		}
	)

	#output$header <- renderUI({
	#	h4(paste("CMIP5 quantile-mapped GCM daily data"))
	#})
	
	output$datname <- renderPrint({ # this is used for lazy debugging by printing specific information to the headerPanel
		x <- c(input$cut.t[1],rep(input$cut.w[1],length(var.nam)-1))
		x
	})
})
