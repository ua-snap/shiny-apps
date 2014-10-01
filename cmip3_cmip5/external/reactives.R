# Datasets, scenarios, models, years, decades
anyBtnNullOrZero <- reactive({ is.null(input$goButton) || input$goButton==0 || is.null(input$plotButton) || input$plotButton==0 })

currentYears <- reactive({ if(!is.null(input$yrs)) as.numeric(input$yrs[1]):as.numeric(input$yrs[2]) })

limitedYears <- reactive({
	rng <- range(as.numeric(substr(Decades(),1,4))) + c(0,9)
	yrs <- intersect(currentYears(), seq(rng[1], rng[2]))
	yrs
})

currentUnits <- reactive({ if(!is.null(input$units)) c(substr(input$units,1,1), substr(input$units,4,5)) })

scenarios <- reactive({
	x <- c()
	if(!is.null(input$cmip3scens)) x <- input$cmip3scens
	if(!is.null(input$cmip5scens)) x <- c(x, input$cmip5scens)
	ind <- which(x=="")
	if(length(ind)) x <- x[-ind]
	if(!length(x)) x <- NULL
	x
})

models_original <- reactive({
	x <- c()
	if(!is.null(input$cmip3models)) x <- input$cmip3models
	if(!is.null(input$cmip5models)) x <- c(x, input$cmip5models)
	ind <- which(x=="")
	if(length(ind)) x <- x[-ind]
	if(!length(x)) x <- NULL
	x
})

models <- reactive({
	x <- models_original()
	if(!is.null(input$compositeModel)){
		if(input$compositeModel & !is.null(dat_master())) x <- unique(dat_master()$Model)
	}
	x
})

composite <- reactive({
	x <- FALSE
	comp <- input$compositeModel
	if(!is.null(comp)){
		l1 <- length(input$cmip3models)
		l2 <- length(input$cmip5models)
		if(comp & ((modelScenPair1() & l1 > 1) | (modelScenPair2() & l2 > 1)) & !allModelScenPair()) {
			x <- 1
		} else if(l1 > 1 & l2 > 1 & allModelScenPair()) {
			if(l1 == l2 & comp) x <- 2
		}
	}
	x
})

Months_original <- reactive({
	x <- input$mos
	if(!length(x)) x <- month.abb
	x
})

Months <- reactive({
	x <- Months_original()
	if(!is.null(input$months2seasons)){
		if(input$months2seasons & !is.null(dat_master())) x <- unique(as.character(dat_master()$Month))
	}
	x
})

SeasonLength <- reactive({
	if(length(input$mos)<=1) NULL else periodLength(x=match(input$mos, month.abb))
})

Decades_original <- reactive({
	x <- input$decs
	if(!length(x)) x <- decades
	x
})

Decades <- reactive({
	x <- Decades_original()
	if(!is.null(input$decades2periods)){
		if(input$decades2periods & !is.null(dat_master())) x <- unique(dat_master()$Decade)
	}
	x
})

PeriodLength <- reactive({
	if(length(input$decs)<=1) NULL else periodLength(x=as.numeric(substr(input$decs,1,4))/10)
})

Locs <- reactive({ if(is.null(input$loctype) || input$loctype=="Regions")  input$locs_regions else if(input$loctype=="Cities") input$locs_cities else NULL })
regionSelected <- reactive({ input$loctype=="Regions" & length(Locs())  })
citySelected <- reactive({ input$loctype=="Cities" & length(Locs()) })
locSelected <- reactive({ length(Locs()) })
	
