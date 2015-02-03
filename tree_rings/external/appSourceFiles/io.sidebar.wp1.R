# Datasets, variables
output$dataset <- renderUI({
	if(!is.null(datasets())) selectInput("dataset","Dataset:", choices=datasets(), selected=datasets()[1], width="100%")
})
