# Datasets, variables, units, models, scenarios, months, decades
output$vars <- renderUI({
	if(!is.null(dat()))	selectInput("vars", "Climate variable:", c("",varnames), selected="", width="100%")
})

output$units <- renderUI({
	if(!is.null(dat())){
		if(length(input$vars)){
			if(input$vars=="Temperature") selectInput("units", "Units:", c("C","F"), selected="C", width="100%") else selectInput("units", "Units:",c("mm","in") ,selected="mm", width="100%")
		}
	}
})

output$models <- renderUI({
	if(!is.null(dat()))	selectInput("models", "Climate models:", choices=c("",modnames), selected="", multiple=T, width="100%")
})

output$scens <- renderUI({
	if(!is.null(dat()) & !is.null(scennames()))	selectInput("scens", "Emissions scenarios:", choices=c("", scennames()), selected="", multiple=T, width="100%")
})

output$mos <- renderUI({
	if(!is.null(dat()))	selectInput("mos", "Months:", choices=c("",mos), selected="", multiple=T, width="100%")
})

output$decs <- renderUI({
	if(!is.null(dat()) & !is.null(decades()))	selectInput("decs", "Decades:", choices=c("",decades()), selected="", multiple=T, width="100%")
})

# Data button
output$GoButton <- renderUI({
	if(permitPlot()) actionButton("goButton", "Subset Data", class="btn-block btn-info")
})
