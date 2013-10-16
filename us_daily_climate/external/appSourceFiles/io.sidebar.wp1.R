# Datasets, variables
output$minYrRange <- renderUI({
	sliderInput("minYrRange","Minimum station coverage:",yr.min,yr.max,c(yr.max-29,yr.max),step=1,format="#")
})

output$state <- renderUI({
	selectInput("state","State:",choices=state.abb,selected=state.abb[1])
})

output$station <- renderUI({
	if(!is.null(input$state)) selectInput("station","Weather station:",choices=stations.name(),selected=stations.name()[1])
})

output$yrs <- renderUI({
	if(!is.null(yrs())) sliderInput("yrs","Selected years:",yrs()[1],tail(yrs(),1),range(yrs()),step=1,format="#")
})

output$mo <- renderUI({
	selectInput("mo","Center graphic on month:",choices=month.abb,selected=month.abb[7])
})

output$ph1 <- renderUI({
		selectInput("ph1","Placeholder 1:",choices=c("x","y"),selected="x")
})

output$var <- renderUI({
	selectInput("var","Variable:",choices=vars,selected=vars[1])
})

output$ph2 <- renderUI({
	selectInput("ph2","Placeholder2:",choices=c("x","y"),selected="x")
})

output$ph3 <- renderUI({
	selectInput("ph3","Placeholder 3:",choices=c("x","y"),selected="x")
})

output$dailyColPal <- renderUI({
	selectInput("dailyColPal","Color theme:",palettes,palettes[1])
})

#output$getDataButton <- renderUI({
#	actionButton("getDataButton", "Import Dataset")
#})

#output$genPlotButton <- renderUI({
#	actionButton("genPlotButton", "Generate Plot")
#})
