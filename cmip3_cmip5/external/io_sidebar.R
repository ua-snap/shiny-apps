# x-axis variable (TS plot, Variability plot), x/y axes variables (scatter plot), grouping variable, faceting variable
# x and y variables have no reactive dependencies for plot tabs 1 and 2, see sidebar.R
output$ShowPlotOptionsPanel <- reactive({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate({
		x <- TRUE
	})
	x
})
outputOptions(output, "ShowPlotOptionsPanel", suspendWhenHidden=FALSE)

observe({
	input$goButton
	isolate(
		if(!is.null(input$goButton) && input$goButton!=0) updateCheckboxInput(session, "showDataPanel1", value=FALSE)
	)
})

output$Location <- renderUI({
	if(is.null(input$loctype)) return()
	if(input$loctype!="Cities") x <- selectInput("locs_regions", "Regions:", c("", region.names.out[[input$loctype]]), selected="", multiple=T, width="100%")
	if(input$loctype=="Cities") x <- selectInput("locs_cities", "Cities:", c("", city.names), selected="", multiple=T, width="100%")
	x
})

output$Months2Seasons <- renderUI({
	if(!is.null(SeasonLength())) checkboxInput("months2seasons", "Make equal-length season(s) of months", FALSE) else NULL # Do not allow unequal length seasons
})

output$N_Seasons <- renderUI({
	if(is.null(input$months2seasons) || !input$months2seasons) return()
	if(length(input$mos) < 2) return()
	isolate({
		n <- SeasonLength()
		if(is.null(n)){
			x <- NULL
		} else {
			v <- 1:(n[1]-1) # Do not permit 1-month "seasons"
			v <- v[which((n[1] %% v)==0)]*length(n)
			x <- selectInput("n_seasons", "Number of seasons:", choices=v, selected=v[1], width="100%")
		}
	})
	x
})
outputOptions(output, "N_Seasons", suspendWhenHidden=FALSE)

output$Decades2Periods <- renderUI({
	if(!is.null(PeriodLength())) checkboxInput("decades2periods", "Make equal-length periods(s) of decades", FALSE) else NULL # Do not allow unequal length periods
})

output$N_Periods <- renderUI({
	if(is.null(input$decades2periods) || !input$decades2periods) return()
	if(length(input$decs) < 2) return()
	isolate({
		n <- PeriodLength()
		if(is.null(n)){
			x <- NULL
		} else {
			v <- 1:(n[1]-1) # Do not permit 1-decade "periods"
			v <- v[which((n[1] %% v)==0)]*length(n)
			x <- selectInput("n_periods", "Number of Periods:", choices=v, selected=v[1], width="100%")
		}
	})
	x
})
outputOptions(output, "N_Periods", suspendWhenHidden=FALSE)

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
	input$months2seasons
	input$decades2periods
	input$n_seasons
	input$n_periods
	input$aggStats
	actionButton("goButton", "Subset Data", icon="ok icon-white", styleclass="primary", block=T)
})

output$Group <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xtime
	isolate(
		if(!is.null(groupFacetChoicesTS())) selectInput("group", "Group/color by:", choices=groupFacetChoicesTS(), selected=groupFacetChoicesTS()[1], width="100%")
	)
})

output$Facet <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xtime
	isolate(
		if(!is.null(groupFacetChoicesTS())) selectInput("facet","Facet/panel by:", choices=groupFacetChoicesTS(), selected=groupFacetChoicesTS()[1], width="100%")
	)
})

#output$Subjects <- renderUI({
#	if(is.null(input$goButton) || input$goButton==0) return()
#	input$xtime
#	input$group
#	input$facet
#	isolate(
#		if(!is.null(subjectChoices())) selectInput("subjects", "Subject/Within-group lines:", choices=subjectChoices(), selected=subjectChoices()[1], width="100%")
#	)
#})

output$Group2 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xy
	isolate(
		if(!is.null(groupFacetChoicesScatter())) selectInput("group2", "Group/color by:", choices=groupFacetChoicesScatter(), selected=groupFacetChoicesScatter()[1], width="100%")
	)
})

output$Facet2 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xy
	isolate(
		if(!is.null(groupFacetChoicesScatter())) selectInput("facet2","Facet/panel by:", choices=groupFacetChoicesScatter(), selected=groupFacetChoicesScatter()[1], width="100%")
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
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xvar
	isolate(
		if(!is.null(groupFacetChoicesVar())) selectInput("group3", "Group/color by:", choices=groupFacetChoicesVar(), selected=groupFacetChoicesVar()[1], width="100%")
	)
})

