# @knitr re_01_06
goBtnNullOrZero <- reactive({ nullOrZero(input$goButton) })

twoBtnNullOrZero_ts <- reactive({ goBtnNullOrZero() || nullOrZero(input$plotButton_ts) })

twoBtnNullOrZero_sc <- reactive({ goBtnNullOrZero() || nullOrZero(input$plotButton_sc) })

twoBtnNullOrZero_hm <- reactive({ goBtnNullOrZero() || nullOrZero(input$plotButton_hm) })

twoBtnNullOrZero_vr <- reactive({ goBtnNullOrZero() || nullOrZero(input$plotButton_vr) })

twoBtnNullOrZero_sp <- reactive({ goBtnNullOrZero() || nullOrZero(input$plotButton_sp) })

#anyBtnNullOrZero <- reactive({ any(c(goBtnNullOrZero(), twoBtnNullOrZero_ts(), twoBtnNullOrZero_ts(), twoBtnNullOrZero_ts(), twoBtnNullOrZero_ts(), twoBtnNullOrZero_ts())) })

# @knitr re_07_14
Decades_original <- reactive({
	x <- sort(input$decs)
	if(!length(x)) x <- decades
	x
})

currentYears <- reactive({ if(!is.null(input$yrs)) as.numeric(input$yrs[1]):as.numeric(input$yrs[2]) })

Months_original <- reactive({
	#x <- input$mos[order(match(input$mos, month.abb))]
    x <- input$mos
	if(!length(x)) x <- month.abb
	x
})

Decades <- reactive({
	x <- Decades_original()
	if(!is.null(input$decades2periods)){
		if(input$decades2periods & !is.null(dat_master())) x <- unique(dat_master()$Decade)
	}
	x
})

