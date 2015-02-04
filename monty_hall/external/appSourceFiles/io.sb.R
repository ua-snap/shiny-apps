# Datasets, variables
output$totaldoors <- renderUI({
	if(!is.null(totaldoors())) selectInput("totaldoors","Total number of doors:",choices=totaldoors(),selected=totaldoors()[1])
})
