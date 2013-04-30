library(shiny)
#pkgs <- c("raster","maps","mapproj","rasterVis")
#pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
#if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")

load("Totals.RData", envir=.GlobalEnv)
library(raster); library(maps); library(mapproj); library(rasterVis)

mm <- map("world", proj="stereographic", xlim=c(-180,180), ylim=c(47,90), interior=FALSE, lwd=1,plot=F)
clrs <- c("#8B2500","#000080","#FF8C00","#1E90FF","#FF1493","#000000") #"#CD9B1D"
pch <- c(0:3,6:7)
mos <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
modnames <- c("ACCESS-1.0","CESM1-CAM5","CMCC-CM","HADGEM2-AO","MIROC-5","Composite model")
files <- list.files(pattern=".tif$")
for(i in 1:length(files)) assign(paste("b",tolower(substr(files[i],1,2)),sep="."), brick(files[i]))

shinyServer(function(input,output){
	# Siderbar elements: dataset(s), years, month/season, decade, time series points, lines, and transparency
	output$Dataset <- renderUI({
		selectInput("dataset","Choose model:",choices=modnames,selected=modnames[1],multiple=T)
	})
	
	output$tsSlider <- renderUI({
		sliderInput("yrs","Year range:",1860,2099,c(1979,2011),step=1,format="#")
	})

	output$Mo <- renderUI({
		selectInput("mo","Seasonal period:",choices=c(mos,"Dec-Mar Avg","Jun-Sep Avg","Annual Avg"),selected="Jan")
	})
	
	output$Mo2 <- renderUI({
		selectInput("mo2","Month:",choices=mos,selected="Jan")
	})
	
	output$Decade <- renderUI({
		selectInput("decade","Decade:",choices=paste(seq(1860,2090,by=10),"s",sep=""),selected="2010s")
	})
	
	output$regpoints <- renderUI({
	if(length(input$dataset)){
		checkboxInput("regpts","Show sample points",TRUE)
	}
	})
	
	output$reglines <- renderUI({
	if(length(input$dataset)){
		checkboxInput("reglns","Show time series line(s)",FALSE)
	}
	})
	
	output$semiTrans <- renderUI({
		if(length(transparency())) if(transparency()) sliderInput("semi.trans","Samples transparency",10,90,60,step=10,format="#")
	})
	
	transparency <- reactive({
		trans <- F
		if(length(input$reglnslm1)) if(input$reglnslm1) trans <- T
		if(length(input$reglnslm2)) if(input$reglnslm2) trans <- T
		if(length(input$reglnslo)) if(input$reglnslo) trans <- T
		trans
	})
	
	# Reactive month/season variable, years, and rows for subsetting data.frame and numeric data objects
	mo.vec <- reactive({
		if(length(input$mo)){
			if(input$mo=="Annual Avg") {
				mo.vec <- mos
			} else if(input$mo=="Jun-Sep Avg") {
				mo.vec <- mos[6:9]
			} else if(input$mo=="Dec-Mar Avg") {
				mo.vec <- mos[c(1:3,12)]
			} else {
				mo.vec <- input$mo
			}
		} else {
			mo.vec <- NULL
		}
		mo.vec
	})
	
	mo2.vec <- reactive({
		if(length(input$mo2)){
			if(input$mo2=="Annual Avg") {
				mo2.vec <- mos
			} else if(input$mo2=="Jun-Sep Avg") {
				mo2.vec <- mos[6:9]
			} else if(input$mo2=="Dec-Mar Avg") {
				mo2.vec <- mos[c(1:3,12)]
			} else {
				mo2.vec <- input$mo2
			}
		} else {
			mo2.vec <- NULL
		}
		mo2.vec
	})
	
	yrs <- reactive({
	if(length(input$yrs)){
		yrs <- c(input$yrs[1],input$yrs[2])
		if(length(input$mo)) if(input$mo=="Dec-Mar Avg") yrs[1] <- yrs[1] + 1
		yrs
	} else NULL
	})
	
	rows <- reactive({ (yrs()[1]-1860+1):(yrs()[2]-1860+1) })
	
	# Plot color specific to model
	clr <- reactive({
		if(length(input$dataset))clr <- clrs[match(input$dataset,modnames)]
	})
	
	pch.vals <- reactive({
		if(length(input$dataset)) pch.vals <- pch[match(input$dataset,modnames)]
	})
	
	# Fix time series plot xlim and ylim with respect to full dataset even when plotting a subset
	output$fixXY <- renderUI({
		checkboxInput("fix.xy","Full fixed (x,y) limits",value=F)
	})
	
	# List of numeric vectors of values, one per each model, by month or seasonal average
	dat <- reactive({
		if(length(input$dataset)){
			dat <- list()
			mos.sub <- match(mo.vec(),mos)
			for(i in 1:length(input$dataset)){
				dat[[i]] <- get(paste(tolower(substr(input$dataset[i],1,2)),"t",sep="."))[,mos.sub]
				if(class(dat[[i]])=="data.frame"){
					if(input$mo=="Dec-Mar Avg"){
						dat[[i]] <- rowMeans(cbind(dat[[i]][-1,1:3], dat[[i]][-nrow(dat[[i]]),4]))
					} else {
						dat[[i]] <- rowMeans(dat[[i]])
					}
				}
			}
		} else dat <- NULL
		dat
	})
	
	# List of subsetted data
	dat2 <- reactive({
		dat <- list()
		for(i in 1:length(dat())) dat[[i]] <- dat()[[i]][rows()]
		dat
	})
	
	# Regression models
	lm1 <- reactive({
	if(!is.null(yrs())){
		lm1 <- list()
		time <- yrs()[1]:yrs()[2]
		for(i in 1:length(dat2())){
			extent.total <- dat2()[[i]]
			lm1[[i]] <- lm(extent.total ~ time)
		}
		names(lm1) <- input$dataset
		lm1
	}
	})
	
	lm2 <- reactive({
	if(!is.null(yrs())){
		lm2 <- list()
		time <- yrs()[1]:yrs()[2]
		for(i in 1:length(dat2())){
			extent.total <- dat2()[[i]]
			lm2[[i]] <- lm(extent.total ~ time + I(time^2))
		}
		names(lm2) <- input$dataset
		lm2
	}
	})
	
	lo <- reactive({
	if(length(input$smoothing.fraction)){
		lo <- list()
		time <- yrs()[1]:yrs()[2]
		for(i in 1:length(dat2())){
			extent.total <- dat2()[[i]]
			lo[[i]] <- loess(extent.total ~ time, span=input$smoothing.fraction)
		}
		names(lo) <- input$dataset
		lo
	}
	})
	
	output$lm1_summary <- renderPrint({
		lapply(lm1(),summary)
	})
	
	output$lm2_summary <- renderPrint({
		lapply(lm2(),summary)
	})
	
	output$lo_summary <- renderPrint({
		lapply(lo(),summary)
	})
	
	# Regression model sidebar elements
	output$reglineslm1 <- renderUI({
	if(length(input$dataset)){
		checkboxInput("reglnslm1","Linear trend",FALSE)
	}
	})
	
	output$reglineslm2 <- renderUI({
	if(length(input$dataset)){
		checkboxInput("reglnslm2","Quadratic trend",FALSE)
	}
	})
	
	output$reglineslo <- renderUI({
	if(length(input$dataset)){
		checkboxInput("reglnslo","Locally weighted loess",FALSE)
	}
	})
	
	output$loSpan <- renderUI({
	if(length(input$dataset) & length(input$reglnslo)){
		if(input$reglnslo) sliderInput("smoothing.fraction","Smoothing fraction:",0.15,1,0.75,0.05)
	}
	})
	
	# Time series plot and fitted trend lines
	doPlotTS <- function(margins=c(5,5,2,0)+0.1,main="",cex.lb=1.3,cex.ax=1.1,cex.leg=1.2){
		if(length(input$dataset)){
			rng <- range(dat()); rng2 <- range(dat2())
			par(mar=margins)
			xlb <- "Year"
			ylb <- expression("Sea Ice"~(km^2)~"")
			if(input$fix.xy){
				plot(0,0,type="n",xlim=c(1860,2099),xlab=xlb,ylab=ylb,ylim=rng,cex.lab=cex.lb,cex.axis=cex.ax)
				legend(yrs()[1],rng[2]+0.1*diff(rng),input$dataset,col=clr(),pch=pch.vals(),cex=cex.leg,bty="n",horiz=T,xpd=T)
			} else {
				plot(yrs()[1]:yrs()[2],type="n",xlim=yrs(),xlab=xlb,ylab=ylb,ylim=rng2,cex.lab=cex.lb,cex.axis=cex.ax)
				legend(yrs()[1],rng2[2]+0.1*diff(rng2),input$dataset,col=clr(),pch=pch.vals(),cex=cex.leg,bty="n",horiz=T,xpd=T)
			}
			for(i in 1:length(dat())){
				d <- dat2()[[i]]
				if(length(input$reglns)){
					if(input$reglns){
						if(transparency()){
							lines(yrs()[1]:yrs()[2],d, lty=1, lwd=2, col=paste(clr()[i],100-input$semi.trans,sep="",collapse=""))
						} else {
							lines(yrs()[1]:yrs()[2],d, lty=1, lwd=2, col=clr()[i])
						}
					}
				}
				if(length(input$regpts)){
					if(input$regpts){
						if(transparency()){
							points(yrs()[1]:yrs()[2],d, pch=pch.vals()[i], col=paste(clr()[i],100-input$semi.trans,sep="",collapse=""), cex=cex.leg)
						} else {
							points(yrs()[1]:yrs()[2],d, pch=pch.vals()[i], col=clr()[i], cex=cex.leg)
						}
					}
				}
				if(length(input$reglnslm1)) if(input$reglnslm1) lines(yrs()[1]:yrs()[2],fitted(lm1()[[i]]), lty=2, lwd=2, col=clr()[i])
				if(length(input$reglnslm2)) if(input$reglnslm2) lines(yrs()[1]:yrs()[2],fitted(lm2()[[i]]), lty=3, lwd=2, col=clr()[i])
				if(length(input$reglnslo)) if(input$reglnslo) lines(yrs()[1]:yrs()[2],fitted(lo()[[i]]), lty=4, lwd=2, col=clr()[i])
			}
		mtext(text = main, side = 3, adj = 0, line=2, cex=1.3)
		}
	}
	
	output$plot <- renderPlot({
		doPlotTS()
	},
	height=750, width=1000
	)
	
	# Reactive variables for map plot
	decade <- reactive({
		if(length(input$dataset)){
			decade <- (as.numeric(substr(input$decade,1,4))-1850)/10
		} else decade <- NULL
		decade
	})
	
	season <- reactive({
		if(length(input$dataset)){
			season <- mos.sub <- match(mo2.vec(),mos)
		} else season <- NULL
		season
	})
	
	laynum <- reactive({
		if(length(input$dataset)){
			laynum <- 12*(decade()-1) + season()
		} else laynum <- NULL
		laynum
	})
	
	dat.map <- reactive({
		if(length(input$dataset)){
			dat <- list()
			for(i in 1:length(modnames)){
				if(length(laynum())==1) {
					dat[[i]] <- subset(get(paste("b",tolower(substr(modnames[i],1,2)),sep=".")),laynum())
				} else if(length(laynum())>1) {
					dat[[i]] <- calc(subset(get(paste("b",tolower(substr(modnames[i],1,2)),sep=".")),laynum()), mean)
				}
			}
		} else dat <- NULL
		dat
	})
	
	# Map plot
	doPlotMap <- function(){
		if(length(input$mo2)){
			yrs <- c(input$yrs[1],input$yrs[2])
			b <- stack(dat.map())
			dx1 <- diff(mm$range[1:2])
			dx2 <- diff(c(xmin(b),xmax(b)))
			dy1 <- diff(mm$range[3:4])
			dy2 <- diff(c(ymin(b),ymax(b)))
			mm$x <- 0.86*( (mm$x-min(mm$x,na.rm=T))*dx2/dx1 + 1.06*xmin(b) ) # extra coefficients chosen by eye for display purposes only
			mm$y <- 0.87*( (mm$y-min(mm$y,na.rm=T))*dy2/dy1 + 1.08*ymin(b) )
			mm$range <- extent(b)
			brk <- c(-5.001,-0.001,seq(5,95,by=5),100.001)
			p <- levelplot(b, par.settings=list(strip.background=list(col=c("tan"))), at=brk, col.regions=c("tan",rev(colorRampPalette(c("white","blue"))(20))),
			main="Percent Sea Ice Concentration by Model",
			par.strip.text=list(cex=1,lines=2),
				panel = function(...){
						grid.rect(gp=gpar(col=NA,fill="black"))
						panel.levelplot(...)
						panel.lines(mm,col="black",lwd=1,alpha=0.5)
				}
			)
			print(update(p, strip=strip.custom(factor.levels=modnames)))
		}
	}
	
	output$plot2 <- renderPlot({
		doPlotMap()
	},
	height=750, width=1000
	)
	
	output$dlCurPlotTS <- downloadHandler(
		filename = 'curPlotTS.pdf',
		content = function(file){
			pdf(file = file, width=11, height=8.5)
			doPlotTS(margins=c(6,6,5,2),main="Sea Ice Extent Totals",cex.lb=0.9,cex.ax=0.8,cex.leg=0.9)
			dev.off()
		}
	)

	output$dlCurPlotMap <- downloadHandler(
		filename = 'curPlotMap.pdf',
		content = function(file){
			pdf(file = file, width=11, height=8.5)
			doPlotMap()
			dev.off()
		}
	)
	
	#output$header <- renderUI({
	#	h2(paste("Modeled Polar Sea Ice Coverage"))
	#})
	
	output$datname <- renderPrint({ # this is used for lazy debugging by printing specific information to the headerPanel
		x <- class(dat()[[1]])
		x
	})
})
