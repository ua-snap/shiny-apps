# Datasets, variables
d <- reactive({
	if(!is.null(input$yrs) & !is.null(input$loc)){
		x <- subset(dat, Year>=input$yrs[1] & Year<=tail(input$yrs,1)) # locations (loc) currently not in use(Fairbanks only)
	} else x <- NULL
	x
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
