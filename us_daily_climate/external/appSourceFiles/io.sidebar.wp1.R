# Datasets, variables
output$state <- renderUI({
	selectInput("state","State:",choices=states.abb,selected=states.abb[1])
})

output$station <- renderUI({
	selectInput("station","Weather station:",choices=stations.name(),selected=stations.name()[1])
})

output$yrs <- renderUI({
	if(!is.null(yrs())) sliderInput("yrs","",yrs()[1],tail(yrs(),1),range(yrs()),step=1,format="#")
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

output$genPlotButton <- renderUI({
	actionButton("genPlotButton", "Generate Plot")
})
