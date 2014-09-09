output$tsText <- renderUI({
	if(!permitPlot()) h5(HTML("Must select at least one variable with units, one scenario and corresponding model, one month, decade, and domain to plot.
						<br/>If months or decades left blank, selection defaults to all."))
})

output$spText <- renderUI({
	if(!permitPlot()) h5(HTML("Must select two variables with units, at least one scenario and corresponding model, one month, decade, and domain to plot.
						<br/>If months or decades left blank, selection defaults to all."))
})

output$varText <- renderUI({
	if(!permitPlot()) h5(HTML("Must select at least one variable with units, one scenario and corresponding model, one month, decade, and domain to plot.
						<br/>If months or decades left blank, selection defaults to all."))
})

output$tsTextSub <- renderUI({
	if(is.null(input$plotButton) || input$plotButton==0) return()
	isolate( pooledVarsCaption(pv=pooled.var(), permit=permitPlot(), ingrp=input$group) )
})

output$spTextSub <- renderUI({
	if(is.null(input$plotButton) || input$plotButton==0) return()
	isolate( pooledVarsCaption(pv=pooled.var2(), permit=permitPlot(), ingrp=input$group2) )
})

output$varTextSub <- renderUI({
	if(is.null(input$plotButton) || input$plotButton==0) return()
	isolate( pooledVarsCaption(pv=pooled.var3(), permit=permitPlot(), ingrp=input$group3) )
})


output$SubsetTable1 <- renderDataTable({ if(!is.null(dat())) dat()[-9] }, options=list(bSortClasses = TRUE, aLengthMenu=c(5, 10, 25, 50), iDisplayLength=5))

output$Table1 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTable1")))
})

output$SubsetTable2 <- renderDataTable({ if(!is.null(dat2())) dat2()[-7] }, options=list(bSortClasses = TRUE, aLengthMenu=c(5, 10, 25, 50), iDisplayLength=5))

output$Table2 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTable2")))
})

output$SubsetTable3 <- renderDataTable({ if(!is.null(dat())) dat()[-9] }, options=list(bSortClasses = TRUE, aLengthMenu=c(5, 10, 25, 50), iDisplayLength=5)) # same as table 1

output$Table3 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTable3")))
})
