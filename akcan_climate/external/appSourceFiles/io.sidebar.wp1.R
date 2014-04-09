# Datasets, variables, units, models, scenarios, months, decades
output$dat.name <- renderUI({
	selectInput("dat.name","Data:",choices=c("","CMIP3 Historical","CMIP3 Projected"),selected="")
})

output$vars <- renderUI({
	if(!is.null(dat()))	selectInput("vars","Climate variable:",c("",varnames),selected="")
})

output$units <- renderUI({
	if(!is.null(dat())){
		if(length(input$vars)){
			if(input$vars=="Temperature") selectInput("units","Units:",c("C","F"),selected="C") else selectInput("units","Units:",c("mm","in"),selected="mm")
		}
	}
})

output$models <- renderUI({
	if(!is.null(dat()))	selectInput("models","Climate models:",choices=c("",modnames),selected="",multiple=T)
})

output$scens <- renderUI({
	if(!is.null(dat()) & !is.null(scennames()))	selectInput("scens","Emissions scenarios:",choices=c("",scennames()),selected="",multiple=T)
})

output$mos <- renderUI({
	if(!is.null(dat()))	selectInput("mos","Months:",choices=c("",mos),selected="",multiple=T)
})

output$decs <- renderUI({
	if(!is.null(dat()) & !is.null(decades()))	selectInput("decs","Decades:",choices=c("",decades()),selected="",multiple=T)
})

# Data button
output$GoButton <- renderUI({
	if(permitPlot()) actionButton("goButton", "Subset Data")
})
