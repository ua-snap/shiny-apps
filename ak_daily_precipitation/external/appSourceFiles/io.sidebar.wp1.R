# Datasets, variables
output$Loc <- renderUI({
	selectInput("loc","Location:",choices=paste0(loc.names,", AK"),selected=paste0(loc.names[1],", AK"))
})

output$Yrs <- renderUI({
	if(!is.null(yrs())) sliderInput("yrs","",yrs()[1],tail(yrs(),1),range(yrs()),step=1,format="#")
})

output$Mo <- renderUI({
	selectInput("mo","Center graphic on month:",choices=month.abb,selected=month.abb[7])
})

output$Var <- renderUI({
		selectInput("var","Variable:",choices=vars,selected=vars[1])
})

output$DailyColPal <- renderUI({
	selectInput("dailyColPal","Color theme:",palettes,palettes[1])
})

output$GenPlotButton <- renderUI({
	actionButton("genPlotButton", "Generate Plot")
})
