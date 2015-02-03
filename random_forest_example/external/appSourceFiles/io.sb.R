# well panel 1: Datasets, variables
#output$dat.name <- renderUI({
#	selectInput("dat.name","Data:",choices=c("Flags"),selected="Flags")
#})

output$response <- renderUI({
	if(!is.null(dat()))	selectInput("response","Response variable:",varnamesfactors(),selected=varnamesfactors()[1])
})

output$explanatory <- renderUI({
	if(!is.null(input$selectDeselect)){
		if(input$selectDeselect %% 2 == 0){
			selectInput("explanatory","Explanatory variables:",explanatoryvars(),selected=explanatoryvars(),multiple=T)
		} else {
			selectInput("explanatory","Explanatory variables:",explanatoryvars(),selected=NULL,multiple=T)
		}
	}
})

output$selectDeselect <- renderUI({
	if(!is.null(dat())){
		actionButton("selectDeselect", "Select/Deselect all", class="btn-block btn-success")
	}
})

# well panel 2: Random Forest meta-parameters
output$ntrees <- renderUI({
	sliderInput("ntrees","Number of trees",100,500,100,100)
})

output$goButton <- renderUI({
	if(!is.null(dat())){
		actionButton("goButton", "Build RF model", class="btn-block btn-success")
	}
})

