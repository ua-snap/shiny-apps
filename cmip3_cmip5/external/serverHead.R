library(shiny)
pkgs <- c("ggplot2","plyr","reshape2","gridExtra","png","Hmisc")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(Hmisc); library(png); library(ggplot2); library(plyr); library(reshape2); library(gridExtra)

library(leaflet)
library(maps)

#load("external/data.RData",envir=.GlobalEnv)
#load("external/data_CRU31.RData", envir=.GlobalEnv)
############################## TESTING
#load("external/data_cities.RData", envir=.GlobalEnv)
#load("external/data_cities_CRU31.RData", envir=.GlobalEnv)

# From a future version of Shiny
bindEvent <- function(eventExpr, callback, env=parent.frame(), quoted=FALSE) {
  eventFunc <- exprToFunction(eventExpr, env, quoted)
  
  initialized <- FALSE
  invisible(observe({
    eventVal <- eventFunc()
    if (!initialized)
      initialized <<- TRUE
    else
      isolate(callback())
  }))
}

##############################

colorsHCL <- function(n) hcl(h=seq(0,(n-1)/(n),length=n)*360,c=100,l=65,fixup=TRUE) # evenly spaced HCL colors when too many levels present
cbpalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#999999") # colorblind-friendly palette option

logo <- readPNG("www/img/SNAP_acronym_100px.png")
logo.alpha <- 1
logo.mat <- matrix(rgb(logo[,,1],logo[,,2],logo[,,3],logo[,,4]*logo.alpha), nrow=dim(logo)[1])

# These functions are written with the structure of the app in mind. They are intended to avoid code duplication.

nGroups <- function(grp, scenarios, models, mos, decs){
	if(is.null(grp) || grp=="None/Force Pool") return(1)
	if(grp=="Phase") return(2)
	if(grp=="Model") return(length(models))
	if(grp=="Scenario") return(length(scenarios))
	if(grp=="Month"){ x <- length(mos); if(x==0) x <- 12; return(x) }
	if(grp=="Decade"){ x <- length(decs); if(x==0) x <- 23; return(x) }
	long <- c("Domain")#"Month","Decade",)
	short <- c("doms")#"mos","decs",)
	return(eval(parse(text=sprintf("length(input$%s)",short[which(long==grp)]))))
}
	
getFacetChoices <- function(inx, ingrp, grp.choices){
	if(!is.null(ingrp)){
		if(length(grp.choices)>=2){ # greater than (or equal to, since group not required) 1, plus 1 to account for the "None/Force Pool" group option
			grp.choices.sub <- grp.choices[grp.choices!="None/Force Pool"]
			choices <- c("None/Force Pool", grp.choices.sub[which(!(grp.choices.sub %in% ingrp))])
			if(inx=="Year") choices <- choices[choices!="Decade"]
			if(inx=="Scenario" | inx=="Model") choices <- choices[choices!="Phase"]
			if(length(choices)==1) choices <- NULL
		} else choices <- NULL
	} else choices <- NULL
	choices
}

