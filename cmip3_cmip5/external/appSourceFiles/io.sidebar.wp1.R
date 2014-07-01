# Data button
output$GoButton <- renderUI({
	if(permitPlot()) actionButton("goButton", "Subset Data")
})