output$Facet3 <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$xvar
	isolate(
		if(!is.null(groupFacetChoicesVar())) selectInput("facet3","Facet/panel by:", choices=groupFacetChoicesVar(), selected=groupFacetChoicesVar()[1], width="100%")
	)
})

#output$Subjects3 <- renderUI({
#	if(is.null(input$goButton) || input$goButton==0) return()
#	input$xvar
#	input$group3
#	input$facet3
#	x <- NULL
#	isolate(
#		if(!is.null(subjectChoices3())){
#			x <- selectInput("subjects3", "Subject/Within-group lines:", choices=subjectChoices3(), selected=subjectChoices3()[1], width="100%")
#		}
#	)
#	x
#})

output$Spatial_x <- renderUI({
	if(!is.null(spatial_x_choices())) selectInput("spatial_x", "Primary axis:", choices=spatial_x_choices(), selected=spatial_x_choices()[1], width="100%")
})

output$GroupSpatial <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$spatial_x
	isolate(
		if(!is.null(groupFacetChoicesSpatial())) selectInput("groupSpatial", "Group/color by:", choices=groupFacetChoicesSpatial(), selected=groupFacetChoicesSpatial()[1], width="100%")
	)
})

output$FacetSpatial <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$spatial_x
	isolate(
		if(!is.null(groupFacetChoicesSpatial())) selectInput("facetSpatial","Facet/panel by:", choices=groupFacetChoicesSpatial(), selected=groupFacetChoicesSpatial()[1], width="100%")
	)
})

output$PlotTypeSpatial <- renderUI({
	if(is.null(input$goButton) || input$goButton==0) return()
	input$spatial_x
	isolate(
		if(!is.null(input$spatial_x)) selectInput("plotTypeSpatial","Plot type:", choices=plotTypeChoicesSpatial(), selected=plotTypeChoicesSpatial()[1], width="100%")
	)
})

#output$SubjectsSpatial <- renderUI({
#	if(is.null(input$goButton) || input$goButton==0) return()
#	input$spatial_x
#	input$groupSpatial
#	input$facetSpatial
#	x <- NULL
#	isolate(
#		if(!is.null(subjectChoicesSpatial())){
#			x <- selectInput("subjectsSpatial", "Subject/Within-group lines:", choices=subjectChoicesSpatial(), selected=subjectChoicesSpatial()[1], width="100%")
#		}
#	)
#	x
#})

# Options for jittering, faceting, and pooling
output$VertFacet <- renderUI({
	if(!is.null(facet.panels())) if(facet.panels()>1) checkboxInput("vert.facet", "Vertical facet", value=FALSE)
})

output$PooledVar <- renderUI({
	if(length(pooled.var())) HTML(paste('<div>Pooled variable(s): ', paste(pooled.var(), collapse=", "), '</div>', sep=""))
})

#### I may bring this back, but when changing all plot types' vertical facet option to a number of columns option.
#output$VertFacet2 <- renderUI({
#	if(!is.null(facet.panels2())) if(facet.panels2()>1) checkboxInput("vert.facet2", "Vertical facet", value=FALSE)
#})

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

output$VertFacetSpatial <- renderUI({
	if(!is.null(facetPanelsSpatial())) if(facetPanelsSpatial()>1) checkboxInput("vertFacetSpatial", "Vertical facet", value=FALSE)
})

output$PooledVarSpatial <- renderUI({
	if(length(pooledVarSpatial())) HTML(paste('<div>Pooled variable(s): ', paste(pooledVarSpatial(), collapse=", "), '</div>', sep=""))
})

colorseq_ts <- reactive({
	getColorSeq(d=dat(), grp=input$group, n.grp=n.groups())
})

output$Colorpalettes_ts <- renderUI({
	getColorPalettes(id="colorpalettes_ts", colseq=colorseq_ts(), grp=input$group, n.grp=n.groups(),
		fill.vs.border=input$barPlot, fill.vs.border2=dat()$Var[1]=="Precipitation")
})

output$Alpha1 <- renderUI({
	if(!is.null(dat())) selectInput("alpha1", "Transparency", seq(0.1, 1, by=0.1), selected=0.5, width="100%")
})

output$PlotFontSize <- renderUI({
	if(!is.null(dat())) selectInput("plotFontSize","Font size",seq(12,24,by=2),selected=16, width="100%")
})

