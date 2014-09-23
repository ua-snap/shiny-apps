# x-axis variable (TS plot, Variability plot), x/y axes variables (scatter plot), grouping variable, faceting variable
# x and y variables have no reactive dependencies for plot tabs 1 and 2, see sidebar.R
output$GoButton <- renderUI({
	input$vars
	input$units
	input$cmip3scens
	input$cmip5scens
	input$cmip3models
	input$cmip5models
	input$compositeModel
	input$yrs
	input$mos
	input$decs
	input$loctype
	input$locs_regions
	input$locs_cities
	actionButton("goButton", "Subset Data", icon="ok icon-white", styleclass="primary", block=T)
})

output$Group <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xtime
	isolate(
		if(!is.null(group.choices())) selectInput("group", "Group/color by:", choices=group.choices(), selected=group.choices()[1], width="100%")
	)
})

output$Facet <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xtime
	input$group
	isolate(
		if(!is.null(facet.choices())) selectInput("facet","Facet/panel by:", choices=facet.choices(), selected=facet.choices()[1], width="100%")
	)
})

output$Subjects <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xtime
	input$group
	input$facet
	isolate(
		if(!is.null(subjectChoices())) selectInput("subjects", "Subject/Within-group lines:", choices=subjectChoices(), selected=subjectChoices()[1], width="100%")
	)
})

output$Group2 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xy
	isolate(
		if(!is.null(group.choices2())) selectInput("group2", "Group/color by:", choices=group.choices2(), selected=group.choices2()[1], width="100%")
	)
})

output$Facet2 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xy
	input$group2
	isolate(
		if(!is.null(facet.choices2())) selectInput("facet2","Facet/panel by:", choices=facet.choices2(), selected=facet.choices2()[1], width="100%")
	)
})

output$Heatmap_x <- renderUI({
	if(!is.null(heatmap_x_choices())) selectInput("heatmap_x", "X axis:", choices=heatmap_x_choices(), selected=heatmap_x_choices()[1], width="100%")
})

output$Heatmap_y <- renderUI({
	if(!is.null(heatmap_y_choices())) selectInput("heatmap_y", "Y axis:", choices=heatmap_y_choices(), selected=heatmap_y_choices()[1], width="100%")
})

output$FacetHeatmap <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$heatmap_x
	input$heatmap_y
	isolate(
		if(!is.null(facetChoicesHeatmap())) selectInput("facetHeatmap","Facet/panel by:", choices=facetChoicesHeatmap(), selected=facetChoicesHeatmap()[1], width="100%")
	)
})

output$StatHeatmap <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$heatmap_x
	input$heatmap_y
	input$facetHeatmap
	isolate({
		stats <- c("Mean", "Total", "SD")
		statChoicesHeatmap <- stats[which(stats %in% names(dat_heatmap()))]
		if(!length(statChoicesHeatmap)) x <- NULL else x <- selectInput("statHeatmap","Stat:", choices=statChoicesHeatmap, selected=statChoicesHeatmap[1], width="100%")
	})
})

output$Xvar <- renderUI({
	if(!is.null(xvarChoices())) selectInput("xvar", "Primary axis:", choices=xvarChoices(), selected=xvarChoices()[1], width="100%")
})

output$Group3 <- renderUI({
	input$xvar
	if(!is.null(group.choices3())) selectInput("group3", "Group/color by:", choices=group.choices3(), selected=group.choices3()[1], width="100%")
})

output$Facet3 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xvar
	input$group3
	isolate(
		if(!is.null(facet.choices3())) selectInput("facet3","Facet/panel by:", choices=facet.choices3(), selected=facet.choices3()[1], width="100%")
	)
})

output$Subjects3 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xvar
	input$group3
	input$facet3
	x <- NULL
	isolate(
		if(!is.null(subjectChoices3())){
			x <- selectInput("subjects3", "Subject/Within-group lines:", choices=subjectChoices3(), selected=subjectChoices3()[1], width="100%")
		}
	)
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

output$PooledVarHeatmap <- renderUI({
	if(length(pooledVarHeatmap())) HTML(paste('<div>Pooled variable(s): ', paste(pooledVarHeatmap(), collapse=", "), '</div>', sep=""))
})

output$VertFacet3 <- renderUI({
	if(!is.null(facet.panels3())) if(facet.panels3()>1) checkboxInput("vert.facet3", "Vertical facet", value=FALSE)
})

output$PooledVar3 <- renderUI({
	if(length(pooled.var3())) HTML(paste('<div>Pooled variable(s): ', paste(pooled.var3(), collapse=", "), '</div>', sep=""))
})

# Conditional inputs (tabset panel tab: time series plot)
output$Colorseq <- renderUI({
	getColorSeq(id="colorseq", d=dat(), grp=input$group, n.grp=n.groups())
})

