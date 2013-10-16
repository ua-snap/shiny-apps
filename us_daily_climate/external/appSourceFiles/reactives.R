# Datasets, variables
stations.sub <- reactive({
	if(!is.null(input$state)){
		x <- subset( metadata, State==input$state & startdate.yr<=input$minYrRange[1] & (enddate.yr>=input$minYrRange[2] | enddate.yr>=2013) ) # 10/6/2013 is the time of the last metadata station "enddate" download/prep
	} else x <- NULL
	x
})

stations.id <- reactive({
	if(!is.null(stations.sub())){
		x <- as.character(stations.sub()$ID)
	} else x <- NULL
	x
})

stations.name <- reactive({
	if(!is.null(stations.sub())){
		x <- as.character(stations.sub()$Station)
	} else x <- NULL
	x
})

ID <- reactive({
	if(!is.null(input$station)){
		x <- stations.id()[stations.name()==input$station]
	} else x <- NULL
	x
})

startdate <- reactive({
	if(!is.null(ID())){
		x <- as.Date(metadata$Start)[metadata$ID==ID()][1]
	} else x <- NULL
	x
})

enddate <- reactive({
	if(!is.null(ID())){
		x <- as.Date(metadata$End)[metadata$ID==ID()][1]
	} else x <- NULL
	x
})

url.string <- reactive({
	if(!is.null(startdate()) & !is.null(enddate())){
		x <- paste0("http://","data.rcc-acis.org/StnData?sid=",ID(),"&sdate=",max(startdate(),paste0(input$minYrRange[1],"-01-01")),"&edate=",min(enddate(),Sys.Date()-1),"&elems=4&output=csv") # "&elems=1,2,43,4,10,11&output=csv"
	} else x <- NULL
	x
})

d.all <- reactive({
	if(!is.null(url.string())){
		d <- read.csv(url.string(),header=F,skip=1)
		print(head(d))
		x <- t(sapply(strsplit(as.character(d[,1]),"-"),as.numeric))
		d <- data.frame(x,d[-1])
		names(d) <- c("Year","Month","Day","P_in") # "MinT","MaxT","AvgT","P_in","SnowF","SnowD"
		yr1 <- d$Year[which(d$P_in!="M")[1]]
		if(is.na(yr1)){
			d <- NULL
		} else {
			d <- subset(d,Year>=yr1)
			for(i in 4:ncol(d)){
				d[,i] <- as.character(d[,i])
				d[,i][d[,i]=="T"] <- "0"
				d[,i] <- as.numeric(d[,i]) # allow coercion to NA, treat any non-coercible value as missing (most of them are)
			}
		}
	} else d <- NULL
	#for(i in 1:length(unique(d$Year))) print(paste(unique(d$Year)[i],length(d$Year[d$Year==unique(d$Year)[i]])))
	#print(d$P_in[d$Year==1952])
	d
})

#d.all <- reactive({
#	if(!is.null(input$loc)){
#		d <- get(gsub(", AK","",input$loc))
#		d <- subset(d,Year>=1950)
#		yr1 <- unique(d$Year)[1]
#		if(length(which(d$Year==yr1)) < 365) d <- subset(d,Year > yr1)
#	} else d <- NULL
#	d
#})

d <- reactive({
	input$genPlotButton
	x <- NULL
	isolate({
		if(!is.null(d.all()) & !is.null(input$yrs)){
			x <- subset(d.all(), Year>=input$yrs[1] & Year<=tail(input$yrs,1)) # locations (loc) currently not in use(Fairbanks only)
		} else x <- NULL
	})
	x
})

yrs <- reactive({
	if(!is.null(d.all())) unique(d.all()$Year) else NULL
})

colPal <- reactive({
	if(!is.null(input$dailyColPal)){
		if(input$dailyColPal=="Wt-Yl-Gn") x <- c("white","yellow","green")
		if(input$dailyColPal=="Orange-Blue") x <- c("orange","blue")
		if(input$dailyColPal=="Wt-OrRd") x <- c("white","orange","orangered")
		if(input$dailyColPal=="LightBlue-Purple") x <- c("deepskyblue","purple")
		if(input$dailyColPal=="Brown-DkGn") x <- c("chocolate4","chocolate","chartreuse4","darkgreen")
		if(input$dailyColPal=="Wt-MdBlue") x <- c("white","dodgerblue")
	} else x <- NULL
	x
})

# Adjust between simple version of app and more complex version
plotMarginal <- reactive({ if(is.null(input$meanHistorical)) T else input$meanHistorical })
plotBars <- reactive({ if(is.null(input$bars6mo)) T else input$bars6mo })
plotMeanBars <- reactive({ if(is.null(input$mean6mo)) T else input$mean6mo })
cex.exp <- reactive({ if(is.null(input$tfCirCexMult)) 7 else as.numeric(input$tfCirCexMult) })
ht.compression <- reactive({ if(is.null(input$htCompress)) 1.5 else as.numeric(input$htCompress) })
