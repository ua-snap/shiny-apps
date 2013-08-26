# Datasets, variables
suffix <- reactive({
	if(!is.null(input$coast)){
		if(input$coast=="Full sea") x <- "" else if(input$coast=="Coastal only") x <- ".c"
	} else x <- NULL
	x
})

ice.dat <- reactive({
	if(!is.null(suffix())){
		x <- subset(get(paste0("i.",tolower(input$sea),suffix())), Year>=input$yrs[1] & Year<as.numeric(tail(input$yrs,1))+10, c("Year",input$mo))
	} else x <- NULL
	x
})

wind.dat <- reactive({
	if(!is.null(suffix())){
		if(input$var!="Wind") v <- as.numeric(input$cut) else v <- abs(as.numeric(input$cut))
		x <- subset(get(paste0("w.",tolower(input$sea),".",input$mod,suffix())), Year>=input$yrs[1] & Year<as.numeric(tail(input$yrs,1))+10 & Month==input$mo & RCP==input$rcp & Var==input$var & Cut==v, c("Year","Freq"))
	} else x <- NULL
	x
})

dpm.tmp <- reactive({
	if(!is.null(wind.dat())){
		x <- rep(dpm[which(month.abb==input$mo)],nrow(wind.dat()))
		if(input$mo=="Feb") x[wind.dat()$Year %in% seq(1960,2099,4)] <- 29
	} else x <- NULL
	x
})

i.prop.yrs <- reactive({
	x <- NULL
	if(!is.null(ice.dat())){
		x <- ice.dat()
		names(x)[2] <- "Con"
		x$Con <- x$Con/100
	}
	x
})

i.prop.dec <- reactive({
	y <- NULL
	if(!is.null(i.prop.yrs())){
		x <- i.prop.yrs()
		y <- tapply(x$Con,substr(x$Year,1,3),mean)
		y <- data.frame(Year=10*as.numeric(names(y)), Con=as.numeric(y))
	}
	y
})

w.prop.yrs <- reactive({
	x <- NULL
	if(!is.null(wind.dat())){
		x <- wind.dat()
		x$Freq <- if(input$direction=="Above") x$Freq/dpm.tmp() else if(input$direction=="Below") 1-x$Freq/dpm.tmp()
	}
	x
})

w.prop.dec <- reactive({
	y <- NULL
	if(!is.null(w.prop.yrs())){
		x <- w.prop.yrs()
		y <- tapply(x$Freq,substr(x$Year,1,3),mean)
		y <- data.frame(Year=10*as.numeric(names(y)), Freq=as.numeric(y))
	}
	y
})
