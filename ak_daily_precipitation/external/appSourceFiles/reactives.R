# Datasets, variables
url.string <- reactive({
	if(!is.null(input$loc)){
		x <- paste0("http://","data.rcc-acis.org/StnData?sid=",ID[gsub(", AK","",input$loc)],"&sdate=1950-01-01&edate=",Sys.Date()-1,"&elems=4&output=csv") # "&elems=1,2,43,4,10,11&output=csv"
		print(x)
	} else x <- NULL
	x
})

d.all <- reactive({
	if(is.null(input$loc) || input$loc=="") return()
	d <- NULL
	isolate(
		if(!is.null(url.string())){
			d <- read.csv(url.string(),header=F,skip=1)
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
					d[,i][d[,i]=="T"] <- "0" # "trace amounts" set to zero
					d[,i] <- as.numeric(d[,i]) # allow coercion to NA, treat any non-coercible value as missing (most of them are)
				}
			}
		} else d <- NULL
	)
	d
})

d <- reactive({
	print(is.null(input$yrs) || is.null(d.all()))
	if(is.null(input$yrs) || is.null(d.all())) return()
	x <- NULL
	isolate(
		x <- subset(d.all(), Year>=input$yrs[1] & Year<=tail(input$yrs,1))
	)
	print(class(x))
	x
})

yrs <- reactive({
	if(!is.null(d.all()) && nrow(d.all())>0) unique(d.all()$Year) else NULL
})

colPal <- reactive({
	if(!is.null(input$dailyColPal)){
		if(input$dailyColPal=="WtYlGn") x <- c("white","yellow","green")
		if(input$dailyColPal=="OrgBl") x <- c("orange","blue")
		if(input$dailyColPal=="WtOrRd") x <- c("white","orange","orangered")
		if(input$dailyColPal=="BlPr") x <- c("deepskyblue","purple")
		if(input$dailyColPal=="BnGn") x <- c("chocolate4","chocolate","chartreuse4","darkgreen")
		if(input$dailyColPal=="WtBl") x <- c("white","dodgerblue")
	} else x <- NULL
	x
})

# Adjust between simple version of app and more complex version
plotMarginal <- reactive({ if(is.null(input$meanHistorical)) T else input$meanHistorical })
plotBars <- reactive({ if(is.null(input$bars6mo)) T else input$bars6mo })
plotMeanBars <- reactive({ if(is.null(input$mean6mo)) T else input$mean6mo })
cex.exp <- reactive({ if(is.null(input$tfCirCexMult)) 7 else as.numeric(input$tfCirCexMult) })
ht.compression <- reactive({ if(is.null(input$htCompress)) 1.5 else as.numeric(input$htCompress) })