limitedYears <- reactive({
	rng <- range(as.numeric(substr(Decades(),1,4))) + c(0,9)
	yrs <- intersect(currentYears(), seq(rng[1], rng[2]))
	yrs
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


PeriodLength <- reactive({
	if(length(input$decs)<=1) NULL else periodLength(x=as.numeric(substr(input$decs,1,4))/10)
})

# @knitr re_15_22
modelScenPair1 <- reactive({
	if(length(input$cmip3scens) & length(input$cmip3models)) TRUE else FALSE
})

modelScenPair2 <- reactive({
	if(length(input$cmip5scens) & length(input$cmip5models)) TRUE else FALSE
})

allModelScenPair <- reactive({
	if(modelScenPair1() & modelScenPair2()) TRUE else FALSE
})

anyModelScenPair <- reactive({
	if(modelScenPair1() | modelScenPair2()) TRUE else FALSE
})

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

# @knitr re_23_28
currentUnits <- reactive({ if(input$convert_units) c("F", "in") else c("C", "mm") })

aggStatsID <- reactive({
	if(input$loctype=="Cities") return("Val")
    agg.stat.colnames[which(agg.stat.names==input$aggStats)]
})

aggStatsID2 <- reactive({
    if(input$loctype=="Cities") return("Val")
	agg.stat.colnames[which(agg.stat.names==input$aggStats2)]
})

aggStats <- reactive({ unique(c(aggStatsID(), aggStatsID2())) })

naggStats <- reactive({ length(aggStats()) })

BootSamples <- reactive({
	x <- as.numeric(input$bootSamples)
	if(is.na(x) || x > 10000) x <- 50
	x
})

# @knitr re_29_32
Locs <- reactive({ if(is.null(input$loctype) || input$loctype!="Cities")  input$locs_regions else if(input$loctype=="Cities") input$locs_cities else NULL })

regionSelected <- reactive({ input$loctype!="Cities" & length(Locs())  })

citySelected <- reactive({ input$loctype=="Cities" & length(Locs()) })

locSelected <- reactive({ length(Locs()) })

# @knitr re_33_43
plot_ts_title <- reactive({ getPlotTitle(grp=input$group, facet=input$facet, pooled=pooled.var(), yrs=range(limitedYears()), mos=input$mos, mod=models(), scen=scenarios(), loc=Locs()) })
plot_sp_title <- reactive({ getPlotTitle(grp=input$group2, facet=input$facet2, pooled=pooled.var2(), yrs=range(limitedYears()), mos=input$mos, mod=models(), scen=scenarios(), loc=Locs()) })
plot_hm_title <- reactive({ getPlotTitle(grp="", facet=input$facetHeatmap, pooled=pooledVarHeatmap(), yrs=range(limitedYears()), mos=input$mos, mod=models(), scen=scenarios(), loc=Locs()) })
plot_var_title <- reactive({ getPlotTitle(grp=input$group3, facet=input$facet3, pooled=pooled.var3(), yrs=range(limitedYears()), mos=input$mos, mod=models(), scen=scenarios(), loc=Locs()) })
plot_spatial_title <- reactive({ getPlotTitle(grp=input$groupSpatial, facet=input$facetSpatial, pooled=pooledVarSpatial(), yrs=range(limitedYears()), mos=input$mos, mod=models(), scen=scenarios(), loc=Locs()) })

plot_ts_subtitle <- reactive({ getPlotSubTitle(pooled=pooled.var(), yrs=limitedYears(), mos=input$mos, mod=models(), scen=scenarios(), loc=Locs()) })
plot_sp_subtitle <- reactive({ getPlotSubTitle(pooled=pooled.var2(), yrs=limitedYears(), mos=input$mos, mod=models(), scen=scenarios(), loc=Locs()) })
plot_hm_subtitle <- reactive({ getPlotSubTitle(pooled=pooledVarHeatmap(), yrs=limitedYears(), mos=input$mos, mod=models(), scen=scenarios(), loc=Locs()) })
plot_var_subtitle <- reactive({ getPlotSubTitle(pooled=pooled.var3(), yrs=limitedYears(), mos=input$mos, mod=models(), scen=scenarios(), loc=Locs()) })
plot_spatial_subtitle <- reactive({ getPlotSubTitle(pooled=pooledVarSpatial(), yrs=limitedYears(), mos=input$mos, mod=models(), scen=scenarios(), loc=Locs()) })

permitPlot <- reactive({
	if(!( is.null(Months()) | is.null(currentYears()) | is.null(Decades()) | is.null(input$vars) |
		is.null(input$convert_units) | is.null(scenarios()) | is.null(models()) | (!length(Locs()) && !length(input$locs_cities)) )){
		if(input$vars[1]!="" & anyModelScenPair()){
			x <- TRUE
		} else {
			x <- FALSE
		}
	} else x <- FALSE
	x
})

# @knitr re_44
# Initially retain all climate variables regardless of user's selection
dat_master <- reactive({
	if(goBtnNullOrZero()) return()
	prog_d_master <- Progress$new(session, min=0, max=10)
	on.exit(prog_d_master$close())
	isolate(
		if(is.null(Months_original()) | is.null(input$vars) | is.null(scenarios()) | is.null(models_original()) | locSelected()==FALSE){
			x <- NULL
		} else {
			prog_d_master$set(message="Loading GCM aggregate time series statistics...", value=1)
			if(input$loctype=="Cities" && length(input$locs_cities) && input$locs_cities[1]!="") {
				city.ind <- which(city.names %in% Locs())
				for(i in 1:length(city.ind)) { # currently, akcan 2-km res files are forced. 10-min files not used.
					load(city.gcm.files[city.ind[i]], envir=environment())
					if(i==1) city.dat.final <- city.dat else city.dat.final <- rbind(city.dat.final, city.dat)
				}
				prog_d_master$set(message="Subsetting GCM time series data...", value=2.5)
				x <- data.table(subset(city.dat.final, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4) & 
					Scenario %in% scenarios() & Model %in% models_original() & Location %in% input$locs_cities))
			} else if(input$loctype!="Cities"){
				reg.nam <- sort(region.names.out[[input$loctype]])
				region.ind <- which(reg.nam %in% Locs())
				for(i in 1:length(region.ind)) {
					filename <- switch(input$vars[1], Temperature="stats_climate", Precipitation="stats_climate")
					load(paste0(region.gcm.stats.files[[input$loctype]][region.ind[i]], "/", filename, ".RData"), envir=environment()) # Still can only load onevariable file, okay as long as app only contains T & P
					gcm.stats.df[,stats.columns] <- region.dat
					gcm.stats.df$Location <- reg.nam[region.ind[i]]
					if(i==1) region.dat.final <- gcm.stats.df else region.dat.final <- rbind(region.dat.final, gcm.stats.df)
				}
				prog_d_master$set(message="Subsetting GCM time series data...", value=2.5)
				cols.drop <- match(agg.stat.colnames[which(!(agg.stat.colnames %in% aggStats()))], names(region.dat.final))
				x <- subset(region.dat.final, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4) & 
					Scenario %in% scenarios() & Model %in% models_original(), select=-cols.drop)
				x <- data.table(x) # make this a data table in the next round of processing the input workspaces and then remove from here
			}
			if(!is.null(input$months2seasons) && input$months2seasons){
				prog_d_master$set(message="GCM time series: aggregating months...", value=4)
				x <- collapseMonths(x, aggStats(), as.numeric(input$n_seasons), Months_original())
			}
			if(!is.null(input$decades2periods) && input$decades2periods){
				prog_d_master$set(message="GCM time series: aggregating decades...", value=6)
				x <- periodsFromDecades(x, as.numeric(input$n_periods), Decades_original())
			}
			# data from only one phase with multiple models in that phase selected, or two phases with equal number > 1 of models selected from each phase.
			# Otherwise compositing prohibited.
			if(composite() > 0){ # can assume both phases have multiple models, so split always works nicely
				prog_d_master$set(message="Averaging model statistics...", value=8)
				n <- length(input$cmip3models) # will match length(input$cmip5models)
				x <- x[, lapply(1:naggStats(), function(i) round(sum(get(aggStats()[i]))/n, 1)), by=list(Phase, Scenario, Var, Location, Year, Month, Decade)]
				setnames(x, paste0("V", 1:naggStats()), aggStats())
				x[, Model := paste0(Phase, " ", n, "-Model Avg")]
				setcolorder(x, c("Phase", "Scenario", "Model", "Var", "Location", aggStats(), "Year", "Month", "Decade"))
				if("Precipitation" %in% c(input$vars, input$vars2)) for(i in 1:naggStats()) x[Var=="Precipitation", stats.columns[i] := round(get(aggStats()[i]))]
			}
			if(input$convert_units){
			prog_d_master$set(message="Unit conversion...", value=9)
				for(k in 1:naggStats()){
					x[Var=="Temperature", c(aggStats()[k]) := round((9/5)*get(aggStats()[k]) + 32, 1)]
					x[Var=="Precipitation", c(aggStats()[k]) := round(get(aggStats()[k])/25.4, 3)]
				}
			}
			prog_d_master$set(message="GCM statistics complete.", value=10)
		}
	)
	x
})