getPooledVars <- function(inx, ingrp, infct, grp.choices, fct.choices, choices, mos, years, decades, domains, scenarios, models, cmip3scens, cmip5scens, cmip3mods, cmip5mods){
	if(!is.null(ingrp) & !is.null(infct)){
		if( # the +1s are to make explicit the non-group "None/Force Pool" option in the group and facet choices
			length(grp.choices)>=3+1 |
			(length(grp.choices)==2+1 & !(ingrp!="None/Force Pool" & infct!="None/Force Pool")) |
			(length(grp.choices)==1+1 & ingrp=="None/Force Pool" & infct=="None/Force Pool")
		){
			pooled.var <- choices[!(choices %in% c(inx,ingrp,infct))]
			if(infct=="None/Force Pool"){
				pooled.var <- choices[sort(match( unique(c("Year", pooled.var[which(pooled.var %in% fct.choices)])), choices))]
				if(inx=="Year") pooled.var <- pooled.var[pooled.var!="Year"]
			}
			if(length(years)==1) pooled.var <- pooled.var[pooled.var!="Year"]
			if(length(decades)==1) pooled.var <- pooled.var[pooled.var!="Decade"]
			if(length(domains)==1) pooled.var <- pooled.var[pooled.var!="Domain"]
			if(length(scenarios)==1) pooled.var <- pooled.var[!(pooled.var %in% c("Phase", "Scenario"))]
			if( (ingrp=="Scenario" | infct=="Scenario") & length(cmip3scens) & length(cmip5scens) & length(models)==2 ) pooled.var <- pooled.var[pooled.var!="Model"]
			if( (ingrp=="Model" | infct=="Model") & length(cmip3scens) & length(cmip5scens) & length(models)==2 ) pooled.var <- pooled.var[pooled.var!="Scenario"]
			if(length(models)==1) pooled.var <- pooled.var[!(pooled.var %in% c("Phase", "Model"))]
			if(!length(cmip3scens) | !length(cmip5scens) | !length(cmip3mods) | !length(cmip5mods) | ingrp=="Scenario" | infct=="Scenario" | ingrp=="Model" | infct=="Model") pooled.var <- pooled.var[pooled.var!="Phase"]
			if(length(cmip3scens) & length(cmip5scens) & length(scenarios)==2 & (ingrp=="Phase" | infct=="Phase")) pooled.var <- pooled.var[pooled.var!="Scenario"]
			if(length(cmip3mods) & length(cmip5mods) & length(models)==2 & (ingrp=="Phase" | infct=="Phase")) pooled.var <- pooled.var[pooled.var!="Model"]
			if(length(mos)==1) pooled.var <- pooled.var[pooled.var!="Month"]
			if("Year" %in% pooled.var | inx=="Year") pooled.var <- pooled.var[pooled.var!="Decade"]
			pooled.var
		} else return()
	} else return()
}

getPlotSubTitle <- function(pooled, yrs, mos, mod, scen, phase=c("CMIP3", "CMIP5"), dom){
	yrs.lab <- ifelse("Year" %in% pooled, paste("Years: ", paste(yrs[1], "-", tail(yrs,1)), "\n", collapse=""), "")
	mos.lab <- ifelse("Month" %in% pooled, paste("Months: ", paste(mos, collapse=", "), "\n", collapse=""), "")
	mod.lab <- ifelse("Model" %in% pooled, paste("GCMs: ", paste(mod, collapse=", "), "\n", collapse=""), "")
	scen.lab <- ifelse("Scenario" %in% pooled, paste("Scenarios: ", paste(scen, collapse=", "), "\n", collapse=""), "")
	phase.lab <- ifelse("Phase" %in% pooled, paste("Phases: ", paste(phase, collapse=", "), "\n", collapse=""), "")
	dom.lab <- ifelse("Domain" %in% pooled, paste("Domains: ", paste(dom, collapse=", "), "\n", collapse=""), "")
	no.pooled <- all(c(dom.lab, phase.lab, scen.lab, mod.lab, mos.lab, yrs.lab) == "")
	x <- ifelse(no.pooled, "", paste("Pooled variables:\n", dom.lab, phase.lab, scen.lab, mod.lab, mos.lab, yrs.lab, sep=""))
	x
}

getPlotTitle <- function(grp, facet, pooled, yrs, mos, mod, scen, phase=c("CMIP3", "CMIP5"), dom){
	gfp <- c(grp, facet, pooled)
	yrs.lab <- ifelse("Year" %in% gfp, "", paste(yrs[1], "-", tail(yrs,1)))
	mos.lab <- ifelse("Month" %in% gfp, "", paste(mos, collapse=", "))
	mod.lab <- ifelse("Model" %in% gfp, "", paste(mod, collapse=", "))
	scen.lab <- ifelse("Scenario" %in% gfp, "", paste(scen, collapse=", "))
	#phase.lab <- ifelse("Phase" %in% gfp, "", paste(phase, collapse=", "))
	dom.lab <- ifelse("Domain" %in% gfp, "", paste(dom, collapse=", "))
	x <- paste(dom.lab, scen.lab, mod.lab, mos.lab, yrs.lab)
	x
}

