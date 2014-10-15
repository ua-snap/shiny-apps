output$tsTextSub <- renderUI({
	if(anyBtnNullOrZero()) return()
	isolate( pooledVarsCaption(pv=pooled.var(), permit=permitPlot(), ingrp=input$group) )
})

output$spTextSub <- renderUI({
	if(anyBtnNullOrZero()) return()
	isolate( pooledVarsCaption(pv=pooled.var2(), permit=permitPlot(), ingrp=input$group2) )
})

output$hmTextSub <- renderUI({
	if(anyBtnNullOrZero()) return()
	isolate( pooledVarsCaption(pv=pooledVarHeatmap(), permit=permitPlot()) )
})

output$varTextSub <- renderUI({
	if(anyBtnNullOrZero()) return()
	isolate( pooledVarsCaption(pv=pooled.var3(), permit=permitPlot(), ingrp=input$group3) )
})

output$spatialTextSub <- renderUI({
	if(anyBtnNullOrZero()) return()
	isolate( pooledVarsCaption(pv=pooledVarSpatial(), permit=permitPlot(), ingrp=input$groupSpatial) )
})

output$SubsetTableTS <- renderDataTable({ if(!is.null(dat())) dat()[-9] }, options=list(orderClasses = TRUE, lengthMenu=c(5, 10, 25, 50), pageLength=5))

output$TableTS <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTableTS")))
	)
})

output$SubsetTableScatter <- renderDataTable({ if(!is.null(dat2())) dat2()[-7] }, options=list(orderClasses = TRUE, lengthMenu=c(5, 10, 25, 50), pageLength=5))

output$TableScatter <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTableScatter")))
	)
})

output$SubsetTableHeatmap <- renderDataTable(
	{ if(!is.null(dat_heatmap()) && nrow(dat_heatmap() > 0)){ if(ncol(dat_heatmap()) >= 9) dat_heatmap()[-9] else dat_heatmap() } },
	options=list(orderClasses = TRUE, lengthMenu=c(5, 10, 25, 50), pageLength=5))

output$TableHeatmap <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(permitPlot() & !is.null(dat_heatmap())) if(nrow(dat_heatmap() > 0)) fluidRow(column(12, dataTableOutput("SubsetTableHeatmap")))
	)
})

output$SubsetTableVariability <- renderDataTable({ if(!is.null(dat())) dat()[-9] }, options=list(orderClasses = TRUE, lengthMenu=c(5, 10, 25, 50), pageLength=5)) # same as table 1

output$TableVariability <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTableVariability")))
	)
})

output$SubsetTableSpatial <- renderDataTable({ if(!is.null(dat_spatial())) dat_spatial()[-9] }, options=list(orderClasses = TRUE, lengthMenu=c(5, 10, 25, 50), pageLength=5))

output$TableSpatial <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTableSpatial")))
	)
})