# Initially retain all climate variables regardless of user's selection
dat_master <- reactive({
	if(is.null(input$goButton) || input$goButton==0) return()
	progress <- Progress$new(session, min=1, max=10)
	on.exit(progress$close())
	isolate(
		if(is.null(Months_original()) | is.null(input$vars) | is.null(scenarios()) | is.null(models_original()) | locSelected()==FALSE){
			x <- NULL
		} else {
			progress$set(message="Calculating, please wait", detail="Loading requested data...")
			if(input$loctype=="Cities" && length(input$locs_cities) && input$locs_cities[1]!="") {
				city.ind <- which(city.names %in% Locs())
				for(i in 1:length(city.ind)) {
					load(city.gcm.files[city.ind[i]], envir=environment())
					if(i==1) city.dat.final <- city.dat else city.dat.final <- rbind(city.dat.final, city.dat)
				}
				progress$set(message="Calculating, please wait", detail="Subsetting data...")
				x <- subset(city.dat.final, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4) & 
					Scenario %in% scenarios() & Model %in% models_original() & Domain %in% input$locs_cities)
			} else if(is.character(input$map_shape_click$id) && input$map_shape_click$id[1]!="") {
				city.ind <- which(city.names==input$map_shape_click$id)
				load(city.gcm.files[city.ind], envir=environment())
				progress$set(message="Calculating, please wait", detail="Subsetting data...")
				x <- subset(city.dat, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4) & 
					Scenario %in% scenarios() & Model %in% models_original() & Domain %in% input$map_shape_click$id)
			} else if(input$loctype=="Regions"){
				region.ind <- which(region.names %in% Locs())
				for(i in 1:length(region.ind)) {
					load(region.gcm.files[region.ind[i]], envir=environment())
					if(i==1) region.dat.final <- region.dat else region.dat.final <- rbind(region.dat.final, region.dat)
				}
				progress$set(message="Calculating, please wait", detail="Subsetting data...")
				x <- subset(region.dat.final, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4) & 
					Scenario %in% scenarios() & Model %in% models_original() & Domain %in% input$locs_regions)
			}
			if(!is.null(input$months2seasons) && input$months2seasons) x <- collapseMonths(x, as.numeric(input$n_seasons), Months_original())
			if(!is.null(input$decades2periods) && input$decades2periods) x <- periodsFromDecades(x, as.numeric(input$n_periods), Decades_original())
			#print(input$map_shape_click$id)
			# data from only one phase with multiple models in that phase selected, or two phases with equal number > 1 of models selected from each phase.
			# Otherwise compositing prohibited.
			if(composite()==2){ # can assume both phases have multiple models, so split always works nicely
				progress$set(message="Calculating, please wait", detail="Averaging models...")
				n <- length(input$cmip3models) # will match length(input$cmip5models)
				x <- split(x, x$Phase)
				x1 <- split(x[[1]], x[[1]]$Model)
				x2 <- split(x[[2]], x[[2]]$Model)
				v1 <- Reduce("+", lapply( x1, "[", c("Val") ))[,1]/n
				v2 <- Reduce("+", lapply( x2, "[", c("Val") ))[,1]/n
				x1[[1]]$Model <- paste0("CMIP3 ",n,"-Model Avg")
				x2[[1]]$Model <- paste0("CMIP5 ",n,"-Model Avg")
				x <- rbind(x1[[1]], x2[[1]])
				x$Val <- c(v1,v2)
				x$Val[x$Var=="Temperature"] <- round(x$Val[x$Var=="Temperature"],1)
				x$Val[x$Var=="Precipitation"] <- round(x$Val[x$Var=="Precipitation"])
			} else if(composite()==1) {
				progress$set(message="Calculating, please wait", detail="Averaging models...")
				if(modelScenPair1()) n <- length(input$cmip3models) else if(modelScenPair2()) n <- length(input$cmip5models)
				x1 <- split(x, x$Model)
				v1 <- Reduce("+", lapply( x1, "[", c("Val") ))[,1]/n
				x1[[1]]$Model <- paste0(n,"-Model Avg")
				x <- x1[[1]]
				x$Val <- v1
				x$Val[x$Var=="Temperature"] <- round(x$Val[x$Var=="Temperature"],1)
				x$Val[x$Var=="Precipitation"] <- round(x$Val[x$Var=="Precipitation"])
			}
			if(input$units=="F, in"){
			progress$set(message="Calculating, please wait", detail="Unit conversion...")
				x$Val[x$Var=="Temperature"] <- round((9/5)*x$Val[x$Var=="Temperature"] + 32,1)
				x$Val[x$Var=="Precipitation"] <- round(x$Val[x$Var=="Precipitation"]/25.4,3)
			}
			progress$set(message="Calculating, please wait", detail="Complete.")
			rownames(x) <- NULL
		}
	)
	x
})

