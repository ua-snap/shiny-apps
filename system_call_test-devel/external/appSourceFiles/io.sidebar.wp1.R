# Datasets, variables
output$UserEmail <- renderUI({
	textInput("useremail","Your email:")
})

output$AddEmail <- renderUI({
	textInput("addemail","Also send results to:",value="mfleonawicz@alaska.edu")
})

output$FIF_Files <- renderUI({
	selectInput("fif_files", "Select FIF:", fif_files, fif_files[1])
})

output$WelcomeTitle <- renderUI({ "Welcome to the Alfresco web GUI" })

output$WelcomeSubtitle <- renderUI({ "Powered by R and Shiny" })
