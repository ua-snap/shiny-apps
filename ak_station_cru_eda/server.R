library(shiny)
pkgs <- c("reshape2","ggplot2","googleVis")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(reshape2)
library(ggplot2)
#library(googleVis)

cities.dat <- read.csv("dat1.csv",header=T,stringsAsFactors=F)
cru.dat <- read.csv("dat2.csv",header=T,stringsAsFactors=F)
sta.dat <- read.csv("dat3.csv",header=T,stringsAsFactors=F)
staNA.dat <- read.csv("dat3b.csv",header=T,stringsAsFactors=F)
cru.names <- gsub("_"," ",names(cru.dat)[-c(1:3)])
names(cru.dat)[-c(1:3)] <- cru.names
sta.names <- gsub("_"," ",substr(names(sta.dat)[-c(1:3)],3,nchar(names(sta.dat)[-c(1:3)])))
reg.names <- gsub("_"," ",substr(names(sta.dat)[-c(1:3)],1,1))
names(sta.dat)[-c(1:3)] <- sta.names
names(staNA.dat)[-c(1:3)] <- sta.names
reg.sta.mat <- cbind(reg.names,sta.names)

mos <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
cru.dat$Month <- factor(cru.dat$Month,levels=mos)
var <- c("T","P")
reshape.fun <- function(x){
	x <- melt(x,id=c("Year","Month","Variable"))
	x <- dcast(x,Year+Variable+variable~Month)
	rownames(x) <- NULL
	x
}
plot.multiDens <- source("plot.multiDens.txt")$value
clrs <- paste(c("#000080","#CD3700","#ADFF2F","#8B4513","#006400","#2F4F4F","#CD9B1D",
				"#000080","#CD3700","#ADFF2F","#8B4513","#006400","#2F4F4F","#CD9B1D",
				"#000080","#CD3700","#ADFF2F","#8B4513","#006400","#2F4F4F","#CD9B1D",
				"#000080","#CD3700","#ADFF2F","#8B4513","#006400","#2F4F4F","#CD9B1D",
				"#000080","#CD3700","#ADFF2F","#8B4513"))