# @knitr re_46_48
dat <- reactive({
	if(goBtnNullOrZero()) return()
	isolate({
		if(is.null(dat_master())){
			x <- NULL
		} else {
			if(aggStatsID()==aggStatsID2()) keep.cols <- 1:ncol(dat_master()) else keep.cols <- which(!(names(dat_master()) %in% aggStatsID2()))
			x <- subset(dat_master(), Var %in% input$vars, keep.cols) # only one (first) climate variable permitted for use in TS plot
		}
	})
	x
})

dat_heatmap <- reactive({
	if(goBtnNullOrZero() || is.null(dat())) return()
	input$heatmap_x
	input$heatmap_y
	input$facetHeatmap
	input$hm_showCRU
	isolate({
		d <- dat()
		if(input$hm_showCRU & !is.null(CRU())){
			n.d <- nrow(d)
			mods.d <- unique(d$Model)
			d <- rbind(dat(), CRU())
			d$Source <- factor(c(rep("Modeled", n.d), rep("Observed", nrow(CRU()))))
			d$Model <- factor(d$Model, levels=c(CRU()$Model[1], mods.d))
		}
		if(!is.null(input$heatmap_x) & !is.null(input$heatmap_y)){
			x <- c(input$heatmap_x, input$heatmap_y)
			if(!(is.null(input$facetHeatmap) || input$facetHeatmap=="None")) x <- c(x, input$facetHeatmap)
			stat1 <- aggStatsID()
			if(input$vars=="Temperature") d <- ddply(d, x, here(summarise), XMean=round(mean(eval(parse(text=stat1))), 1), XSD=round(sd(eval(parse(text=stat1))), 1))
			if(input$vars=="Precipitation") d <- ddply(d, x, here(summarise), XMean=round(mean(eval(parse(text=stat1)))), XTotal=round(sum(eval(parse(text=stat1)))), XSD=round(sd(eval(parse(text=stat1)))))
			d <- data.table(d)
			setnames(d, gsub("X", "", names(d)))
			if(all(is.na(d$SD))) d[, SD := NULL]
		}
	})
	d
})

dat2 <- reactive({
	if(goBtnNullOrZero()) return()
	isolate({
		x <- NULL
		if(!is.null(dat_master()) && length(input$vars) && length(input$vars2)) x <- data.table(dcast(dat_master(), Phase + Model + Scenario + Location + Year + Month + Decade ~ Var, value.var=aggStatsID())) else x <- NULL
		if(!is.null(x) && aggStatsID()!=aggStatsID2()) x[, input$vars2] <- dat_master()[Var==input$vars2, get(aggStatsID2())]
	})
	x
})

