# Datasets, variables, units, models, scenarios, months, decades
output$dat.name <- renderUI({
	selectInput("dat.name","Data:",choices=c("CMIP3 Historical","CMIP3 Projected"),selected="CMIP3 Projected")
})

output$vars <- renderUI({
	if(!is.null(dat()))	selectInput("vars","Climate variable:",varnames,selected=NULL)
})

output$units <- renderUI({
	if(!is.null(dat())){
		if(length(input$vars)){
			if(input$vars=="Temperature") selectInput("units","Units:",c("C","F"),selected="C") else selectInput("units","Units:",c("mm","in"),selected="mm")
		}
	}
})

output$models <- renderUI({
	if(!is.null(dat()))	selectInput("models","Climate models:",choices=modnames,selected=modnames[1],multiple=T)
})

output$scens <- renderUI({
	if(!is.null(dat()))	selectInput("scens","Emissions scenarios:",choices=scennames(),selected=scennames()[1],multiple=T)
})

output$mos <- renderUI({
	if(!is.null(dat()))	selectInput("mos","Months:",choices=mos,selected=mos[1],multiple=T)
})

output$decs <- renderUI({
	if(!is.null(dat()))	selectInput("decs","Decades:",choices=decades(),selected=decades()[1],multiple=T)
})