dat <- reactive({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate({
		if(is.null(dat_master())){
			x <- NULL
		} else {
			x <- subset(dat_master(), Var %in% input$vars[1]) # only one (first) climate variable permitted for use in TS plot, even if user selects multiple
			rownames(x) <- NULL
		}
	})
	x
})

dat_heatmap <- reactive({
	if(is.null(input$goButton) || input$goButton==0 || is.null(dat())) return()
	input$heatmap_x
	input$heatmap_y
	input$facetHeatmap
	input$showCRU
	isolate({
		d <- dat()
		if(input$showCRU & !is.null(CRU())){
			n.d <- nrow(d)
			mods.d <- unique(d$Model)
			yrs.tmp <- as.numeric(c(as.character(d$Year), as.character(CRU()$Year)))
			d <- data.frame(rbind(d[1:7], CRU()[1:7]), Year=yrs.tmp, rbind(d[9:ncol(d)], CRU()[9:ncol(CRU())]))
			d$Year <- yrs.tmp
			d$Source <- factor(c(rep("Modeled", n.d), rep("Observed", nrow(CRU()))))
			d$Model <- factor(d$Model, levels=c(CRU()$Model[1], mods.d))
		}
		if(!is.null(input$heatmap_x) & !is.null(input$heatmap_y)){
			x <- c(input$heatmap_x, input$heatmap_y)
			if(!(is.null(input$facetHeatmap) || input$facetHeatmap=="None")) x <- c(x, input$facetHeatmap)
			if(dat()$Var[1]=="Temperature") d <- ddply(d, x, summarise, Mean=round(mean(Val), 1), SD=round(sd(Val), 1))
			if(dat()$Var[1]=="Precipitation") d <- ddply(d, x, summarise, Mean=round(mean(Val)), Total=round(sum(Val)), SD=round(sd(Val)))
			if(all(is.na(d$SD))) d <- d[, -ncol(d)]
		}
	})
	d
})

dat2 <- reactive({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(!is.null(dat_master()) && length(input$vars)>1) dcast(dat_master(), Phase + Model + Scenario + Domain + Month + Year + Decade ~ Var, value.var="Val") else NULL
	)
})

CRU_master <- reactive({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(is.null(Months_original()) | is.null(input$vars) | is.null(input$units) | is.null(scenarios()) | is.null(models_original()) | locSelected()==FALSE){
			x <- NULL
		} else {
			if(input$loctype=="Cities" && length(input$locs_cities) && input$locs_cities[1]!="") {
				x <- subset(d.cities.cru31, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4) & Domain %in% input$locs_cities)
			} else if(is.character(input$map_shape_click$id) && input$map_shape_click$id[1]!="") {
				x <- subset(d.cities.cru31, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4) & Domain %in% input$map_shape_click$id)
			} else if(input$loctype=="Regions"){
				x <- subset(d.cru31, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4) & Domain %in% input$locs_regions)
			}
			if(nrow(x)==0) return()
			if(!is.null(input$months2seasons) && input$months2seasons) x <- collapseMonths(x, as.numeric(input$n_seasons), Months_original())
			if(!is.null(input$decades2periods) && input$decades2periods) x <- periodsFromDecades(x, as.numeric(input$n_periods), Decades_original(), check.years=TRUE)
			if(is.null(x)) return()
			#print(input$map_shape_click$id)
			# data from only one phase with multiple models in that phase selected, or two phases with equal number > 1 of models selected from each phase.
			# Otherwise compositing prohibited.
			if(input$units=="F, in"){
				x$Val[x$Var=="Temperature"] <- round((9/5)*x$Val[x$Var=="Temperature"] + 32,1)
				x$Val[x$Var=="Precipitation"] <- round(x$Val[x$Var=="Precipitation"]/25.4,3)
			}
			rownames(x) <- NULL
			x$Model <- x$Scenario <- x$Phase <- "CRU 3.1"
			x <- x[c(ncol(x) - c(2:0), 1:(ncol(x)-3))]
		}
	)
	x
})

CRU <- reactive({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(is.null(CRU_master())){
			x <- NULL
		} else {
			x <- subset(CRU_master(), Var %in% input$vars[1]) # only one (first) climate variable permitted for use in TS plot, even if user selects multiple
			rownames(x) <- NULL
		}
	)
	x
})