output$Colorpalettes <- renderUI({
	getColorPalettes(id="colorpalettes", colseq=input$colorseq, grp=input$group, n.grp=n.groups(),
		fill.vs.border=input$barPlot, fill.vs.border2=dat()$Var[1]=="Precipitation")
})

output$Alpha1 <- renderUI({
	if(!is.null(dat())) selectInput("alpha1", "Transparency", seq(0.1, 1, by=0.1), selected=0.5, width="100%")
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

output$LinePlot <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(!is.null(dat())) checkboxInput("linePlot", "Trend Lines", FALSE)
	)
})

output$BarPlot <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(!is.null(dat())) if(!("Temperature" %in% dat()$Var)) checkboxInput("barPlot", "Barplot", FALSE) else return()
	)
})

# Conditional inputs (tabset panel tab: scatter plot)
output$Colorseq2 <- renderUI({
	getColorSeq(id="colorseq2", d=dat2(), grp=input$group2, n.grp=n.groups2())
})

output$Colorpalettes2 <- renderUI({
	getColorPalettes(id="colorpalettes2", colseq=input$colorseq2, grp=input$group2, n.grp=n.groups2())
})

output$Alpha2 <- renderUI({
	if(!is.null(dat2())) selectInput("alpha2", "Transparency", seq(0.1, 1, by=0.1), selected=0.5, width="100%")
})

output$PlotFontSize2 <- renderUI({
	if(!is.null(dat2())) selectInput("plotFontSize2","Font size",seq(12,24,by=2),selected=16, width="100%")
})

output$Conplot <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(!is.null(dat2())) checkboxInput("conplot", "Contour lines", FALSE)
	)
})

# Conditional inputs (tabset panel tab: heatmap)
output$ColorseqHeatmap <- renderUI({
	getColorSeq(id="colorseqHeatmap", d=dat_heatmap(), heat=TRUE)
})

output$ColorpalettesHeatmap <- renderUI({
	getColorPalettes(id="colorpalettesHeatmap", colseq=input$colorseqHeatmap, heat=TRUE)
})

output$PlotFontSizeHeatmap <- renderUI({
	if(!is.null(dat_heatmap())) selectInput("plotFontSizeHeatmap","Font size",seq(12,24,by=2),selected=16, width="100%")
})

# Conditional inputs (tabset panel tab: variability plots)
output$Colorseq3 <- renderUI({
	getColorSeq(id="colorseq3", d=dat(), grp=input$group3, n.grp=n.groups3(), overlay=input$showCRU)
})

output$Colorpalettes3 <- renderUI({
	getColorPalettes(id="colorpalettes3", colseq=input$colorseq3, grp=input$group3, n.grp=n.groups3(), fill.vs.border=Variability(), overlay=input$showCRU)
})

output$Alpha3 <- renderUI({
	if(!is.null(dat())) selectInput("alpha3", "Transparency", seq(0.1, 1, by=0.1), selected=0.5, width="100%")
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

output$Variability <- renderUI({
	if(!is.null(dat())) checkboxInput("variability", "Center on mean", FALSE)
})

#output$Boxplots <- renderUI({
#	if(!is.null(input$variability)) if(input$variability) checkboxInput("boxplots", "Box plots", FALSE)
#})

#output$Dispersion <- renderUI({
#	if(!is.null(input$variability) && !input$variability) selectInput("dispersion", "Dispersion stat", choices=c("SD", "SE", "Full Spread"), selected="SD", width="100%")
#})
#
#output$ErrorBars <- renderUI({
#	if(!is.null(input$variability) && input$variability){
#		if(!is.null(input$boxplots) && input$boxplots=="") selectInput("errorBars", "Error bars", choices=c("", "95% CI", "SD", "SE", "Range"), selected="", width="100%")
#	}
#})

# Options for summarizing data in TS plot (range markers, CIs, CBs)
#output$SummarizeByXtitle <- renderUI({ if(!is.null(input$group)) HTML(paste('<div>Summarize by ', input$xtime, '</div>', sep="", collapse="")) })

output$Yrange <- renderUI({ if(!is.null(input$group)) checkboxInput("yrange", "Group range", FALSE) })

#output$CLbootbar <- renderUI({ if(!is.null(input$group)) checkboxInput("clbootbar", "Group mean CI", FALSE) })

output$CLbootsmooth <- renderUI({ if(!is.null(input$group)) checkboxInput("clbootsmooth", "Confidence band", FALSE) })

# Options for summarizing data in scatter plot (hexbin)
output$Hexbin <- renderUI({ checkboxInput("hexbin", "Hex bins", FALSE) })

# Plot button
output$PlotButton <- renderUI({
	if(permitPlot() & !is.null(dat()) & (!is.null(input$goButton) && input$goButton>0)) if(nrow(dat())>0) actionButton("plotButton", "Generate Plot", icon="ok icon-white", styleclass="primary", block=T)
})
