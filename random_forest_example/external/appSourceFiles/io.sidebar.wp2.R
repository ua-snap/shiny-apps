# Random Forest meta-parameters
output$ntrees <- renderUI({
	sliderInput("ntrees","Number of trees",100,500,100,100)
})

output$goButton <- renderUI({
	if(!is.null(dat())){
		actionButton("goButton", "Build RF model")
	}
})
