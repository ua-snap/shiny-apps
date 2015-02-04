# TabPanel titles
output$TpDailyTitle <- renderUI({
	input$genPlotButton
	isolate({
		if(is.null(input$genPlotButton) || input$genPlotButton==0) h5("Select location. Generate plot. Data download/plot may take several seconds.") else h4(paste(input$loc,"daily precipitation"))
	})
})