CRU2 <- reactive({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(!is.null(CRU_master()) && length(input$vars)>1) dcast(CRU_master(), Phase + Model + Scenario + Domain + Month + Year + Decade ~ Var, value.var="Val") else NULL
	)
})

# ggplot2 grouping, faceting, pooling
groupFacetChoicesTS <- reactive({
	if(!is.null(input$xtime)){
		if(input$xtime=="Year") {
			ind <- which(unlist(lapply(list(phases, models(), scenarios(), Months(), Decades(), Locs()), length))>1)
			choices <- c("Phase","Model","Scenario","Month","Decade","Domain")[ind]
		} else if(input$xtime=="Month") {
			ind <- which(unlist(lapply(list(phases, models(), scenarios(),Decades(), Locs()), length))>1)
			choices <- c("Phase","Model","Scenario","Decade","Domain")[ind]
		} else if(input$xtime=="Decade") {
			ind <- which(unlist(lapply(list(phases, models(), scenarios(),Months(), Locs()), length))>1)
			choices <- c("Phase","Model","Scenario","Month","Domain")[ind]
		}
		choices <- c("None", choices)
		if(length(scenarios()) < 2) choices <- choices[choices!="Scenario"]
		if(length(models()) < 2) choices <- choices[choices!="Model"]
		if(!length(input$cmip3scens) | !length(input$cmip5scens)) choices <- choices[choices!="Phase"]
		if(!length(input$cmip3models) | !length(input$cmip5models)) choices <- choices[choices!="Phase"]
		if(!is.null(choices) && length(choices)==1) choices <- NULL
	} else choices <- NULL
	choices
})

n.groups <- reactive({ nGroups(input$group, scenarios(), models(), input$mos, input$decs, Locs()) })

facet.panels <- reactive({ getFacetPanels(input$facet, models(), scenarios(), input$mos, input$decs, Locs()) })

pooled.var <- reactive({
	x <- getPooledVars(inx=input$xtime, ingrp=input$group, infct=input$facet, grp.fct.choices=groupFacetChoicesTS(),
			choices=c("Phase","Scenario","Model","Month","Year","Decade","Domain"),
			mos=Months(), years=currentYears(), decades=Decades(), domains=Locs(), scenarios=scenarios(), models=models(),
			cmip3scens=input$cmip3scens, cmip5scens=input$cmip5scens, cmip3mods=input$cmip3models, cmip5mods=input$cmip5models)
	x
})

subjectChoices <- reactive({ getSubjectChoices(inx=input$xtime, ingrp=input$group, pooled.vars=pooled.var()) })

groupFacetChoicesScatter <- reactive({
	ind <- which(unlist(lapply(list(phases, models(), scenarios(), Months(), Decades(), Locs()), length))>1)
	choices <- c("None", c("Phase","Model","Scenario","Month","Decade","Domain")[ind])
	if(!is.null(choices)){
		if(length(scenarios()) < 2) choices <- choices[choices!="Scenario"]
		if(length(models()) < 2) choices <- choices[choices!="Model"]
		if(!length(input$cmip3scens) | !length(input$cmip5scens)) choices <- choices[choices!="Phase"]
		if(!length(input$cmip3models) | !length(input$cmip5models)) choices <- choices[choices!="Phase"]
		if(!is.null(choices) && length(choices)==1) choices <- NULL
	} else choices <- NULL
	choices
})

n.groups2 <- reactive({ nGroups(input$group2, scenarios(), models(), input$mos, input$decs, Locs()) })

facet.panels2 <- reactive({ getFacetPanels(input$facet2, models(), scenarios(), input$mos, input$decs, Locs()) })

pooled.var2 <- reactive({
	x <- getPooledVars(inx=input$xy, ingrp=input$group2, infct=input$facet2, grp.fct.choices=groupFacetChoicesScatter(),
			choices=c("Phase","Scenario","Model","Month","Year","Decade","Domain"),
			mos=Months(), years=currentYears(), decades=Decades(), domains=Locs(), scenarios=scenarios(), models=models(),
			cmip3scens=input$cmip3scens, cmip5scens=input$cmip5scens, cmip3mods=input$cmip3models, cmip5mods=input$cmip5models)
	x
})