output$Bartype <- renderUI({
	if(is.null(input$group) || input$group=="None") return()
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

# Conditional inputs (tabset panel tab: scatter plot)
colorseq_sc <- reactive({
	getColorSeq(d=dat2(), grp=input$group2, n.grp=n.groups2())
})

output$Colorpalettes_sc <- renderUI({
	getColorPalettes(id="colorpalettes_sc", colseq=colorseq_sc(), grp=input$group2, n.grp=n.groups2())
})

output$Alpha2 <- renderUI({
	if(!is.null(dat2())) selectInput("alpha2", "Transparency", seq(0.1, 1, by=0.1), selected=0.5, width="100%")
})

output$PlotFontSize2 <- renderUI({
	if(!is.null(dat2())) selectInput("plotFontSize2","Font size",seq(12,24,by=2),selected=16, width="100%")
})

# Conditional inputs (tabset panel tab: heatmap)
colorseq_hm <- reactive({
	getColorSeq(d=dat_heatmap(), heat=TRUE)
})

output$Colorpalettes_hm <- renderUI({
	getColorPalettes(id="colorpalettes_hm", colseq=colorseq_hm(), heat=TRUE)
})

output$PlotFontSizeHeatmap <- renderUI({
	if(!is.null(dat_heatmap())) selectInput("plotFontSizeHeatmap","Font size",seq(12,24,by=2),selected=16, width="100%")
})

# Conditional inputs (tabset panel tab: variability plots)
colorseq_vr <- reactive({
	getColorSeq(d=dat(), grp=input$group3, n.grp=n.groups3(), overlay=input$vr_showCRU)
})

output$Colorpalettes_vr <- renderUI({
	getColorPalettes(id="colorpalettes_vr", colseq=colorseq_vr(), grp=input$group3, n.grp=n.groups3(), fill.vs.border=Variability(), overlay=input$vr_showCRU)
})

output$Alpha3 <- renderUI({
	if(!is.null(dat())) selectInput("alpha3", "Transparency", seq(0.1, 1, by=0.1), selected=0.5, width="100%")
})

output$PlotFontSize3 <- renderUI({
	if(!is.null(dat())) selectInput("plotFontSize3","Font size",seq(12,24,by=2),selected=16, width="100%")
})

output$Bartype3 <- renderUI({
	if(is.null(input$group3) || input$group3=="None") return()
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

# Conditional inputs (tabset panel tab: spatial plots)
colorseq_sp <- renderUI({
	getColorSeq(d=dat_spatial(), grp=input$groupSpatial, n.grp=nGroupsSpatial(), overlay=input$sp_showCRU)
})

output$Colorpalettes_sp <- renderUI({
	getColorPalettes(id="colorpalettes_sp", colseq=colorseq_sp(), grp=input$groupSpatial, n.grp=nGroupsSpatial(), overlay=input$sp_showCRU)
})

output$AlphaSpatial <- renderUI({
	if(!is.null(dat_spatial())) selectInput("alphaSpatial", "Transparency", seq(0.1, 1, by=0.1), selected=0.5, width="100%")
})

output$PlotFontSizeSpatial <- renderUI({
	if(!is.null(dat_spatial())) selectInput("plotFontSizeSpatial","Font size",seq(12,24,by=2),selected=16, width="100%")
})

output$DensityTypeSpatial <- renderUI({
	if(is.null(input$groupSpatial) || input$groupSpatial=="None") return()
	if(!is.null(dat_spatial()) && !is.null(input$plotTypeSpatial) && input$plotTypeSpatial!="Stripchart"){
		styles <- c("Overlay","Fill/Relative") #### Cn combine with boxplots/points? NO
		selectInput("densityTypeSpatial","Density style",styles,selected=styles[1], width="100%")
	} else return()
})

output$StripDirectionSpatial <- renderUI({ #### Consider swapping this out for a checkbox in each plot tab in which it occurs
	if(!is.null(dat_spatial()) && !is.null(input$plotTypeSpatial) && input$plotTypeSpatial=="Stripchart"){
		directions <- c("Vertical strips","Horizontal strips")
		selectInput("stripDirectionSpatial","Stripchart orientation",directions,selected=directions[1], width="100%")
	}
})

# Options for summarizing data in TS plot (range markers, CIs, CBs)
#output$SummarizeByXtitle <- renderUI({ if(!is.null(input$group)) HTML(paste('<div>Summarize by ', input$xtime, '</div>', sep="", collapse="")) })

#output$CLbootbar <- renderUI({ if(!is.null(input$group)) checkboxInput("clbootbar", "Group mean CI", FALSE) })

# Options for summarizing data in scatter plot (hexbin)
output$Hexbin <- renderUI({ checkboxInput("hexbin", "Hex bins", FALSE) })

# Plot button
output$PlotButton <- renderUI({
	if(permitPlot() & !is.null(dat()) & (!is.null(input$goButton) && input$goButton>0)) if(nrow(dat())>0) actionButton("plotButton", "Generate Plot", icon="ok icon-white", styleclass="primary", block=T)
})
