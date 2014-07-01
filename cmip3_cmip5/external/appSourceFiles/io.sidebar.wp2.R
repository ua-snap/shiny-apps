# x-axis variable (TS plot), x/y axes variables (scatter plot), grouping variable, faceting variable
output$Xtime <- renderUI({
	#selectInput("xtime", paste(input$vars,"by:"), choices=c("Month", "Year", "Decade"), selected="Month")
	selectInput("xtime", "X-axis (time)", choices=c("Month", "Year", "Decade"), selected="Month", width="100%")
})

output$Group <- renderUI({
	if(!is.null(group.choices())) selectInput("group", "Group/color by:", choices=group.choices(), selected=group.choices()[1], width="100%")
})

output$Facet <- renderUI({
	if(!is.null(facet.choices())) selectInput("facet","Facet/panel by:", choices=facet.choices(), selected=facet.choices()[1], width="100%")
})

output$Subjects <- renderUI({
	if(!is.null(subjectChoices())) selectInput("subjects", "Subject/Within-group lines:", choices=subjectChoices(), selected=subjectChoices()[1], width="100%")
})

output$XY <- renderUI({
	selectInput("xy", "X & Y axes", choices=c("P ~ T", "T ~ P"), selected="P ~ T", width="100%")
})

output$Group2 <- renderUI({
	if(!is.null(group.choices2())) selectInput("group2", "Group/color by:", choices=group.choices2(), selected=group.choices2()[1], width="100%")
})

output$Facet2 <- renderUI({
	if(!is.null(facet.choices2())) selectInput("facet2","Facet/panel by:", choices=facet.choices2(), selected=facet.choices2()[1], width="100%")
})

output$Xvar <- renderUI({
	if(!is.null(xvarChoices())) selectInput("xvar", "Primary axis:", choices=xvarChoices(), selected=xvarChoices()[1], width="100%")
})

output$Group3 <- renderUI({
	if(!is.null(group.choices3())) selectInput("group3", "Group/color by:", choices=group.choices3(), selected=group.choices3()[1], width="100%")
})

output$Facet3 <- renderUI({
	if(!is.null(facet.choices3())) selectInput("facet3","Facet/panel by:", choices=facet.choices3(), selected=facet.choices3()[1], width="100%")
})

output$Subjects3 <- renderUI({
	x <- NULL
	if(!is.null(subjectChoices3())){
		x <- selectInput("subjects3", "Subject/Within-group lines:", choices=subjectChoices3(), selected=subjectChoices3()[1], width="100%")
	#	if(!is.null(input$boxplots) && input$boxplots!="") x <- NULL
	}
	x
})

# Options for jittering, faceting, and pooling
output$VertFacet <- renderUI({
	if(!is.null(facet.panels())) if(facet.panels()>1) checkboxInput("vert.facet", "Vertical facet", value=FALSE)
})

output$PooledVar <- renderUI({
	if(length(pooled.var())) HTML(paste('<div>Pooled variable(s): ', paste(pooled.var(), collapse=", "), '</div>', sep=""))
})

output$VertFacet2 <- renderUI({
	if(!is.null(facet.panels2())) if(facet.panels2()>1) checkboxInput("vert.facet2", "Vertical facet", value=FALSE)
})

output$PooledVar2 <- renderUI({
	if(length(pooled.var2())) HTML(paste('<div>Pooled variable(s): ', paste(pooled.var2(), collapse=", "), '</div>', sep=""))
})

output$VertFacet3 <- renderUI({
	if(!is.null(facet.panels3())) if(facet.panels3()>1) checkboxInput("vert.facet3", "Vertical facet", value=FALSE)
})

output$PooledVar3 <- renderUI({
	if(length(pooled.var3())) HTML(paste('<div>Pooled variable(s): ', paste(pooled.var3(), collapse=", "), '</div>', sep=""))
})

# Switch to line plot for temperature or barplot for precipitation (TS plot), contour lines (scatter plot)
output$Altplot <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(!is.null(dat())) if(!("Temperature" %in% dat()$Var)) checkboxInput("altplot", "Barplot", FALSE) else checkboxInput("altplot", "Line plot", FALSE)
	)
})

output$Conplot <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(!is.null(dat2())) checkboxInput("conplot", "Contour lines", FALSE)
	)
})

output$Variability <- renderUI({
	if(!is.null(dat())) checkboxInput("variability", "Center on mean", FALSE)
})

output$Boxplots <- renderUI({
	if(!is.null(input$variability)) if(input$variability) selectInput("boxplots", "Box plots", choices=c("", "Basic", "Add points"), selected="", width="100%")
})

output$Dispersion <- renderUI({
	if(!is.null(input$variability) && !input$variability) selectInput("dispersion", "Dispersion stat", choices=c("SD", "SE", "Full Spread"), selected="SD", width="100%")
})

output$ErrorBars <- renderUI({
	if(!is.null(input$variability) && input$variability){
		if(!is.null(input$boxplots) && input$boxplots=="") selectInput("errorBars", "Error bars", choices=c("", "95% CI", "SD", "SE", "Range"), selected="", width="100%")
	}
})

# Options for summarizing data in TS plot (range markers, CIs, CBs)
output$SummarizeByXtitle <- renderUI({ if(!is.null(input$group)) HTML(paste('<div>Summarize by ', input$xtime, '</div>', sep="", collapse="")) })

output$Yrange <- renderUI({ if(!is.null(input$group)) checkboxInput("yrange", "Group range", FALSE) })

#output$CLbootbar <- renderUI({ if(!is.null(input$group)) checkboxInput("clbootbar", "Group mean CI", FALSE) })

output$CLbootsmooth <- renderUI({ if(!is.null(input$group)) checkboxInput("clbootsmooth", "Confidence band", FALSE) })

# Options for summarizing data in scatter plot (hexbin)
output$Hexbin <- renderUI({ checkboxInput("hexbin", "Hex bins", FALSE) })

# Plot button
output$PlotButton <- renderUI({
	if(permitPlot() & !is.null(dat()) & (!is.null(input$goButton) && input$goButton>0)) if(nrow(dat())>0) actionButton("plotButton", "Generate Plot")
})
