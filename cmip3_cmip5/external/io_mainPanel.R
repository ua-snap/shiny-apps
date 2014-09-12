output$tsText <- renderUI({
	HTML("<h3>Data Selection</h3>
		<ul>
			<li>Must select at least one variable, scenario, corresponding model, month, decade, and area (region or city) to plot.</li>
			<li>If multiple climate variables are selected, the data subset is truncated to the first in the list. The time series plots are univariate.</li>
			<li>If months or decades left blank, selection defaults to all. Select only what you want, but no need to click every factor level.</li>
			<li>Years are the intersection of the years slider and the decades list. One may suffice, unless you want partial or discontinuous decades.</li>
			<li>You may subset data when minimally required selections are complete. This text will vanish and a blue subset button will appear.</li>
			<li>You may download data when subset is complete.</li>
		</ul>
		<h3>Plot Options</h3>
		<ul>
			<li>Plot options are based on the data in use and must be selected after subsetting the data.</li>
			<li>Since some plot options are based on the data subset, generating a new subset will generally require selecting some plot options again.</li>
			<li>As with the data download, you may plot in the browser or download the plot as a PDF via the respective buttons when subsetting is complete.</li>
		</ul>")
})

output$spText <- renderUI({
	HTML("<h3>Data Selection</h3>
		<ul>
			<li>Must select two variables, at least one scenario, corresponding model, month, decade, and area (region or city) to plot.</li>
			<li>If only one climate variable is selected, you may not plot. The scatter plot is bivariate.</li>
			<li>If months or decades left blank, selection defaults to all. Select only what you want, but no need to click every factor level.</li>
			<li>Years are the intersection of the years slider and the decades list. One may suffice, unless you want partial or discontinuous decades.</li>
			<li>You may subset data when minimally required selections are complete. This text will vanish and a blue subset button will appear.</li>
			<li>You may download data when subset is complete.</li>
		</ul>
		<h3>Plot Options</h3>
		<ul>
			<li>Plot options are based on the data in use and must be selected after subsetting the data.</li>
			<li>Since some plot options are based on the data subset, generating a new subset will generally require selecting some plot options again.</li>
			<li>As with the data download, you may plot in the browser or download the plot as a PDF via the respective buttons when subsetting is complete.</li>
		</ul>")
})

output$varText <- renderUI({
	HTML("<h3>Data Selection</h3>
		<ul>
			<li>Must select at least one variable, scenario, corresponding model, month, decade, and area (region or city) to plot.</li>
			<li>If multiple climate variables are selected, the data subset is truncated to the first in the list. These plots are all univariate.</li>
			<li>If months or decades left blank, selection defaults to all. Select only what you want, but no need to click every factor level.</li>
			<li>Years are the intersection of the years slider and the decades list. One may suffice, unless you want partial or discontinuous decades.</li>
			<li>You may subset data when minimally required selections are complete. This text will vanish and a blue subset button will appear.</li>
			<li>You may download data when subset is complete.</li>
		</ul>
		<h3>Plot Options</h3>
		<ul>
			<li>Plot options are based on the data in use and must be selected after subsetting the data.</li>
			<li>Since some plot options are based on the data subset, generating a new subset will generally require selecting some plot options again.</li>
			<li>As with the data download, you may plot in the browser or download the plot as a PDF via the respective buttons when subsetting is complete.</li>
		</ul>")
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