# @knitr re_45
CRU_master <- reactive({
	if(goBtnNullOrZero()) return()
	#prog_d_cru_master <- Progress$new(session, min=1, max=10)
	#on.exit(prog_d_cru_master$close())
	isolate(
		if(is.null(Months_original()) | is.null(input$vars) | is.null(input$convert_units) | locSelected()==FALSE){
			x <- NULL
		} else {
			#prog_d_cru_master$set(message="Loading CRU 3.2 aggregate time series statistics...")
			if(input$loctype=="Cities" && length(input$locs_cities) && input$locs_cities[1]!="") {
				city.ind <- which(city.names %in% Locs())
				for(i in 1:length(city.ind)) { # currently, akcan 2-km res files are forced. 10-min files not used.
					load(city.cru.files[city.ind[i]], envir=environment())
					if(i==1) city.cru.dat.final <- city.cru.dat else city.cru.dat.final <- rbind(city.cru.dat.final, city.cru.dat)
				}
				#prog_d_cru_master$set(message="Subsetting CRU 3.2 time series data...")
				x <- data.table(subset(city.cru.dat.final, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4)))# & 
					#Scenario %in% scenarios() & Model %in% models_original())# & Location %in% input$locs_cities)
			} else if(input$loctype!="Cities"){
				reg.nam <- sort(region.names.out[[input$loctype]])
				region.ind <- which(reg.nam %in% Locs())
				for(i in 1:length(region.ind)) {
					filename <- switch(input$vars[1], Temperature="stats_climate", Precipitation="stats_climate") # Still can only load onevariable file, okay as long as app only contains T & P
					load(paste0(region.cru.stats.files[[input$loctype]][region.ind[i]], "/", filename, ".RData"), envir=environment())
					if(i==1) region.cru.dat.final <- region.cru.dat else region.cru.dat.final <- rbind(region.cru.dat.final, region.cru.dat)
				}
				#prog_d_cru_master$set(message="Subsetting CRU 3.2 time series data...")
				cols.drop <- match(agg.stat.colnames[which(!(agg.stat.colnames %in% aggStats()))], names(region.cru.dat.final))
				x <- subset(region.cru.dat.final, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4), select=-cols.drop)
				x <- data.table(x)
			}
			if(nrow(x)==0) return()
			x$Model <- x$Scenario <- x$Phase <- "CRU 3.2"
			setcolorder(x, c("Phase", "Scenario", "Model", "Var", "Location", aggStats(), "Year", "Month", "Decade"))
			if(!is.null(input$months2seasons) && input$months2seasons){
				#prog_d_cru_master$set(message="CRU 3.2 time series: aggregating months...")
				x <- collapseMonths(x, aggStats(), as.numeric(input$n_seasons), Months_original())
			}
			if(!is.null(input$decades2periods) && input$decades2periods){
				#prog_d_cru_master$set(message="CRU 3.2 time series: aggregating decades...")
				x <- periodsFromDecades(x, as.numeric(input$n_periods), Decades_original(), check.years=TRUE)
			}
			if(is.null(x)) return()
			# data from only one phase with multiple models in that phase selected, or two phases with equal number > 1 of models selected from each phase.
			# Otherwise compositing prohibited.
			if(input$convert_units){
				#prog_d_cru_master$set(message="Unit conversion...")
				for(k in 1:naggStats()){
					x[Var=="Temperature", c(aggStats()[k]) := round((9/5)*get(aggStats()[k]) + 32, 1)]
					x[Var=="Precipitation", c(aggStats()[k]) := round(get(aggStats()[k])/25.4, 3)]
				}
			}
			#prog_d_cru_master$set(message="CRU 3.2 statistics complete.")
		}
	)
	x
})

# @knitr re_49_50
CRU <- reactive({
	if(goBtnNullOrZero()) return()
	isolate(
		if(is.null(CRU_master())){
			x <- NULL
		} else {
			if(aggStatsID()==aggStatsID2()) keep.cols <- 1:ncol(CRU_master()) else keep.cols <- which(!(names(CRU_master()) %in% aggStatsID2()))
			x <- subset(CRU_master(), Var %in% input$vars, keep.cols) # only one (first) climate variable permitted for use in TS plot
			rownames(x) <- NULL
		}
	)
	x
})

CRU2 <- reactive({
	if(goBtnNullOrZero()) return()
	isolate({
		x <- NULL
		if(!is.null(CRU_master()) && length(input$vars) && length(input$vars2)) x <- dcast(CRU_master(), Phase + Model + Scenario + Location + Year + Month + Decade ~ Var, value.var=aggStatsID()) else NULL
		if(!is.null(x) && aggStatsID()!=aggStatsID2()) x[input$vars2] <- CRU_master()[CRU_master()$Var==input$vars2, aggStatsID2()]
	})
	x
})


# @knitr re_51
gcm_samples_files <- reactive({
	if(anyModelScenPair() & length(input$vars)){
		s <- substr(scenarios(), 1, 3)
		AR <- gsub("RCP", "AR5", gsub("SRE", "AR4", s))
		y <- sapply(models_original(), mod2ar)
		x <- list()
		for(i in 1:length(y)){
			x[[i]] <- paste(y[i], c("Hist", gsub(" ", "", scenarios())[AR==y[i]]), models_original()[i], sep="_")
			x[[i]] <- paste0(rep(x[[i]], each=length(input$vars)), "_", input$vars, ".RData")
		}
	} else x <- NULL
	x
})

