# @knitr main_out_01_05
output$tsTextSub <- renderUI({
	if(twoBtnNullOrZero_ts()) return()
	isolate( pooledVarsCaption(pv=pooled.var(), permit=permitPlot(), ingrp=input$group) )
})

output$spTextSub <- renderUI({
	if(twoBtnNullOrZero_sc()) return()
	isolate( pooledVarsCaption(pv=pooled.var2(), permit=permitPlot(), ingrp=input$group2) )
})

output$hmTextSub <- renderUI({
	if(twoBtnNullOrZero_hm()) return()
	isolate( pooledVarsCaption(pv=pooledVarHeatmap(), permit=permitPlot()) )
})

output$varTextSub <- renderUI({
	if(twoBtnNullOrZero_vr()) return()
	isolate( pooledVarsCaption(pv=pooled.var3(), permit=permitPlot(), ingrp=input$group3) )
})

output$spatialTextSub <- renderUI({
	if(twoBtnNullOrZero_sp()) return()
	isolate( pooledVarsCaption(pv=pooledVarSpatial(), permit=permitPlot(), ingrp=input$groupSpatial) )
})

# @knitr main_out_06_07
output$SubsetTableTS <- renderDataTable({ if(!is.null(dat())) dat()[, !"Decade", with=FALSE] }, options=list(orderClasses = TRUE, lengthMenu=c(5, 10, 25, 50), pageLength=5),
    style="bootstrap", rownames=F, filter="bottom", caption="Table 1: GCM data selection for time series plots.")

output$TableTS <- renderUI({
	if(goBtnNullOrZero()) return()
	isolate(
		if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTableTS")))
	)
})

# @knitr main_out_08_09
output$SubsetTableScatter <- renderDataTable({ if(!is.null(dat2())) dat2()[, !"Decade", with=FALSE] }, options=list(orderClasses = TRUE, lengthMenu=c(5, 10, 25, 50), pageLength=5),
    style="bootstrap", rownames=F, filter="bottom", caption="Table 2: GCM data selection for scatter plots.")

output$TableScatter <- renderUI({
	if(goBtnNullOrZero()) return()
	isolate(
		if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTableScatter")))
	)
})

# @knitr main_out_10_11
output$SubsetTableHeatmap <- renderDataTable(
	{ if(!is.null(dat_heatmap()) && nrow(dat_heatmap() > 0)){ if(ncol(dat_heatmap()) >= 9) dat_heatmap()[, !"Decade", with=FALSE] else dat_heatmap() } },
	options=list(orderClasses = TRUE, lengthMenu=c(5, 10, 25, 50), pageLength=5),
    style="bootstrap", rownames=F, filter="bottom", caption="Table 3: GCM data selection for heat maps.")

output$TableHeatmap <- renderUI({
	if(goBtnNullOrZero()) return()
	isolate(
		if(permitPlot() & !is.null(dat_heatmap())) if(nrow(dat_heatmap() > 0)) fluidRow(column(12, dataTableOutput("SubsetTableHeatmap")))
	)
})

# @knitr main_out_12_13
output$SubsetTableVariability <- renderDataTable({ if(!is.null(dat())) dat()[, !"Decade", with=FALSE] }, options=list(orderClasses = TRUE, lengthMenu=c(5, 10, 25, 50), pageLength=5),
    style="bootstrap", rownames=F, filter="bottom", caption="Table 4: GCM data selection for variability assessment.") # same as table 1

output$TableVariability <- renderUI({
	if(goBtnNullOrZero()) return()
	isolate(
		if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTableVariability")))
	)
})

# @knitr main_out_14_15
output$SubsetTableSpatial <- renderDataTable({ if(!is.null(dat_spatial())) dat_spatial()[, !"Decade", with=FALSE] }, options=list(orderClasses = TRUE, lengthMenu=c(5, 10, 25, 50), pageLength=5),
    style="bootstrap", rownames=F, filter="bottom", caption="Table 5: GCM data selection for spatial distributions.")

output$TableSpatial <- renderUI({
	if(goBtnNullOrZero()) return()
	isolate(
		if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTableSpatial")))
	)
})
