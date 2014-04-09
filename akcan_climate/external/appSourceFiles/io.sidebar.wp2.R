# x-axis variable, grouping variable, faceting variable
output$xtime <- renderUI({
	selectInput("xtime",paste(input$vars,"by:"),choices=c("Month","Decade"),selected="Month")
})

output$group <- renderUI({
	if(!is.null(group.choices())) selectInput("group","Group/color by:",choices=group.choices(),selected=group.choices()[1])
})

output$facet <- renderUI({
	if(!is.null(facet.choices())) selectInput("facet","Facet/panel by:",choices=facet.choices(),selected=facet.choices()[1])
})

# Options for jittering, faceting, and pooling
output$vert.facet <- renderUI({
	if(!is.null(facet.panels())) if(facet.panels()>1) checkboxInput("vert.facet","Vertical facet",value=FALSE)
})

output$pooled.var <- renderUI({
	if(!is.null(pooled.var())) HTML(paste('<div>Pooled variable: ',pooled.var(),'</div>',sep="",collapse=""))
})

output$jitterXY <- renderUI({
	checkboxInput("jitterXY","Jitter points",FALSE)
})

# Switch to line plot (temperature data) or barplot (precipitation data)
output$altplot <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(!is.null(dat.sub())) if(dat.sub()$Variable[1]=="Temperature") checkboxInput("altplot","Line plot",FALSE) else checkboxInput("altplot","Barplot",FALSE)
	)
})

# Options for summarizing data in plot (range markers, CIs, CBs)
output$summarizeByXtitle <- renderUI({ if(!is.null(input$group)) HTML(paste('<div>Summarize by ',input$xtime,'</div>',sep="",collapse="")) })

output$yrange <- renderUI({ if(!is.null(input$group)) checkboxInput("yrange","Group range",FALSE) })

output$clbootbar <- renderUI({ if(!is.null(input$group)) checkboxInput("clbootbar","Group mean CI",FALSE) })

output$clbootsmooth <- renderUI({ if(!is.null(input$group)) checkboxInput("clbootsmooth","Confidence band",FALSE) })

# Plot button
output$PlotButton <- renderUI({
	if(permitPlot() & !is.null(dat.sub())) actionButton("plotButton", "Generate Plot")
})