getSubjectChoices <- function(inx, ingrp, pooled.vars){
	if(!is.null(pooled.vars)){
		x <- pooled.vars
		if(inx!="Year") y <- "Year" else y <- ""
		if(inx=="Decade"){
			x <- NULL
		#if(input$xvar=="Decade"){
		#	x <- x[x!="Year"]
		#	x <- unique(c(input$group3, x, y))
		#	x <- x[x!="" & x!="None/Force Pool"]
		#	x <- c("", paste(x, sep="", collapse="-"))
		} else {
			x <- unique(c(ingrp, x[x!="Decade"], y))
			x <- x[x!="" & x!="None/Force Pool"]
			x <- if(inx=="Year") c("", paste(x, sep="", collapse="-"), paste(c(x,"Decade"), sep="", collapse="-")) else c("", paste(x, sep="", collapse="-"))
		}
		if(length(x)==1) x <- NULL
	} else x <- NULL
	x
}

sp_xlabylab <- function(units, form.string){
	tlb <- paste0("Temperature (",units[1],")")
	plb <- paste0("Precipitation (",units[2],")")
	if(substr(form.string,1,1)=="T"){ xlb <- plb; ylb <- tlb } else { xlb <- tlb; ylb <- plb }
	list(xlb=xlb, ylb=ylb)
}

adjustGroup <- function(grp, n.grp){
	if(is.null(grp) || grp=="None/Force Pool") grp <- 1
	if(n.grp==1) grp <- 1
	grp
}
	
withinGroupLines <- function(x, subjects){
	if(x=="Decade") subjects <- 1
	if(!length(subjects) || subjects[1] == "") subjects <- 1
	if(subjects[1]!=1){
		subjectlines <- TRUE
		subjects <- sprintf("interaction(%s)", paste0(subjects, collapse = ", "))
	} else subjectlines <- FALSE
	list(subjects=subjects, subjectlines=subjectlines)
}

scaleColFillMan_prep <- function(fill=NULL, col){
	scfm <- FALSE
	x1 <- !length(grep("friendly",col))
	if(x1){
			x1 <- length(grep("border",col))
			if(x1) fill <- NULL		
	} else {
			scfm <- TRUE
			x1 <- length(grep("border",col))
			if(x1) fill <- NULL
	}
	list(scfm=scfm, fill=fill)
}

scaleColFillMan <- function(g, default, colseq, colpal, mos, n.grp, cbpalette){
	if(colseq=="Nominal" & default) g <- g + scale_colour_manual(values=cbpalette) + scale_fill_manual(values=cbpalette)
	if(!default){
		if(colseq=="Cyclic"){
			if(colpal %in% c("Yellow-Red","Blue-Orange","Brown-Orange","Blue-Red")){
				colorcycle <- rep(strsplit(tolower(colpal),"-")[[1]],2)[-4]
				g <- g + scale_colour_manual( values=colorRampPalette(colorcycle)(length(mos)) ) + scale_fill_manual( values=colorRampPalette(colorcycle)(length(mos)) )
			}
		} else if(substr(colpal,1,3)=="HCL"){
			g <- g + scale_color_manual(values=colorsHCL(n.grp)) + scale_fill_manual(values=colorsHCL(n.grp))
		} else if(colpal!="none"){
			g <- g + scale_color_brewer(palette=strsplit(colpal," ")[[1]][1]) + scale_fill_brewer(palette=strsplit(colpal," ")[[1]][1])
		}
	}
	g
}

pooledVarsCaption <- function(pv, permit, ingrp){
	if(length(pv)){
		pv <- tolower(paste0(pv,"s"))
		if(length(pv)==2){
			pv <- paste(pv, collapse=" and ")
		} else if(length(pv)>2) {
			n <- length(pv)
			pv <- paste(c(paste(pv[1:(n-2)], collapse=", "), paste(pv[(n-1):n], collapse=" and ")), collapse=", ")
		}
		if(permit){
			if(ingrp=="None/Force Pool") h5(paste0("Observations include multiple ", pv, ".")) else h5(paste0("Observations in each color group include multiple ", pv, "."))
		}
	}
}

