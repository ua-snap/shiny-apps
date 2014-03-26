# Datasets, variables
output$yrs <- renderUI({
	selectInput("yrs","Decades:",choices=dec.lab,selected=dec.lab,multiple=T,selectize=F)
})

output$mo <- renderUI({
	selectInput("mo","Month:",choices=month.abb,selected=month.abb[1])
})

output$mod <- renderUI({
		selectInput("mod","Winds model:",choices=models,selected=models[1])
})

output$rcp <- renderUI({
		selectInput("rcp","Winds RCP:",choices=c("RCP 6.0","RCP 8.5"),selected="RCP 6.0")
})

output$var <- renderUI({
		selectInput("var","Variable:",choices=varlevels,selected=varlevels[3])
})

output$cut <- renderUI({
	selectInput("cut","Threshold (m/s):",choices=cuts,selected=cuts[1])
})

output$direction <- renderUI({
	selectInput("direction","Above/below threshold:",choices=c("Above","Below"),selected="Above")
})

output$sea <- renderUI({
	selectInput("sea","Sea:",choices=seas,selected=seas[1])
})

output$coast <- renderUI({
	radioButtons("coast","Area:",choices=c("Coastal only","Full sea"),selected="Coastal only")
})
