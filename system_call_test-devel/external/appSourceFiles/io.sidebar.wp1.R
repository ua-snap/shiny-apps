# Datasets, variables
output$UserEmail <- renderUI({
	textInput("useremail","Your email:")
})

output$AddEmail <- renderUI({
	textInput("addemail","Also send results to:",value="mfleonawicz@alaska.edu")
})

#output$FIF_Files <- renderUI({
#	selectInput("fif_files", "Select FIF:", fif_files, fif_files[1])
#})

output$JSON_Files <- renderUI({
	selectInput("json_files", "Select JSON:", c("", JSON_files), "")
})

output$WelcomeTitle <- renderUI({ "Welcome to the Alfresco web GUI" })

output$WelcomeSubtitle <- renderUI({ "Powered by R and Shiny" })

output$Year_Start <- renderUI({ textInput("year_start", "Start year:", value="1901") })

output$Year_End <- renderUI({ textInput("year_end", "End year:", value="2012") })
