# Datasets, variables
output$Yrs <- renderUI({
	if(!is.null(yrs())){
		sliderInput("yrs", "Data download on location change. Please wait when grayed.", yrs()[1], tail(yrs(),1), range(yrs()), step=1, sep="", width="100%")
	}
})

output$GenPlotButton <- renderUI({
	if(!is.null(input$loc) && input$loc!="") actionButton("genPlotButton", "Generate Plot", class="btn-block btn-primary")
})