getColorSeq <- function(id, d, grp, n.grp, overlay=FALSE){
	if(is.null(grp) || grp=="None/Force Pool") return()
	if(overlay) n.grp <- n.grp + 1
	x <- "Nominal"
	print(n.grp)
	if(n.grp>9) x <- "Evenly spaced" else if(n.grp>8) x <- c("Increasing","Centered") else if(grp!="Model") x <- c("Nominal","Increasing","Centered")
	if(!is.null(d)) selectInput(id, "Color levels", x, selected=x[1], width="100%") else NULL
}

getColorPalettes <- function(id, colseq, grp, n.grp, fill.vs.border=NULL, fill.vs.border2=TRUE, overlay=FALSE){
	if(is.null(grp) || grp=="None/Force Pool") return()
	if(overlay) n.grp <- n.grp + 1
	if(!is.null(colseq)){
		if(colseq=="Nominal"){
			pal <- c("Accent","Dark2","Pastel1","Pastel2","Paired","Set1","Set2","Set3")
			if(n.grp<=8) pal <- c("CB-friendly",pal)
			if(!is.null(fill.vs.border)) if(fill.vs.border & fill.vs.border2) pal <- paste(rep(pal,each=2),c("fill","border")) 
		} else if(colseq=="Evenly spaced"){
			if(n.grp>9) pal <- "HCL: 9+ levels"
			if(!is.null(fill.vs.border)) if(fill.vs.border & fill.vs.border2) pal <- paste(rep(pal,each=2),c("fill","border")) 
		} else if(colseq=="Increasing"){
			pal <- c("Blues","BuGn","BuPu","GnBu","Greens","Greys","Oranges","OrRd","PuBu","PuBuGn","PuRd","Purples","RdPu","Reds","YlGn","YlGnBu","YlOrBr","YlOrRd")
		} else if(colseq=="Centered"){
			pal <- c("BrBG","PiYG","PRGn","PuOr","RdBu","RdGy","RdYlBu","RdYlGn","Spectral")
		}
		selectInput(id, "Color palette", pal, selected=pal[1], width="100%")
	}
}

annotatePlot <- function(g, data, x, y, y.fixed=NULL, text, bp=NULL, bp.position=NULL, n.groups=1){
	if(is.null(y.fixed)) y.coord <- max(data[[y]]) else y.coord <- y.fixed
	if(!is.null(bp) && bp) if(bp.position=="fill") y.coord <- 1 else if(bp.position=="stack") y.coord <- n.groups*y.coord
	x.coord <- if(is.factor(data[[x]])) 0.525 else min(data[[x]])
	g <- g + annotate("text", y=y.coord, x=x.coord, label=bquote(.(text)), hjust=0, vjust=1, fontface=3)
	g
}

addLogo <- function(g, show.logo=FALSE, logo=NULL, show.title=FALSE, main="", fontsize=16){
	if(show.logo){
		if(!show.title) main <- ""
		grid.bot <- arrangeGrob(textGrob(""), g, textGrob(""), ncol=3, widths=c(1/40,19/20,1/40))
		grid.top <- arrangeGrob(
			textGrob(""),
			textGrob(main, x=unit(0.075,"npc"), y=unit(0.5,"npc"), gp=gpar(fontsize=fontsize), just=c("left")),
			rasterGrob(logo, x=unit(0.85,"npc"), y=unit(0.5,"npc"), just=c("right")), # logo source?
			textGrob(""),
			widths=c(1/40,0.8,0.2,1/40), ncol=4)
		g <- grid.arrange(textGrob(""), grid.top, grid.bot, textGrob(""), heights=c(1/40,1/20,18/20,1/40), ncol=1)
	}
	g
}