# @knitr re_52
# Keep first climate variables only
dat_spatial <- reactive({
	if(goBtnNullOrZero()) return()
	prog_d_spatial <- Progress$new(session, min=0, max=10)
	on.exit(prog_d_spatial$close())
	isolate(
		if(is.null(Months_original()) | is.null(input$vars) | is.null(scenarios()) | is.null(models_original()) | locSelected()==FALSE){
			x <- NULL
		} else {
			gc()
			if(input$loctype=="Cities" && length(input$locs_cities) && input$locs_cities[1]!="") { #### Deal with cities under spatial data conditions later
				city.ind <- which(city.names %in% Locs())
				for(i in 1:length(city.ind)) {
					prog_d_spatial$set(message="Loading GCM spatial distributions...", value=1+2*i/length(city.ind))
					load(city.gcm.files[city.ind[i]], envir=environment())
					if(i==1) city.dat.final <- city.dat else city.dat.final <- rbind(city.dat.final, city.dat)
				}
				prog_d_spatial$set(message="Subsetting GCM spatial samples...", value=4)
				x <- subset(city.dat.final, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4) & 
					Scenario %in% scenarios() & Model %in% models_original() & Location %in% input$locs_cities)
			} else if(input$loctype!="Cities"){ #### Regions: only this is under development for now
				prog_d_spatial$set(message="GCM spatial samples...", value=1)
				reg.nam <- sort(region.names.out[[input$loctype]])
				region.ind <- which(reg.nam %in% Locs())
				rsd.list <- vector("list", length(region.ind))
				for(i in 1:length(region.ind)) { # by region
					locDir <- file.path(region.gcm.samples.files[[input$loctype]][region.ind[i]], "climate")
					loc.files <- list.files(locDir, pattern="\\.RData")
					rsd.list1 <- vector("list", length(gcm_samples_files()))
					for(z in 1:length(gcm_samples_files())){ # by model
						mod.files <- gcm_samples_files()[[z]]
						mod.files.list <- split(mod.files, substr(mod.files, nchar(mod.files)-16, nchar(mod.files)-6)) # by variable
						rsd.list2 <- vector("list", length(mod.files.list))
						for(zz in 1:length(mod.files.list)){
							var.files <- mod.files.list[[zz]]
							rsd.list3 <- vector("list", length(var.files)-1)
							for(zzz in 1:length(var.files)){
								load(file.path(locDir, var.files[zzz]), envir=environment()) # Historical df loaded first (*alphabetical*)
								if(zzz==1){
									rsd.h <- subset(rsd.h, Month %in% month.abb[match(Months_original(), month.abb)] & Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4))
									if(nrow(rsd.h) > 0) {
										rsd.h[, Val := Val/samples.multipliers[1]]
										rsd.h[, Prob := Prob/samples.multipliers[2]] # <- rsd.h[,samples.columns]/rep(samples.multipliers, each=nrow(rsd.h))
									}
								}
								if(zzz > 1){
									if(nrow(rsd.h) > 0){
										rsd.h[, Phase := rsd$Phase[1]]
										rsd.h[, Scenario := rsd$Scenario[1]]
										rsd.h[, Model := rsd$Model[1]]
									}
									rsd <- subset(rsd, Month %in% month.abb[match(Months_original(), month.abb)] & Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4))
									if(nrow(rsd) > 0) {
										rsd[, Val := Val/samples.multipliers[1]]
										rsd[, Prob := Prob/samples.multipliers[2]]
										if(nrow(rsd.h) > 0) rsd.list3[[zzz-1]] <- rbind(rsd.h, rsd) else rsd.list3[[zzz-1]] <- rsd
									} else if(nrow(rsd.h) > 0) {
										rsd.list3[[zzz-1]] <- rsd.h
									} else return(NULL)
								}
							}
							rsd.list2[[zz]] <- rbindlist(rsd.list3)
							rm(rsd.list3)
						}
						rsd.list1[[z]] <- rbindlist(rsd.list2)
						rm(rsd.list2)
					}
					rsd.list[[i]] <- rbindlist(rsd.list1)
					rm(rsd.list1)
				}
				x <- rbindlist(rsd.list)
				rm(rsd.list, rsd, rsd.h)
				gc()
				setkey(x, Phase, Scenario, Model, Var, Location, Year, Month, Decade)
			}
			prog_d_spatial$set(message="Bootstrap resampling...", value=5)
			rnd <- if(input$vars[1]=="Precipitation") 0 else 1
			x <- x[, density2bootstrap(Val, Prob, n.boot=BootSamples(), digits=rnd), by=list(Phase, Scenario, Model, Var, Location, Year, Month, Decade)]
			setnames(x, "V1", "Val")
			setcolorder(x, c("Phase", "Scenario", "Model", "Var", "Location", "Val", "Year", "Month", "Decade"))
			gc()
			if(!is.null(input$months2seasons) && input$months2seasons){
				prog_d_spatial$set(message="Aggregating months...", value=6)
				x <- collapseMonths(x, "Val", as.numeric(input$n_seasons), Months_original(), n.samples=BootSamples())
			}
			if(!is.null(input$decades2periods) && input$decades2periods){
				prog_d_spatial$set(message="Aggregating decades...", value=7)
				x <- periodsFromDecades(x, as.numeric(input$n_periods), Decades_original(), n.samples=BootSamples())
			}
			# data from only one phase with multiple models in that phase selected, or two phases with equal number > 1 of models selected from each phase.
			# Otherwise compositing prohibited.
			if(composite() > 0){ # can assume both phases have multiple models, so split always works nicely
				prog_d_spatial$set(message="Averaging samples...", value=7.5)
				n <- length(input$cmip3models) # will match length(input$cmip5models)
				x[, Index := rep(1:BootSamples(), length=nrow(x))]
				x <- x[, round(sum(Val)/n, 1), by=list(Phase, Scenario, Var, Location, Year, Month, Decade, Index)]
				x[, Index := NULL]
				setnames(x, "V1", "Val")
				x[, Model := paste0(Phase, " ", n, "-Model Avg")]
				setcolorder(x, c("Phase", "Scenario", "Model", "Var", "Location", "Val", "Year", "Month", "Decade"))
				if("Precipitation" %in% input$vars) x[Var=="Precipitation", Val := round(Val)]
			}
			if(input$convert_units){
				prog_d_spatial$set(message="Unit conversion...", value=9.5)
				x[Var=="Temperature", Val := round((9/5)*Val + 32, 1)]
				x[Var=="Precipitation", Val := round(Val/25.4, 3)]
			}
			prog_d_spatial$set(message="GCM distributions complete.", value=10)
		}
	)
	x
})

