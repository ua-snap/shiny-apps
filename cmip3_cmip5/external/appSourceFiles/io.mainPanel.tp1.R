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

output$Colorseq <- renderUI({
	getColorSeq(id="colorseq", d=dat(), grp=input$group, n.grp=n.groups())
})

output$Colorpalettes <- renderUI({
	getColorPalettes(id="colorpalettes", colseq=input$colorseq, grp=input$group, n.grp=n.groups(),
		fill.vs.border=input$altplot, fill.vs.border2=dat()$Var[1]=="Precipitation")
})

output$Alpha1 <- renderUI({
	if(!is.null(dat())) selectInput("alpha1", "Transparency", seq(0.1, 1, by=0.1), selected=0.5, width="100%")
})

output$LegendPos1 <- renderUI({
	if(is.null(input$group) || input$group=="None/Force Pool") return()
	if(!is.null(dat())) selectInput("legendPos1","Legend position",c("Top","Right","Bottom","Left"),selected="Top", width="100%")
})

output$PlotFontSize <- renderUI({
	if(!is.null(dat())) selectInput("plotFontSize","Font size",seq(12,24,by=2),selected=16, width="100%")
})

output$Bartype <- renderUI({
	if(is.null(input$group) || input$group=="None/Force Pool") return()
	if(!is.null(dat())){
		styles <- c("Dodge (Grouped)","Stack (Totals)","Fill (Proportions)")
		if(!is.null(input$barPlot)) if(input$barPlot & dat()$Var[1]=="Precipitation") selectInput("bartype","Barplot style",styles,selected=styles[1], width="100%")
	}
})

output$Bardirection <- renderUI({
	if(!is.null(dat())){
		directions <- c("Vertical bars","Horizontal bars")
		if(!is.null(input$barPlot)) if(input$barPlot & dat()$Var[1]=="Precipitation") selectInput("bardirection","Barplot orientation",directions,selected=directions[1], width="100%")
	}
})

output$SubsetTable1 <- renderDataTable({ if(!is.null(dat())) dat()[-9] }, options=list(bSortClasses = TRUE, aLengthMenu=c(5, 10, 25, 50), iDisplayLength=5))

output$Table1 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTable1")))
})

output$Colorseq2 <- renderUI({
	getColorSeq(id="colorseq2", d=dat2(), grp=input$group2, n.grp=n.groups2())
})

output$Colorpalettes2 <- renderUI({
	getColorPalettes(id="colorpalettes2", colseq=input$colorseq2, grp=input$group2, n.grp=n.groups2())
})

output$Alpha2 <- renderUI({
	if(!is.null(dat2())) selectInput("alpha2", "Transparency", seq(0.1, 1, by=0.1), selected=0.5, width="100%")
})

output$LegendPos2 <- renderUI({
	if(is.null(input$group2) || input$group2=="None/Force Pool") return()
	if(!is.null(dat2())) selectInput("legendPos2","Legend position",c("Top","Right","Bottom","Left"),selected="Top", width="100%")
})

output$PlotFontSize2 <- renderUI({
	if(!is.null(dat2())) selectInput("plotFontSize2","Font size",seq(12,24,by=2),selected=16, width="100%")
})

output$SubsetTable2 <- renderDataTable({ if(!is.null(dat2())) dat2()[-7] }, options=list(bSortClasses = TRUE, aLengthMenu=c(5, 10, 25, 50), iDisplayLength=5))

output$Table2 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTable2")))
})

output$Colorseq3 <- renderUI({
	getColorSeq(id="colorseq3", d=dat(), grp=input$group3, n.grp=n.groups3(), overlay=input$showCRU)
})

output$Colorpalettes3 <- renderUI({
	getColorPalettes(id="colorpalettes3", colseq=input$colorseq3, grp=input$group3, n.grp=n.groups3(), fill.vs.border=Variability(), overlay=input$showCRU)
})

output$Alpha3 <- renderUI({
	if(!is.null(dat())) selectInput("alpha3", "Transparency", seq(0.1, 1, by=0.1), selected=0.5, width="100%")
})

output$LegendPos3 <- renderUI({
	if(is.null(input$group3) || input$group3=="None/Force Pool") return()
	if(!is.null(dat())) selectInput("legendPos3","Legend position",c("Top","Right","Bottom","Left"),selected="Top", width="100%")
})

output$PlotFontSize3 <- renderUI({
	if(!is.null(dat())) selectInput("plotFontSize3","Font size",seq(12,24,by=2),selected=16, width="100%")
})

output$Bartype3 <- renderUI({
	if(is.null(input$group3) || input$group3=="None/Force Pool") return()
	if(!is.null(dat()) & !is.null(input$variability)){
		if(!input$variability){
			styles <- c("Dodge (Grouped)","Stack (Totals)","Fill (Proportions)")
			selectInput("bartype3","Barplot style",styles,selected=styles[1], width="100%")
		} else return()
	} else return()
})

output$Bardirection3 <- renderUI({
	if(!is.null(dat()) & !is.null(input$variability)){
		if(!input$variability){
			directions <- c("Vertical bars","Horizontal bars")
			selectInput("bardirection3","Barplot orientation",directions,selected=directions[1], width="100%")
		}
	}
})

output$SubsetTable3 <- renderDataTable({ if(!is.null(dat())) dat()[-9] }, options=list(bSortClasses = TRUE, aLengthMenu=c(5, 10, 25, 50), iDisplayLength=5)) # same as table 1

output$Table3 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	if(permitPlot()) fluidRow(column(12, dataTableOutput("SubsetTable3")))
})