heatmap_x_choices <- reactive({
	getHeatmapAxisChoices(scenarios(), models(), Locs(), Months(), currentYears(), Decades(),
		input$cmip3scens, input$cmip5scens, input$cmip3models, input$cmip5models)
})

heatmap_y_choices <- reactive({
	getHeatmapAxisChoices(scenarios(), models(), Locs(), Months(), currentYears(), Decades(),
		input$cmip3scens, input$cmip5scens, input$cmip3models, input$cmip5models)
})

facetChoicesHeatmap <- reactive({ getFacetChoicesHeatmap(inx=input$heatmap_x, iny=input$heatmap_y, x.choices=heatmap_x_choices()) })

facetPanelsHeatmap <- reactive({ getFacetPanels(input$facetHeatmap, models(), scenarios(), input$mos, input$decs, Locs()) })

pooledVarHeatmap <- reactive({
	x <- getPooledVars(inx=input$heatmap_x, iny=input$heatmap_y, infct=input$facetHeatmap, grp.fct.choices=facetChoicesHeatmap(),
			choices=c("Phase","Scenario","Model","Month","Year","Decade","Domain"),
			mos=Months(), years=currentYears(), decades=Decades(), domains=Locs(), scenarios=scenarios(), models=models(),
			cmip3scens=input$cmip3scens, cmip5scens=input$cmip5scens, cmip3mods=input$cmip3models, cmip5mods=input$cmip5models)
	x
})

xvarChoices <- reactive({
		ind <- which(unlist(lapply(list(phases, scenarios(), models(), Locs(), Months(), currentYears(), Decades()), length))>1)
		if(length(ind)) choices <- c("Phase","Scenario", "Model", "Domain", "Month", "Year", "Decade")[ind] else choices <- NULL
		if(length(choices)){
			if(length(scenarios()) < 2) choices <- choices[choices!="Scenario"]
			if(length(models()) < 2) choices <- choices[choices!="Model"]
			if(!length(input$cmip3scens) | !length(input$cmip5scens)) choices <- choices[choices!="Phase"]
			if(!length(input$cmip3models) | !length(input$cmip5models)) choices <- choices[choices!="Phase"]
		} else choices <- NULL
	choices
})

groupFacetChoicesVar <- reactive({
	if(!is.null(input$xvar)){
		ind <- which(unlist(lapply(list(phases, models(), scenarios(), Months(), Decades(), Locs()), length))>1)
		choices <- c("None", c("Phase","Model","Scenario","Month","Decade","Domain")[ind])
		if(!is.null(choices)){
			choices <- choices[choices!=input$xvar]
			if(length(scenarios()) < 2) choices <- choices[choices!="Scenario"]
			if(length(models()) < 2) choices <- choices[choices!="Model"]
			if(!length(input$cmip3scens) | !length(input$cmip5scens)) choices <- choices[choices!="Phase"]
			if(!length(input$cmip3models) | !length(input$cmip5models)) choices <- choices[choices!="Phase"]
			if(!is.null(choices) && length(choices)==1) choices <- NULL
		} else choices <- NULL
	} else choices <- NULL
	choices
})

n.groups3 <- reactive({ nGroups(input$group3, scenarios(), models(), input$mos, input$decs, Locs()) })

facet.panels3 <- reactive({ getFacetPanels(input$facet3, models(), scenarios(), input$mos, input$decs, Locs()) })

pooled.var3 <- reactive({
	x <- getPooledVars(inx=input$xvar, ingrp=input$group3, infct=input$facet3, grp.fct.choices=groupFacetChoicesVar(),
			choices=c("Phase","Scenario","Model","Month","Year","Decade","Domain"),
			mos=Months(), years=currentYears(), decades=Decades(), domains=Locs(), scenarios=scenarios(), models=models(),
			cmip3scens=input$cmip3scens, cmip5scens=input$cmip5scens, cmip3mods=input$cmip3models, cmip5mods=input$cmip5models)
	x
})