# @knitr re_53
CRU_spatial <- reactive({ #### All CRU datasets require recoding for externalization
	if(goBtnNullOrZero()) return()
	#prog_d_cru_spatial <- Progress$new(session, min=1, max=10)
	#on.exit(prog_d_cru_spatial$close())
	isolate(
		if(is.null(Months_original()) | is.null(input$vars) | is.null(input$convert_units) | locSelected()==FALSE){
			x <- NULL
		} else {
			#prog_d_cru_spatial$set(message="Subsetting CRU 3.2 spatial distributions...", value=1)
			if(input$loctype=="Cities" && length(input$locs_cities) && input$locs_cities[1]!="") {
				x <- subset(d.cities.cru31, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4) & Location %in% input$locs_cities)
			} else if(input$loctype!="Cities"){
				reg.nam <- sort(region.names.out[[input$loctype]])
				region.ind <- which(reg.nam %in% Locs())
				for(i in 1:length(region.ind)) {
					load(paste0(region.cru.samples.files[[input$loctype]][region.ind[i]], "/", tolower(input$vars[1]), ".RData"), envir=environment()) # Still can only load one variable file, okay as long as app only contains T & P
					cru32.samples.df[,samples.columns.cru] <- rsd.cru/rep(samples.multipliers.cru, each=length(rsd.cru)/2)
					cru32.samples.df$Var <- input$vars[1]
					cru32.samples.df$Location <- reg.nam[region.ind[i]]
					if(i==1) rsd.cru.final <- cru32.samples.df else rsd.cru.final <- rbind(rsd.cru.final, cru32.samples.df)
				}
				x <- subset(rsd.cru.final, Month %in% month.abb[match(Months_original(), month.abb)] & 
					Year %in% currentYears() & Decade %in% substr(Decades_original(),1,4))# & Location %in% input$locs_regions & Var %in% input$vars[1])
				x <- data.table(x)
			}
			if(nrow(x)==0) return()
			rnd <- if(input$vars[1]=="Precipitation") 0 else 1
			#prog_d_cru_spatial$set(message="CRU 3.2 bootstrap resampling...", value=3)
			x <- x[, density2bootstrap(Val, Prob, n.boot=BootSamples(), digits=rnd), by=list(Var, Location, Year, Month, Decade)]
			setnames(x, "V1", "Val")
			x$Model <- x$Scenario <- x$Phase <- "CRU 3.2"
			setkey(x, Phase, Scenario, Model, Var, Location, Year, Month, Decade)
			setcolorder(x, c("Phase", "Scenario", "Model", "Var", "Location", "Val", "Year", "Month", "Decade"))
			if(!is.null(input$months2seasons) && input$months2seasons){
				#prog_d_cru_spatial$set(message="CRU 3.2 spatial distributions: aggregating months...", value=7)
				x <- collapseMonths(x, "Val", as.numeric(input$n_seasons), Months_original(), n.samples=BootSamples())
			}
			if(!is.null(input$decades2periods) && input$decades2periods){
				#prog_d_cru_spatial$set(message="CRU 3.2 spatial distributions: aggregating decades...", value=8)
				x <- periodsFromDecades(x, as.numeric(input$n_periods), Decades_original(), check.years=TRUE, n.samples=BootSamples())
			}
			if(is.null(x)) return()
			# data from only one phase with multiple models in that phase selected, or two phases with equal number > 1 of models selected from each phase.
			# Otherwise compositing prohibited.
			if(input$convert_units){
				#prog_d_cru_spatial$set(message="Unit conversion...", value=9)
				x[Var=="Temperature", Val := round((9/5)*Val + 32, 1)]
				x[Var=="Precipitation", Val := round(Val/25.4, 3)]
			}
			#prog_d_cru_spatial$set(message="CRU 3.2 distributions complete.", value=10)
		}
	)
	x
})

