# Datasets, scenarios, models, years, decades
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

Months <- reactive({
	x <- input$mos
	if(!length(x)) x <- month.abb
	x
})

Decades <- reactive({
	x <- input$decs
	if(!length(x)) x <- decades
	x
})

regionSelected <- reactive({ length(input$doms) > 0 })
citySelected <- reactive({ length(input$cities) > 0 })
locSelected <- reactive({ regionSelected() | citySelected() })

#loadData <- reactive({
#	if(length(input$loc)){
#		if(length(input$loc)>=1 & input$cond=="Location"){
#			for(i in 1:length(input$loc)) if(!exists(input$loc[i], envir=.GlobalEnv)) load(paste("data/",input$loc[i],".RData",sep=""), envir=.GlobalEnv)
#		} else {
#			if(!exists(input$loc[1], envir=.GlobalEnv)) load(paste("data/",input$loc[1],".RData",sep=""), envir=.GlobalEnv)
#		}
#	}
#})
	
# Initially retain all climate variables regardless of user's selection
dat_master <- reactive({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(is.null(Months()) | is.null(currentYears()) | is.null(Decades()) | is.null(input$vars) | is.null(input$units) | is.null(scenarios()) | is.null(models_original()) | locSelected()==FALSE){
			x <- NULL
		} else {
			if(length(input$cities) && input$cities[1]!="") {
				city.ind <- which(city.names==input$cities)
				load(city.gcm.files[city.ind], envir=environment())
				x <- subset(city.dat, Month %in% month.abb[match(Months(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades(),1,4) & 
					Scenario %in% scenarios() & Model %in% models_original() & Domain %in% input$cities)
			} else if(is.character(input$map_shape_click$id) && input$map_shape_click$id[1]!="") {
				city.ind <- which(city.names==input$map_shape_click$id)
				load(city.gcm.files[city.ind], envir=environment())
				x <- subset(city.dat, Month %in% month.abb[match(Months(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades(),1,4) & 
					Scenario %in% scenarios() & Model %in% models_original() & Domain %in% input$map_shape_click$id)
			} else {
				region.ind <- which(region.names %in% input$doms)
				for(i in 1:length(region.ind)) {
					load(region.gcm.files[region.ind[i]])
					if(i==1) region.dat.final <- region.dat else region.dat.final <- rbind(region.dat.final, region.dat)
				}
				x <- subset(region.dat, Month %in% month.abb[match(Months(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades(),1,4) & 
					Scenario %in% scenarios() & Model %in% models_original() & Domain %in% input$doms)
			}
			#print(input$map_shape_click$id)
			# data from only one phase with multiple models in that phase selected, or two phases with equal number > 1 of models selected from each phase.
			# Otherwise compositing prohibited.
			if(composite()==2){ # can assume both phases have multiple models, so split always works nicely
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
				x$Val[x$Var=="Temperature"] <- round((9/5)*x$Val[x$Var=="Temperature"] + 32,1)
				x$Val[x$Var=="Precipitation"] <- round(x$Val[x$Var=="Precipitation"]/25.4,3)
			}
			rownames(x) <- NULL
		}
	)
	#browser()
	x
})

dat <- reactive({
	if(is.null(dat_master())){
		x <- NULL
	} else {
		x <- subset(dat_master(), Var %in% input$vars[1]) # only one (first) climate variable permitted for use in TS plot, even if user selects multiple
		rownames(x) <- NULL
	}
	x
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
		if(is.null(Months()) | is.null(currentYears()) | is.null(Decades()) | is.null(input$vars) | is.null(input$units) | is.null(scenarios()) | is.null(models_original()) | locSelected()==FALSE){
			x <- NULL
		} else {
			if(length(input$cities) && input$cities[1]!="") {
				x <- subset(d.cities.cru31, Month %in% month.abb[match(Months(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades(),1,4) & Domain %in% input$cities)
			} else if(is.character(input$map_shape_click$id) && input$map_shape_click$id[1]!="") {
				x <- subset(d.cities.cru31, Month %in% month.abb[match(Months(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades(),1,4) & Domain %in% input$map_shape_click$id)
			} else {
				x <- subset(d.cru31, Month %in% month.abb[match(Months(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades(),1,4) & Domain %in% input$doms)
			}
			if(nrow(x)==0) return()
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
	if(is.null(CRU_master())){
		x <- NULL
	} else {
		x <- subset(CRU_master(), Var %in% input$vars[1]) # only one (first) climate variable permitted for use in TS plot, even if user selects multiple
		rownames(x) <- NULL
	}
	x
})

CRU2 <- reactive({
	if(is.null(input$goButton) || input$goButton==0) return()
	isolate(
		if(!is.null(CRU_master()) && length(input$vars)>1) dcast(CRU_master(), Phase + Model + Scenario + Domain + Month + Year + Decade ~ Var, value.var="Val") else NULL
	)
})

# ggplot2 grouping, faceting, pooling
group.choices <- reactive({
	if(!is.null(input$xtime)){
		if(input$xtime=="Year") {
			ind <- which(unlist(lapply(list(phases, models(), scenarios(), Months(), Decades(), input$doms), length))>1)
			choices <- c("Phase","Model","Scenario","Month","Decade","Domain")[ind]
		} else if(input$xtime=="Month") {
			ind <- which(unlist(lapply(list(phases, models(), scenarios(),Decades(), input$doms), length))>1)
			choices <- c("Phase","Model","Scenario","Decade","Domain")[ind]
		} else if(input$xtime=="Decade") {
			ind <- which(unlist(lapply(list(phases, models(), scenarios(),Months(), input$doms), length))>1)
			choices <- c("Phase","Model","Scenario","Month","Domain")[ind]
		}
		choices <- c("None/Force Pool", choices)
		if(length(scenarios()) < 2) choices <- choices[choices!="Scenario"]
		if(length(models()) < 2) choices <- choices[choices!="Model"]
		if(!length(input$cmip3scens) | !length(input$cmip5scens)) choices <- choices[choices!="Phase"]
		if(!length(input$cmip3models) | !length(input$cmip5models)) choices <- choices[choices!="Phase"]
		if(!is.null(choices) && length(choices)==1) choices <- NULL
	} else choices <- NULL
	choices
})

n.groups <- reactive({
	if(is.null(input$group) || input$group=="None/Force Pool") return(1)
	if(input$group=="Phase") return(2)
	if(input$group=="Model") return(length(models()))
	if(input$group=="Scenario") return(length(scenarios()))
	long <- c("Month","Decade","Domain")
	short <- c("mos","decs","doms")
	return(eval(parse(text=sprintf("length(input$%s)",short[which(long==input$group)]))))
})

facet.choices <- reactive({	getFacetChoices(inx=input$xtime, ingrp=input$group, grp.choices=group.choices()) })

facet.panels <- reactive({
	if(!is.null(input$facet)){
		if(input$facet!="None/Force Pool"){
			if(input$facet=="Phase") return(2)
			if(input$facet=="Model") return(length(models()))
			if(input$facet=="Scenario") return(length(scenarios()))
			long <- c("Month","Decade","Domain")
			short <- c("mos","decs","doms")
			eval(parse(text=sprintf("n <- length(input$%s)", short[which(long==input$facet)])))
			if(!exists("n")) n <- NULL
		} else n <- NULL
	} else n <- NULL
	n
})

pooled.var <- reactive({
	x <- getPooledVars(inx=input$xtime, ingrp=input$group, infct=input$facet, grp.choices=group.choices(), fct.choices=facet.choices(),
			choices=c("Phase","Scenario","Model","Month","Year","Decade","Domain"),
			mos=Months(), years=currentYears(), decades=Decades(), domains=input$doms, scenarios=scenarios(), models=models(),
			cmip3scens=input$cmip3scens, cmip5scens=input$cmip5scens, cmip3mods=input$cmip3models, cmip5mods=input$cmip5models)
	x
})

subjectChoices <- reactive({ getSubjectChoices(inx=input$xtime, ingrp=input$group, pooled.vars=pooled.var()) })

subjectSelected <- reactive({
	if(!is.null(input$subjects)) strsplit(input$subjects, "-")[[1]] else NULL
})

group.choices2 <- reactive({
	ind <- which(unlist(lapply(list(phases, models(), scenarios(), Months(), Decades(), input$doms), length))>1)
	choices <- c("None/Force Pool", c("Phase","Model","Scenario","Month","Decade","Domain")[ind])
	if(!is.null(choices)){
		if(length(scenarios()) < 2) choices <- choices[choices!="Scenario"]
		if(length(models()) < 2) choices <- choices[choices!="Model"]
		if(!length(input$cmip3scens) | !length(input$cmip5scens)) choices <- choices[choices!="Phase"]
		if(!length(input$cmip3models) | !length(input$cmip5models)) choices <- choices[choices!="Phase"]
		if(!is.null(choices) && length(choices)==1) choices <- NULL
	} else choices <- NULL
	choices
})

n.groups2 <- reactive({
	if(is.null(input$group2) || input$group2=="None/Force Pool") return(1)
	if(input$group2=="Phase") return(2)
	if(input$group2=="Model") return(length(models()))
	if(input$group2=="Scenario") return(length(scenarios()))
	long <- c("Month","Decade","Domain")
	short <- c("mos","decs","doms")
	return(eval(parse(text=sprintf("length(input$%s)",short[which(long==input$group2)]))))
})

facet.choices2 <- reactive({ getFacetChoices(inx=input$xy, ingrp=input$group2, grp.choices=group.choices2()) })

facet.panels2 <- reactive({
	if(!is.null(input$facet2)){
		if(input$facet2!="None/Force Pool"){
			if(input$facet2=="Phase") return(2)
			if(input$facet2=="Model") return(length(models()))
			if(input$facet2=="Scenario") return(length(scenarios()))
			long <- c("Month","Decade","Domain")
			short <- c("mos","decs","doms")
			eval(parse(text=sprintf("n <- length(input$%s)", short[which(long==input$facet2)])))
			if(!exists("n")) n <- NULL
		} else n <- NULL
	} else n <- NULL
	n
})

pooled.var2 <- reactive({
	x <- getPooledVars(inx=input$xy, ingrp=input$group2, infct=input$facet2, grp.choices=group.choices2(), fct.choices=facet.choices2(),
			choices=c("Phase","Scenario","Model","Month","Year","Decade","Domain"),
			mos=Months(), years=currentYears(), decades=Decades(), domains=input$doms, scenarios=scenarios(), models=models(),
			cmip3scens=input$cmip3scens, cmip5scens=input$cmip5scens, cmip3mods=input$cmip3models, cmip5mods=input$cmip5models)
	x
})

xvarChoices <- reactive({
		ind <- which(unlist(lapply(list(phases, scenarios(), models(), input$doms, Months(), currentYears(), Decades()), length))>1)
		if(length(ind)) choices <- c("Phase","Scenario", "Model", "Domain", "Month", "Year", "Decade")[ind] else choices <- NULL
		if(length(choices)){
			if(length(scenarios()) < 2) choices <- choices[choices!="Scenario"]
			if(length(models()) < 2) choices <- choices[choices!="Model"]
			if(!length(input$cmip3scens) | !length(input$cmip5scens)) choices <- choices[choices!="Phase"]
			if(!length(input$cmip3models) | !length(input$cmip5models)) choices <- choices[choices!="Phase"]
		} else choices <- NULL
	choices
})

group.choices3 <- reactive({
	if(!is.null(input$xvar)){
		ind <- which(unlist(lapply(list(phases, models(), scenarios(), Months(), Decades(), input$doms), length))>1)
		choices <- c("None/Force Pool", c("Phase","Model","Scenario","Month","Decade","Domain")[ind])
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

n.groups3 <- reactive({
	if(is.null(input$group3) || input$group3=="None/Force Pool") return(1)
	if(input$group3=="Phase") return(2)
	if(input$group3=="Model") return(length(models()))
	if(input$group3=="Scenario") return(length(scenarios()))
	long <- c("Month","Decade","Domain")
	short <- c("mos","decs","doms")
	return(eval(parse(text=sprintf("length(input$%s)",short[which(long==input$group3)]))))
})

facet.choices3 <- reactive({
	x <- getFacetChoices(inx=input$xvar, ingrp=input$group3, grp.choices=group.choices3())
	#if(!is.null(x)){
	#	NULL # add more later
	#}
	x
})

facet.panels3 <- reactive({
	if(!is.null(input$facet3)){
		if(input$facet3!="None/Force Pool"){
			if(input$facet3=="Phase") return(2)
			if(input$facet3=="Model") return(length(models()))
			if(input$facet3=="Scenario") return(length(scenarios()))
			long <- c("Month","Decade","Domain")
			short <- c("mos","decs","doms")
			eval(parse(text=sprintf("n <- length(input$%s)", short[which(long==input$facet3)])))
			if(!exists("n")) n <- NULL
		} else n <- NULL
	} else n <- NULL
	n
})

pooled.var3 <- reactive({
	x <- getPooledVars(inx=input$xvar, ingrp=input$group3, infct=input$facet3, grp.choices=group.choices3(), fct.choices=facet.choices3(),
			choices=c("Phase","Scenario","Model","Month","Year","Decade","Domain"),
			mos=Months(), years=currentYears(), decades=Decades(), domains=input$doms, scenarios=scenarios(), models=models(),
			cmip3scens=input$cmip3scens, cmip5scens=input$cmip5scens, cmip3mods=input$cmip3models, cmip5mods=input$cmip5models)
	x
})

subjectChoices3 <- reactive({ getSubjectChoices(inx=input$xvar, ingrp=input$group3, pooled.vars=pooled.var3()) })

subjectSelected3 <- reactive({
	if(!is.null(input$subjects3)) strsplit(input$subjects3, "-")[[1]] else NULL
})

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

plot_ts_title <- reactive({ getPlotTitle(grp=input$group, facet=input$facet, pooled=pooled.var(), yrs=range(limitedYears()), mos=input$mos, mod=models(), scen=scenarios(), dom=input$doms) })
plot_sp_title <- reactive({ getPlotTitle(grp=input$group2, facet=input$facet2, pooled=pooled.var2(), yrs=range(limitedYears()), mos=input$mos, mod=models(), scen=scenarios(), dom=input$doms) })
plot_var_title <- reactive({ getPlotTitle(grp=input$group3, facet=input$facet3, pooled=pooled.var3(), yrs=range(limitedYears()), mos=input$mos, mod=models(), scen=scenarios(), dom=input$doms) })

plot_ts_subtitle <- reactive({ getPlotSubTitle(pooled=pooled.var(), yrs=limitedYears(), mos=input$mos, mod=models(), scen=scenarios(), dom=input$doms) })
plot_sp_subtitle <- reactive({ getPlotSubTitle(pooled=pooled.var2(), yrs=limitedYears(), mos=input$mos, mod=models(), scen=scenarios(), dom=input$doms) })
plot_var_subtitle <- reactive({ getPlotSubTitle(pooled=pooled.var3(), yrs=limitedYears(), mos=input$mos, mod=models(), scen=scenarios(), dom=input$doms) })

permitPlot <- reactive({
	if(!(is.null(Months()) | is.null(currentYears()) | is.null(Decades()) | is.null(input$vars) | is.null(input$units) | is.null(scenarios()) | is.null(models()) | is.null(input$doms))){
		if(!(Months()[1]=="" | input$vars[1]=="" | input$units=="" | input$doms[1]=="") & anyModelScenPair()){
			x <- TRUE
		} else {
			x <- FALSE
		}
	} else x <- FALSE
	x
})
