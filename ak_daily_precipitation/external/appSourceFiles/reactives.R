# Datasets, variables
d.all <- reactive({
	if(!is.null(input$loc)){
		d <- get(gsub(", AK","",input$loc))
		d <- subset(d,Year>=1950)
		yr1 <- unique(d$Year)[1]
		if(length(which(d$Year==yr1)) < 365) d <- subset(d,Year > yr1)
	} else d <- NULL
	d
})

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
