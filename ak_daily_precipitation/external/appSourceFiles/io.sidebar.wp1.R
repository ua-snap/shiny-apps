# Datasets, variables
output$Yrs <- renderUI({
	if(!is.null(yrs())){
		div(
			sliderInput("yrs", "Data download on location change. Please wait when grayed.", yrs()[1], tail(yrs(),1), range(yrs()), step=1, format="#", width="100%"),
			tags$head(tags$link(rel="stylesheet", type="text/css", href="jquery.slider.min.css"))
		)
	}
})

output$GenPlotButton <- renderUI({
	if(!is.null(input$loc) && input$loc!="") actionButton("genPlotButton", "Generate Plot")
})
