# Datasets, variables
output$Loc <- renderUI({
	selectInput("loc","Location:",choices=c("", paste0(loc.names,", AK")),selected="")
})

output$Yrs <- renderUI({
	if(!is.null(yrs())){
		div(
			sliderInput("yrs","Data download on location change. Please wait when grayed.",yrs()[1],tail(yrs(),1),range(yrs()),step=1,format="#"),
			tags$head(tags$link(rel="stylesheet", type="text/css", href="jquery.slider.min.css"))
		)
	}
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
	if(!is.null(input$loc) && input$loc!="") actionButton("genPlotButton", "Generate Plot")
})