# @knitr re_54_58
# ggplot2 grouping, faceting, pooling
groupFacetChoicesTS <- reactive({
	if(!is.null(input$xtime)){
		if(input$xtime=="Year") {
			ind <- which(unlist(lapply(list(phases, models(), scenarios(), Months(), Decades(), Locs()), length))>1)
			choices <- c("Phase","Model","Scenario","Month","Decade","Location")[ind]
		} else if(input$xtime=="Month") {
			ind <- which(unlist(lapply(list(phases, models(), scenarios(),Decades(), Locs()), length))>1)
			choices <- c("Phase","Model","Scenario","Decade","Location")[ind]
		} else if(input$xtime=="Decade") {
			ind <- which(unlist(lapply(list(phases, models(), scenarios(),Months(), Locs()), length))>1)
			choices <- c("Phase","Model","Scenario","Month","Location")[ind]
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
			choices=c("Phase","Scenario","Model","Month","Year","Decade","Location"),
			mos=Months(), years=currentYears(), decades=Decades(), locs=Locs(), scenarios=scenarios(), models=models(),
			cmip3scens=input$cmip3scens, cmip5scens=input$cmip5scens, cmip3mods=input$cmip3models, cmip5mods=input$cmip5models)
	x
})

subjectChoices <- reactive({ getSubjectChoices(inx=input$xtime, ingrp=input$group, pooled.vars=pooled.var()) })

# @knitr re_59_63
sc_flip_xy <- reactive({
	if(is.null(c(input$vars, input$vars2))) return(FALSE)
	if(input$sc_x==input$vars) FALSE else TRUE
})

groupFacetChoicesScatter <- reactive({
	ind <- which(unlist(lapply(list(phases, models(), scenarios(), Months(), Decades(), Locs()), length))>1)
	choices <- c("None", c("Phase","Model","Scenario","Month","Decade","Location")[ind])
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
	x <- getPooledVars(inx=input$sc_x, ingrp=input$group2, infct=input$facet2, grp.fct.choices=groupFacetChoicesScatter(),
			choices=c("Phase","Scenario","Model","Month","Year","Decade","Location"),
			mos=Months(), years=currentYears(), decades=Decades(), locs=Locs(), scenarios=scenarios(), models=models(),
			cmip3scens=input$cmip3scens, cmip5scens=input$cmip5scens, cmip3mods=input$cmip3models, cmip5mods=input$cmip5models)
	x
})

# @knitr re_64_68
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
			choices=c("Phase","Scenario","Model","Month","Year","Decade","Location"),
			mos=Months(), years=currentYears(), decades=Decades(), locs=Locs(), scenarios=scenarios(), models=models(),
			cmip3scens=input$cmip3scens, cmip5scens=input$cmip5scens, cmip3mods=input$cmip3models, cmip5mods=input$cmip5models)
	x
})

# @knitr re_69_75
xvarChoices <- reactive({
		ind <- which(unlist(lapply(list(phases, scenarios(), models(), Locs(), Months(), currentYears(), Decades()), length))>1)
		if(length(ind)) choices <- c("Phase","Scenario", "Model", "Location", "Month", "Year", "Decade")[ind] else choices <- NULL
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
        x <- unlist(lapply(list(phases, models(), scenarios(), Months(), Decades(), Locs()), length))
		ind <- which(x > 1 & x <=9)
		choices <- c("None", c("Phase","Model","Scenario","Month","Decade","Location")[ind])
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
			choices=c("Phase","Scenario","Model","Month","Year","Decade","Location"),
			mos=Months(), years=currentYears(), decades=Decades(), locs=Locs(), scenarios=scenarios(), models=models(),
			cmip3scens=input$cmip3scens, cmip5scens=input$cmip5scens, cmip3mods=input$cmip3models, cmip5mods=input$cmip5models)
	x
})

subjectChoices3 <- reactive({ getSubjectChoices(inx=input$xvar, ingrp=input$group3, pooled.vars=pooled.var3()) })

