# TabPanel titles
output$TpDailyTitle <- renderUI({
	input$genPlotButton
	isolate({
		if(is.null(d())) h4("New plots may take several seconds to generate") else h4(paste(input$loc,"daily precipitation"))
	})
})
