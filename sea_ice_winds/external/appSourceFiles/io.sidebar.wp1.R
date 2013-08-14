# Datasets, variables
output$yrs <- renderUI({
	sliderInput("yrs","",decades[1],tail(decades,1),range(decades),step=10,format="#")
})

output$mo <- renderUI({
	selectInput("mo","Month:",choices=month.abb,selected=month.abb[1])
})

output$rcp <- renderUI({
		selectInput("rcp","RCP:",choices=c("RCP 6.0","RCP 8.5"),selected="RCP 6.0")
})

output$var <- renderUI({
		selectInput("var","Variable:",choices=varlevels,selected=varlevels[3])
})

output$cut <- renderUI({
	selectInput("cut","Threshold:",choices=cuts,selected=cuts[1])
})

output$sea <- renderUI({
	selectInput("sea","Sea:",choices=seas,selected=seas[1])
})

output$coast <- renderUI({
	radioButtons("coast","Area:",choices=c("Full sea","Coastal only"),selected="Full sea")
})