subjectChoices3 <- reactive({ getSubjectChoices(inx=input$xvar, ingrp=input$group3, pooled.vars=pooled.var3()) })

Variability <- reactive({ if(!is.null(input$variability)) !input$variability else NULL })

# Data aggregation
datCollapseGroups <- reactive({
	if(!is.null(dat()) & !is.null(input$group)){
		d <- dat()
		d[input$group] <- rep("Average",nrow(dat()))
		d
	} else return()
})

datCollapsePooled <- reactive({
	if(!is.null(dat())){
		d <- dat()
		if(!is.null(pooled.var())) for(k in 1:length(pooled.var())) d[pooled.var()[k]] <- rep("Average",nrow(dat()))
		d
	} else return()
})

datCollapseGroups2 <- reactive({
	if(!is.null(dat2()) & !is.null(input$group)){
		d <- dat2()
		d[input$group] <- rep("Average",nrow(dat2()))
		d
	} else return()
})

datCollapsePooled2 <- reactive({
	if(!is.null(dat2())){
		d <- dat2()
		if(!is.null(pooled.var())) for(k in 1:length(pooled.var())) d[pooled.var()[k]] <- rep("Average",nrow(dat2()))
		d
	} else return()
})

stat <- reactive({
	if(!is.null(input$variability)){
		if(input$variability) stat <- input$errorBars else stat <- input$dispersion
	}
	if(is.null(stat)) stat <- "SD"
	stat
})

# Plotting/subsetting/staging
allModelScenPair <- reactive({
	if(modelScenPair1() & modelScenPair2()) TRUE else FALSE
})

anyModelScenPair <- reactive({
	if(modelScenPair1() | modelScenPair2()) TRUE else FALSE
})

modelScenPair1 <- reactive({
	if(length(input$cmip3scens) & length(input$cmip3models)) TRUE else FALSE
})

modelScenPair2 <- reactive({
	if(length(input$cmip5scens) & length(input$cmip5models)) TRUE else FALSE
})

plot_ts_title <- reactive({ getPlotTitle(grp=input$group, facet=input$facet, pooled=pooled.var(), yrs=range(limitedYears()), mos=input$mos, mod=models(), scen=scenarios(), dom=Locs()) })
plot_sp_title <- reactive({ getPlotTitle(grp=input$group2, facet=input$facet2, pooled=pooled.var2(), yrs=range(limitedYears()), mos=input$mos, mod=models(), scen=scenarios(), dom=Locs()) })
plot_hm_title <- reactive({ getPlotTitle(grp="", facet=input$facetHeatmap, pooled=pooledVarHeatmap(), yrs=range(limitedYears()), mos=input$mos, mod=models(), scen=scenarios(), dom=Locs()) })
plot_var_title <- reactive({ getPlotTitle(grp=input$group3, facet=input$facet3, pooled=pooled.var3(), yrs=range(limitedYears()), mos=input$mos, mod=models(), scen=scenarios(), dom=Locs()) })

plot_ts_subtitle <- reactive({ getPlotSubTitle(pooled=pooled.var(), yrs=limitedYears(), mos=input$mos, mod=models(), scen=scenarios(), dom=Locs()) })
plot_sp_subtitle <- reactive({ getPlotSubTitle(pooled=pooled.var2(), yrs=limitedYears(), mos=input$mos, mod=models(), scen=scenarios(), dom=Locs()) })
plot_hm_subtitle <- reactive({ getPlotSubTitle(pooled=pooledVarHeatmap(), yrs=limitedYears(), mos=input$mos, mod=models(), scen=scenarios(), dom=Locs()) })
plot_var_subtitle <- reactive({ getPlotSubTitle(pooled=pooled.var3(), yrs=limitedYears(), mos=input$mos, mod=models(), scen=scenarios(), dom=Locs()) })

permitPlot <- reactive({
	if(!( is.null(Months()) | is.null(currentYears()) | is.null(Decades()) | is.null(input$vars) |
		is.null(input$units) | is.null(scenarios()) | is.null(models()) | (!length(Locs()) && !length(input$cities)) )){
		if(input$vars[1]!="" & anyModelScenPair()){
			x <- TRUE
		} else {
			x <- FALSE
		}
	} else x <- FALSE
	x
})
