# Datasets, variables
output$email <- renderUI({
	textInput("email","Enter email address:")
})

output$dataset <- renderUI({
	selectInput("dataset","Select dataset:",datasets,datasets[1])
})

output$FIF_Files <- renderUI({
	selectInput("fif_files", "Select .fif(s):", fif_files, fif_files[1])
})

output$goButton <- renderUI({
	if(!is.null(input$email)) actionButton("goButton","Make system call")
})

output$sysCall <- renderUI({
	sysCall()
})

output$WelcomeTitle <- renderUI({ "Welcome to the Alfresco web GUI" })

output$WelcomeSubtitle <- renderUI({ "Powered by R and Shiny" })