Variability <- reactive({ if(!is.null(input$variability)) !input$variability else NULL })

# @knitr re_76_82
spatial_x_choices <- reactive({
		ind <- which(unlist(lapply(list(phases, scenarios(), models(), Locs(), Months(), currentYears(), Decades()), length))>1)
		if(length(ind)) choices <- c("Phase","Scenario", "Model", "Location", "Month", "Year", "Decade")[ind] else choices <- NULL
		if(length(choices)){
			if(!is.null(input$vars)) choices <- c(input$vars[1], choices)
			if(length(scenarios()) < 2) choices <- choices[choices!="Scenario"]
			if(length(models()) < 2) choices <- choices[choices!="Model"]
			if(!length(input$cmip3scens) | !length(input$cmip5scens)) choices <- choices[choices!="Phase"]
			if(!length(input$cmip3models) | !length(input$cmip5models)) choices <- choices[choices!="Phase"]
		} else choices <- NULL
	choices
})

groupFacetChoicesSpatial <- reactive({
	if(!is.null(input$spatial_x)){
		ind <- which(unlist(lapply(list(phases, models(), scenarios(), Months(), Decades(), Locs()), length))>1)
		choices <- c("None", c("Phase","Model","Scenario","Month","Decade","Location")[ind])
		if(!is.null(choices)){
			choices <- choices[choices!=input$spatial_x]
			if(length(scenarios()) < 2) choices <- choices[choices!="Scenario"]
			if(length(models()) < 2) choices <- choices[choices!="Model"]
			if(!length(input$cmip3scens) | !length(input$cmip5scens)) choices <- choices[choices!="Phase"]
			if(!length(input$cmip3models) | !length(input$cmip5models)) choices <- choices[choices!="Phase"]
			if(!is.null(choices) && length(choices)==1) choices <- NULL
		} else choices <- NULL
	} else choices <- NULL
	choices
})

nGroupsSpatial <- reactive({ nGroups(input$groupSpatial, scenarios(), models(), input$mos, input$decs, Locs()) })

facetPanelsSpatial <- reactive({ getFacetPanels(input$facetSpatial, models(), scenarios(), input$mos, input$decs, Locs()) })

pooledVarSpatial <- reactive({
	x <- getPooledVars(inx=input$spatial_x, ingrp=input$groupSpatial, infct=input$facetSpatial, grp.fct.choices=groupFacetChoicesSpatial(),
			choices=c("Phase","Scenario","Model","Month","Year","Decade","Location"),
			mos=Months(), years=currentYears(), decades=Decades(), locs=Locs(), scenarios=scenarios(), models=models(),
			cmip3scens=input$cmip3scens, cmip5scens=input$cmip5scens, cmip3mods=input$cmip3models, cmip5mods=input$cmip5models)
	x
})

subjectChoicesSpatial <- reactive({ getSubjectChoices(inx=input$spatial_x, ingrp=input$groupSpatial, pooled.vars=pooledVarSpatial()) })

plotTypeChoicesSpatial <- reactive({
	if(is.null(input$spatial_x)) return()
	if(input$spatial_x=="Temperature" | input$spatial_x=="Precipitation") c("Histogram", "Density") else c("Stripchart")
})

# @knitr re_83_87
# Data aggregation
datCollapseGroups <- reactive({
	if(!is.null(dat()) & !is.null(input$group)){
		d <- copy(dat())
		d[, c(input$group) := "Average"]
		d
	} else return()
})

datCollapsePooled <- reactive({
	if(!is.null(dat())){
		d <- copy(dat())
		if(!is.null(pooled.var())) d[, c(pooled.var()) := "Average"]
		d
	} else return()
})

datCollapseGroups2 <- reactive({
	if(!is.null(dat2()) & !is.null(input$group)){
		d <- copy(dat2())
		d[, c(input$group) := "Average"]
		d
	} else return()
})

datCollapsePooled2 <- reactive({
	if(!is.null(dat2())){
		d <- copy(dat2())
		if(!is.null(pooled.var())) d[, c(pooled.var()) := "Average"]
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

# @knitr re_89_92
# Color sequences
colorseq_ts <- reactive({
	getColorSeq(d=dat(), grp=input$group, n.grp=n.groups())
})

colorseq_sc <- reactive({
	getColorSeq(d=dat2(), grp=input$group2, n.grp=n.groups2())
})

colorseq_hm <- reactive({
	getColorSeq(d=dat_heatmap(), heat=TRUE)
})

colorseq_vr <- reactive({
	getColorSeq(d=dat(), grp=input$group3, n.grp=n.groups3(), overlay=input$vr_showCRU)
})

colorseq_sp <- reactive({
	getColorSeq(d=dat_spatial(), grp=input$groupSpatial, n.grp=nGroupsSpatial(), overlay=input$sp_showCRU)
})