shinyServer(function(input,output){

	city.names <- reactive({
		if(input$dataset=="Weather stations (CRU-substituted NAs)" | input$dataset=="Weather stations (w/ missing data)") sta.names else if(input$dataset=="2-km downscaled CRU 3.1") cru.names
		})
	
	output$cityNames <- renderUI({
		selectInput("city","Choose a city:",choices=city.names(),multiple=T)
	})

	DATASET <- reactive({
		if(input$dataset=="Weather stations (CRU-substituted NAs)"){
			d <- sta.dat
		} else if(input$dataset=="Weather stations (w/ missing data)"){
			d <- staNA.dat
		} else if(input$dataset=="2-km downscaled CRU 3.1"){
			d <- cru.dat
		}
		d
	})
	
	map.dat <- reactive({
		ind <- match(city.names(),gsub("_"," ",cities.dat[,1]))
		map.dat <- data.frame(cbind(city.names(),apply(cities.dat[ind,2:3],1,paste,sep="",collapse=":")))
		names(map.dat) <- c("City","latlon")
		map.dat
	})

	output$yearSlider <- renderUI({
		if(length(input$city)){
			if(length(input$city)==1){
				r <- range(DATASET()$Year[!is.na(DATASET()[input$city])])
			} else {
				r <- c()
				for(i in 1:length(input$city)) r <- rbind( r, range(DATASET()$Year[!is.na(DATASET()[input$city[i]])]) )
				r <- c(max(r[,1]),min(r[,2]))
			}
			mn <- r[1]
			mx <- r[2]
			sliderInput("yrs","Year range:",mn,mx,c(max(mn,1950),mx),step=1,format="#")
		}# else {
		#	sliderInput("yrs","Year range:",1901,2009,c(1950,2009),step=1,format="#")
		#}
	})
	
	output$Var <- renderUI({
		if(length(input$city)) selectInput("var","Choose a variable:",choices=c("Precipitation","Temperature"))
	})
	
	output$Mo <- renderUI({
		if(length(input$city)) selectInput("mo","Choose a month:",choices=c(mos,"Choose multiple"))
	})
	
	curMo <- reactive({
		if(length(input$mo)){
			if(length(input$mo2)>0 & !is.null(input$mo2) & input$mo=="Choose multiple") { curMo <- input$mo2
			} else if(input$mo!="Choose multiple") { curMo <- input$mo
			} else if(input$mo=="Choose multiple") { curMo <- NULL }
		} else curMo <- NULL
		curMo
	})

	cols <- reactive({
		if(length(input$city)) cols <- c(1:3,match(input$city,names(DATASET()))) else cols <- NULL
	})

	dat <- reactive({
		if(length(curMo()) & length(input$city) & !is.null(cols()) & length(input$yrs)){
			mo <- DATASET()$Month %in% curMo()
			d <- subset(DATASET(),Year>=input$yrs[1] & Year<=input$yrs[2] & mo & Variable==substr(input$var,1,1), select=cols())
			rownames(d) <- NULL
		} else d <- NULL
		d
	})
	
	dat2 <- reactive({
		if(!is.null(dat())){
			x <- as.numeric(t(as.matrix(dat()[-c(1:3)])))
			v <- reshape.fun(dat())
			if(!is.null(input$stat) & length(input$mo2)>1){
				x <- switch(input$stat,
					None=as.numeric(t(as.matrix(dat()[-c(1:3)]))),
					Mean=apply(v[-c(1:3)],1,mean),
					Total=apply(v[-c(1:3)],1,sum),
					'Std. Dev.'=apply(v[-c(1:3)],1,sd),
					Minimum=apply(v[-c(1:3)],1,min),
					Maximum=apply(v[-c(1:3)],1,max)
				)
			}
			x <- cbind(v[1:3],x)
			names(x) <- c("Year","Variable","City","Values")
		} else { x <- NULL }
		x
	})
	
	output$histBin <- renderUI({
		if(length(input$city)){
			if(length(input$city)==1){
				checkboxInput("hb","Vary number of histogram bins",FALSE)
			} else if(length(input$multiplot)){
				if(input$multiplot=="Separate histograms"){
					checkboxInput("hb","Vary number of histogram bins",FALSE)
				}
			}
		}
	})
	
	output$histBinNum <- renderUI({
		if(length(input$hb)){
			if(input$hb){
				if(!length(input$multiplot)){
					selectInput("hbn","Number of histogram bins (approximate):",choices=c("5","10","20","40"),selected="5")
				} else if(input$multiplot=="Separate histograms"){
					selectInput("hbn","Number of histogram bins (approximate):",choices=c("5","10","20","40"),selected="5")
				}
			}
		}
	})
	
	output$histDensCurve <- renderUI({
		if(length(input$city)){
			if(!length(input$multiplot)){
				checkboxInput("hdc","Overlay density curve",FALSE)
			} else if(input$multiplot=="Separate histograms"|length(input$city)==1){
				checkboxInput("hdc","Overlay density curve",input$hdc)
			}
		}
	})
	
	output$histDensCurveBW <- renderUI({
		if(length(input$hdc)){
			if(!length(input$multiplot)){
				if(input$hdc) sliderInput("hdcBW","bandwidth:",0.2,2,1,0.2)
			} else {
				if(input$hdc & input$multiplot=="Separate histograms") sliderInput("hdcBW","bandwidth:",0.2,2,1,0.2)
			}
		}
	})
	
	output$histIndObs <- renderUI({
		if(length(input$city)){
			if(!length(input$multiplot)){
				checkboxInput("hio","Show individual observations",FALSE)
			} else if(input$multiplot=="Separate histograms"|length(input$city)==1){
				checkboxInput("hio","Show individual observations",input$hio)
			}
		}
	})
	
	output$multMo <- renderUI({
		if(length(input$mo)){
			if(input$mo=="Choose multiple"){
				checkboxGroupInput("mo2","Select consecutive months:",mos)
			}
		}
	})
	
	output$multMo2 <- renderUI({
		if(length(input$mo)){
			if(length(input$mo2)>1 & input$mo=="Choose multiple" & input$var=="Precipitation"){
				selectInput("stat","Choose seasonal statistic:",choices=c("None","Total","Std. Dev.","Minimum","Maximum"),selected="None")
			}
			else if(length(input$mo2)>1 & input$mo=="Choose multiple" & input$var=="Temperature"){
				selectInput("stat","Choose seasonal statistic:",choices=c("None","Mean","Std. Dev.","Minimum","Maximum"),selected="None")
			}
		}
	})
	
	output$multCity <- renderUI({
		if(length(input$city)>1){
			radioButtons("multiplot","Plot view for multiple cities:",c("Separate histograms","Common-axis density estimation plots"),"Separate histograms")
		}
	})
	
	output$dldat <- downloadHandler(
		filename = function() { paste(input$dat, '.csv', sep='') },
		content = function(file) {
			write.csv(dat(), file)
		}
	)
	
	htfun <- function(){
		n <- length(input$city)
		if(n>1) n <- n + n%%2
		ht1 <- 600
		if(length(input$multiplot)){
			if(n==1 | input$multiplot=="Common-axis density estimation plots") ht <- ht1 else if(input$multiplot=="Separate histograms") ht <- (n/2)*(ht1/2)
		} else { ht <- ht1 }
		ht
	}
	
	output$plot <- renderPlot({
		if(length(input$city) & !is.null(dat2())){
			if(input$mo!="Choose multiple") mo <- input$mo else mo <- input$mo2
			## Print as if selection implies consecutive months. Still need to ensure that months must actually be consecutive. Users can still leave gaps in selection.
			if(length(mo)>1) mo <- paste(mo[1],"-",mo[length(mo)])
			if(input$var=="Precipitation"){
				clr <- "#1E90FF" # "dodgerblue"
				xlabel <- expression("Observations"~(mm)~"")
			} else if(input$var=="Temperature") {
				clr <- "#FFA500" # "orange"
				xlabel <- expression("Observations"~(degree~C)~"")
			}
			units <- ""
			if(length(input$stat)>0){ if(input$stat!="None") units <- input$stat }
			n <- length(input$city)
			h.brks <- "Sturges"
			if(length(input$hb) & length(input$hbn)) if(input$hb) h.brks <- as.numeric(input$hbn)
			if(n==1){
				dat2.cities <- dat2()$City
				x <- as.numeric(as.matrix(subset(dat2(),dat2.cities==input$city,select=4)))
				if(!all(is.na(x))){
					hist(x,breaks=h.brks,main=gsub("  "," ",paste(input$yrs[1],"-",input$yrs[2],input$city,mo,units,input$var)),
						xlab=xlabel,col=clr,cex.main=1.3,cex.axis=1.3,cex.lab=1.3,prob=T)
					if(length(input$hio)) if(input$hio) rug(x)
					if(length(input$hdc)) if(input$hdc & length(input$hdcBW)) lines(density(na.omit(x),adjust=input$hdcBW),lwd=2)
				}
			} else if(!length(input$multiplot)){
				if(n>1) layout(matrix(1:(n+n%%2),ceiling(n/2),2,byrow=T))
				dat2.cities <- dat2()$City
				for(i in 1:n){
					x <- as.numeric(as.matrix(subset(dat2(),dat2.cities==input$city[i],select=4)))
					if(!all(is.na(x))){
						hist(x,breaks=h.brks,main=gsub("  "," ",paste(input$yrs[1],"-",input$yrs[2],input$city[i],mo,units,input$var)),
							xlab=xlabel,col=clr,cex.main=1.3,cex.axis=1.3,cex.lab=1.3,prob=T)
						if(length(input$hio)) if(input$hio) rug(x)
						if(length(input$hdc)) if(input$hdc & length(input$hdcBW)) lines(density(na.omit(x),adjust=input$hdcBW),lwd=2)
					}
				}
			} else if(length(input$multiplot)){
				if(n>1 & input$multiplot=="Separate histograms") layout(matrix(1:(n+n%%2),ceiling(n/2),2,byrow=T))
				if(input$multiplot=="Separate histograms"){
					dat2.cities <- dat2()$City
					for(i in 1:n){
						x <- as.numeric(as.matrix(subset(dat2(),dat2.cities==input$city[i],select=4)))
						if(!all(is.na(x))){
							hist(x,breaks=h.brks,main=gsub("  "," ",paste(input$yrs[1],"-",input$yrs[2],input$city[i],mo,units,input$var)),
								xlab=xlabel,col=clr,cex.main=1.3,cex.axis=1.3,cex.lab=1.3,prob=T)
							if(length(input$hio)) if(input$hio) rug(x)
							if(length(input$hdc)) if(input$hdc & length(input$hdcBW)) lines(density(na.omit(x),adjust=input$hdcBW),lwd=2)
						}
					}
				} else if(n>1 & input$multiplot=="Common-axis density estimation plots"){
					data <- dat()
					if(length(input$mo2)>1) if(length(input$stat)) if(input$stat!="None") data <- dat2()
					plot.multiDens(data,input$city,stat=input$stat,n.mo=length(input$mo2),main=gsub("  "," ",paste(input$yrs[1],"-",input$yrs[2],mo,units,input$var)),
						xlab=xlabel,cex.main=1.3,cex.axis=1.3,cex.lab=1.3)
				}
			}
		}
	},
	height=htfun
	)

	output$summary <- renderPrint({
		if(!is.null(dat())){
			x <- list(summary(dat()[-c(1:3)]))
			if(input$mo!="Choose multiple") mo <- input$mo else mo <- input$mo2
			if(length(mo)>1) mo <- paste(mo[1],"-",mo[length(mo)]) ## Still need to ensure that months must be consecutive.
			names(x) <- names.x <- paste(input$yrs[1],"-",input$yrs[2],mo,"City",input$var,"Data")
			if(length(input$stat)>0 & length(input$mo2)>1){
			if(input$stat!="None"){
				dat2.cities <- dat2()$City
				x2 <- c()
				for(i in 1:ncol(x[[1]])) x2 <- cbind(x2, as.numeric(as.matrix(subset(dat2(),dat2.cities==input$city[i],select=4))))
				x2 <- summary(x2)
				colnames(x2) <- colnames(x[[1]])
				x <- list(x[[1]],x2)
				names(x) <- c(names.x,paste("Distribution Summary of Seasonal",input$stat,input$var))
			}
			}
		x
		}
	})
	
	output$table <- renderTable({
		if(!is.null(dat())){
			dat()
		}
	})
	
	output$regInputX <- renderUI({
	if(length(input$city)){
		selectInput("regX","Explanatory variable(s)",c("Year","Precipitation","Temperature"),selected="Year")
	}
	})
	
	output$regInputY <- renderUI({
	if(length(input$city)){
		selectInput("regY","Response variable",c("Year","Precipitation","Temperature"),selected="Precipitation")
	}
	})
	
	output$regCondMo <- renderUI({
	if(length(input$city)){
		selectInput("regbymo","Select consecutive months:",c("All",mos),selected="All")
	}
	})
	
	reg.dat <- reactive({
	if(length(input$city) & length(input$yrs) & length(input$regbymo)){
		d <- list()
		for(i in 1:length(input$city)){
			d.tmp <- dcast(subset(DATASET(),Year>=input$yrs[1] & Year<=input$yrs[2],select=c(1:3,which(names(DATASET())==input$city[i]))),Year+Month ~Variable,value=input$city[i])
			names(d.tmp)[3:4] <- c("Precipitation","Temperature")
			if(length(input$regbymo)) if(input$regbymo!="All") d.tmp <- subset(d.tmp,d.tmp$Month==input$regbymo)
			d[[i]] <- d.tmp
		}
		d
	}
	})
		
	form <- reactive({
	if(length(input$city) & length(input$yrs) & length(input$regX) & length(input$regY) & length(input$regbymo)){
		form <- c()
		for(i in 1:length(input$city)) form <- c(form,paste(input$regY,"~",paste(input$regX,collapse="+")))
	} else form <- NULL
	form
	})
	
	lm1 <- reactive({
	if(length(input$city) & length(input$regY) & length(input$regX) & length(input$yrs) & length(input$regbymo) & !is.null(form())){
		lm.list <- list()
		for(i in 1:length(input$city)) lm.list[[i]] <- lm(formula=as.formula(form()[i]),data=reg.dat()[[i]])
		names(lm.list) <- paste(input$city,form())
		lm.list
	}
	})
	
	output$reglines <- renderUI({
	if(length(input$city) & length(input$regY) & length(input$regX)){
		checkboxInput("reglns","Show time series line(s)",FALSE)
	}
	})
	
	output$regpoints <- renderUI({
	if(length(input$city) & length(input$regY) & length(input$regX)){
		checkboxInput("regpts","Show points",TRUE)
	}
	})
	
	output$regablines <- renderUI({
	if(length(input$city) & length(input$regY) & length(input$regX)){
		checkboxInput("regablns","Show regression line(s)",FALSE)
	}
	})
	
	output$regGGPLOT <- renderUI({
	if(length(input$city) & length(input$regY) & length(input$regX)){
		checkboxInput("reg.ggplot","Switch to ggplot version",FALSE)
	}
	})
	
	output$regGGPLOTse <- renderUI({
	if(length(input$city) & length(input$regY) & length(input$regX) & length(input$regablns)){
		if(input$regablns) checkboxInput("reg.ggplot.se","Show shaded confidence band for mean response",FALSE)
	}
	})
	
	output$regplot <- renderPlot({
	if(length(input$city) & length(input$regY) & length(input$regX) & length(input$reglns) & length(input$yrs) & length(reg.dat())){
		ylm <- do.call(range,lapply(reg.dat(),function(x) range(x[[input$regY]],na.rm=T)))
		alpha <- 70
		x <- reg.dat()[[1]][[input$regX]]
		n <- length(x)
		xr <- range(x)
		if(input$regX=="Year") x <- seq(xr[1],xr[2],len=n)
		y <- reg.dat()[[1]][[input$regY]]
		yr <- range(y)
		if(input$regY=="Year") y <- seq(yr[1],yr[2],len=n)
		if(!input$reg.ggplot){
		plot(0,0,type="n",xlim=range(x),ylim=ylm,xlab=input$regX,ylab=input$regY,main=form()[1],cex.main=1.3,cex.axis=1.3,cex.lab=1.3)
		for(i in 1:length(input$city)){
			if(input$regX!="Year") x <- reg.dat()[[i]][[input$regX]]
			if(input$regY!="Year") y <- reg.dat()[[i]][[input$regY]]
			if(length(input$reg.ggplot.se)) {
				if(input$reg.ggplot.se){
					d1 <- data.frame(x,y)
					names(d1) <- c(input$regX,input$regY)
					pred <- predict(lm1()[[i]],d1,interval="confidence")
					CIL <- pred[,'lwr']
					CIU <- pred[,'upr']
					ord <- order(d1[,1])
					xvec <- c(d1[ord,1],tail(d1[ord,1],1),rev(d1[ord,1]),d1[ord,1][1])
					yvec <- c(CIL[ord],tail(CIU[ord],1),rev(CIU[ord]),CIL[ord][1])
					polygon(xvec,yvec,col="#00000070",border=NA)
				}
			}
			if(input$reglns) lines(x[order(x)],y[order(x)], lty=1, lwd=1, col=paste(clrs[i],alpha,sep=""))
			if(input$regpts) points(x,y, pch=21, col=1, bg=paste(clrs[i],alpha,sep=""), cex=1)
			if(input$regablns) abline(lm1()[[i]],col=clrs[i],lwd=2)
		}
		}
		if(input$reg.ggplot){
			if(input$regX=="Year") x <- rep(x,length(input$city)) else x <- c()
			if(input$regY=="Year") y <- rep(y,length(input$city)) else y <- c()
			for(i in 1:length(input$city)){
				if(input$regX!="Year") x <- c(x, reg.dat()[[i]][[input$regX]])
				if(input$regY!="Year") y <- c(y, reg.dat()[[i]][[input$regY]])
			}
			cond <- rep(input$city,each=n)
			d2 <- data.frame(cond,x,y)
			names(d2) <- c("City",input$regX,input$regY)
			p <- ggplot(d2, aes_string(x=input$regX, y=input$regY, color="City")) +
				scale_colour_hue(l=50) # Use a darker palette
			if(input$regablns){
				if(length(input$reg.ggplot.se)) SE <- input$reg.ggplot.se else SE <- F
				p <- p +
				geom_smooth(method=lm,   # Add linear regression lines
				se=SE,    # Don't add shaded confidence region
				fullrange=T)
			}
			if(input$reglns) p <- p + geom_line(shape=1)
			if(input$regpts) p <- p + geom_point(shape=1)
			print(p)
		}
	}
	}
	)
	
	output$regsum <- renderPrint({
	if(length(input$city) & length(input$regY) & length(input$regX) & !is.null(form())){
		lapply(lm1(),summary)
	}
	})
	
	#output$map <- reactive({
	#	if(input$showmap){
	#		selected <- map.dat()
	#		sites<-gvisMap(selected,locationvar="latlon",tipvar="City", options=list(useMapTypeControl=T))
	#		plot(sites)
	#	}
	#})
	
	output$header <- renderUI({
		if(input$dataset=="Weather stations (CRU-substituted NAs)" | input$dataset=="Weather stations (w/ missing data)"){
			txt <- paste("Weather station historical time series climate data for",length(city.names()),"AK cities")
		} else if(input$dataset=="2-km downscaled CRU 3.1"){
			txt <- paste("2-km downscaled CRU 3.1 historical time series climate data for",length(city.names()),"AK cities")
		}
		txt <- HTML(paste('<div id="stats_header">',txt,
			'<a href="http://snap.uaf.edu" target="_blank">
			<img id="stats_logo" align="right" alt="SNAP Logo" src="./img/snap_sidebyside.png" />
			</a>
			</div>',sep="",collapse=""))
	})
	
	output$datname <- renderPrint({ # this is used for lazy debugging by printing specific information to the headerPanel
		x <- "cru31"
		#x<-length(input$city) & length(input$yrs) & length(input$regbymo)
		x
	})
})
