# Datasets, variables
output$loc <- renderUI({
	selectInput("loc","Location:",choices="Fairbanks, AK",selected="Fairbanks, AK")
})

output$yrs <- renderUI({
	sliderInput("yrs","",years[1],tail(years,1),range(years),step=1,format="#")
})

output$mo <- renderUI({
	selectInput("mo","1st month of precipitation year:",choices=month.abb,selected=month.abb[7])
})

output$ph1 <- renderUI({
		selectInput("ph1","Placeholder 1:",choices=c("x","y"),selected="x")
})

output$var <- renderUI({
		selectInput("var","Variable:",choices=vars,selected=vars[1])
})

output$ph2 <- renderUI({
	selectInput("ph2","Placeholder2:",choices=c("x","y"),selected="x")
})

output$ph3 <- renderUI({
	selectInput("ph3","Placeholder 3:",choices=c("x","y"),selected="x")
})

output$dailyColPal <- renderUI({
	selectInput("dailyColPal","Color theme:",palettes,palettes[1])
})
