# Datasets, variables
output$email <- renderUI({
	textInput("email","Enter email address:")
})

output$dataset <- renderUI({
	selectInput("dataset","Select dataset:",datasets,datasets[1])
})

output$goButton <- renderUI({
	if(!is.null(input$email)) actionButton("goButton","Make system call")
})

output$sysCall <- renderUI({
	sysCall()
})
