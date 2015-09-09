# @knitr sh_setup
library(shiny)
library(Hmisc); library(png); library(RColorBrewer); library(ggplot2); library(plyr); library(reshape2); library(data.table); library(gridExtra)

theme_black=function(base_size=12,base_family="") {
  theme_grey(base_size=base_size,base_family=base_family) %+replace%
    theme(
      # Specify axis options
      axis.line=element_blank(), 
      axis.text.x=element_text(size=base_size*0.8,color="white",
                               lineheight=0.9,vjust=1), 
      axis.text.y=element_text(size=base_size*0.8,color="white",
                               lineheight=0.9,hjust=1), 
      axis.ticks=element_line(color="white",size = 0.2), 
      axis.title.x=element_text(size=base_size,color="white",vjust=1), 
      axis.title.y=element_text(size=base_size,color="white",angle=90,
                                vjust=0.5), 
      axis.ticks.length=unit(0.3,"lines"), 
      axis.ticks.margin=unit(0.5,"lines"),
      # Specify legend options
      legend.background=element_rect(color=NA,fill="black"), 
      legend.key=element_rect(color="white", fill="black"), 
      legend.key.size=unit(1.2,"lines"), 
      legend.key.height=NULL, 
      legend.key.width=NULL,     
      legend.text=element_text(size=base_size*0.8,color="white"), 
      legend.title=element_text(size=base_size*0.8,face="bold",hjust=0,
                                color="white"), 
      #legend.position="right", 
      legend.text.align=NULL, 
      legend.title.align=NULL, 
      #legend.direction="vertical", 
      legend.box=NULL,
      # Specify panel options
      panel.background=element_rect(fill="black",color = NA), 
      panel.border=element_rect(fill=NA,color="white"), 
      #panel.grid.major=element_blank(), 
      #panel.grid.minor=element_blank(), 
	  panel.grid.major = element_line(colour = "grey10", size = 0.2), # test alternate
	  panel.grid.minor = element_line(colour = "grey2", size = 0.5), # test alternate
      panel.margin=unit(0.25,"lines"),  
      # Specify facetting options
      strip.background=element_rect(fill="grey30",color="grey10"), 
      strip.text.x=element_text(size=base_size*0.8,color="white"), 
      strip.text.y=element_text(size=base_size*0.8,color="white",
                                angle=-90), 
      # Specify plot options
      plot.background=element_rect(color="black",fill="black"), 
      plot.title=element_text(size=base_size*1.2,color="white"), 
      plot.margin=unit(c(1,1,0.5,0.5),"lines")
    )
}

colorsHCL <- function(n) hcl(h=seq(0,(n-1)/(n),length=n)*360,c=100,l=65,fixup=TRUE) # evenly spaced colors
cbpalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#999999") # colorblind-friendly palette option

logo <- readPNG("www/img/SNAP_acronym_100px.png")
logo.alpha <- 1
logo.mat <- matrix(rgb(logo[,,1],logo[,,2],logo[,,3],logo[,,4]*logo.alpha), nrow=dim(logo)[1])

# @knitr sh_func01
# These functions are written with the structure of the app in mind. They are intended to avoid code duplication.
nullOrZero <- function(x) is.null(x) || x==0

# @knitr sh_func02
mod2ar <- function(x){
	if(x %in% c("CCCMAcgcm31", "GFDLcm21", "MIROC32m", "MPIecham5", "ukmoHADcm3")) return("AR4")
	if(x %in% c("CCSM4", "GFDLcm3", "GISSe2-r", "IPSLcm5a-lr", "MRIcgcm3")) return("AR5")
}

# @knitr sh_func03
density2bootstrap <- function(Val, Prob, n.boot=10000, interp=TRUE, n.interp=1000, ...){
	if(interp){	p <- approx(Val, Prob, n=n.interp); Val <- p$x;	Prob <- p$y	}
	round(sample(Val, n.boot, Prob, rep=T), ...)
}

# @knitr sh_func04
splitAt <- function(x, pos=NULL) if(is.null(pos)) list(x) else unname(split(x, cumsum(seq_along(x) %in% pos)))

# @knitr sh_func05
periodLength <- function(x){
	x.diff <- diff(sort(x))
	pos.split <- if(all(x.diff==1)) NULL else which(x.diff!=1)+1
	x <- splitAt(x=x, pos=pos.split)
	n <- sapply(x, length)
	if(length(n)==1 || all(diff(n)==0)) n else NULL # Do not allow unequal length periods
}

# @knitr sh_func06
collapseMonths <- function(d, variable, n.s, mos, n.samples=1, f=function(x) round(mean(x), 1), f.args=list()){
	p <- length(mos)/n.s
	ind <- as.integer(sapply(1:n.s, function(i, n, p) rep(1:n, p) + (i-1)*n, n=n.samples, p=p))
	d[, Index := ind]
	d <- d[, lapply(1:length(variable), function(i, x, f.args) do.call(f, c(list(get(x[i])), f.args)), x=variable, f.args=f.args), by=list(Phase, Scenario, Model, Var, Location, Year, Decade, Index)]
	d[, Index := NULL]
	id.seasons <- sapply(split(mos, rep(1:n.s, each=p)), function(x) paste(c(x[1], tail(x,1)), collapse="-"))
	id.seasons <- rep(factor(id.seasons, levels=id.seasons), each=n.samples)
	d[, Month := id.seasons]
	setnames(d, paste0("V", 1:length(variable)), variable)
	setcolorder(d, c("Phase", "Scenario", "Model", "Var", "Location", variable, "Year", "Month", "Decade"))
	for(i in 1:length(variable)) d[Var=="Precipitation", variable[i] := round(p*get(variable[i]))] # multiply by p to sum precip, assumes mean() passed to f
	d
}

# @knitr sh_func07
periodsFromDecades <- function(d, n.p, decs, check.years=FALSE, n.samples=1){
	decs <- as.numeric(substr(decs,1,4))
	n.mos <- length(levels(d$Month))
	p <- length(decs)/n.p
	splt <- split(decs, rep(1:n.p, each=p))
	if(check.years){ # Ensure inclusion only of CRU data which exist for multi-decade period (may be incomplete years)
		keep.ind <- which(sapply(splt, function(x) all(x %in% unique(d$Decade))))
		if(length(keep.ind)){
			splt <- splt[keep.ind]
			periods <- paste0(substr(sapply(splt, function(x) paste(c(x[1], tail(x,1)), collapse="-")), 1, 8), 9)
			for(i in 1:length(periods)) d[Decade %in% splt[[i]], Decade := periods[i]]
			d <- d[nchar(Decade) > 4,]
		} else d <- NULL
	} else {
		periods <- paste0(substr(sapply(splt, function(x) paste(c(x[1], tail(x,1)), collapse="-")), 1, 8), 9)
		d[, Decade := rep(periods, each=n.mos*10*p*n.samples)]
	}
	d
}

# @knitr sh_func08
dodgePoints <- function(d, x, grp, n.grp, facet.by, width=0.9){
	if(is.character(grp) & n.grp>1){
		x <- d[, get(x)]
		d.grp <- d[, get(grp)]
		if(facet.by=="None"){
			x.names <- unique(as.character(x))
			x.num <- grp.n <- grp.num <- rep(NA, nrow(d))
			for(m in 1:length(x.names)){
				ind <- which(as.character(x)==x.names[m])
				grp.n[ind] <- length(unique(d.grp[ind]))
				x.num[ind] <- m
				grp.num[ind] <- width*( (as.numeric(factor(d.grp[ind]))/grp.n[ind])-(1/grp.n[ind] + ((grp.n[ind]-1)/2)/(grp.n[ind])) )
			}
		} else if(facet.by!="None") {
			x.names <- unique(as.character(x))
			d.facet <- as.character(d[, get(facet.by)])
			panel.names <- unique(d.facet)
			n.panels <- length(panel.names)
			x.num <- grp.n <- grp.num <- rep(NA, nrow(d))
			for(m in 1:n.panels){
				for(mm in 1:length(x.names)){
					ind <- which(d.facet==panel.names[m] & as.character(x)==x.names[mm])
					grp.n[ind] <- length(unique(d.grp[ind]))
					x.num[ind] <- mm - 1 + as.numeric(factor(x[ind]))
					grp.num[ind] <- width*( (as.numeric(factor(d.grp[ind]))/grp.n[ind])-(1/grp.n[ind] + ((grp.n[ind]-1)/2)/(grp.n[ind])) )
				}
			}
		}
		return(list(x.num=x.num, grp.num=grp.num, grp.n=grp.n))
	}
}

# @knitr sh_func09
getHeatmapAxisChoices <- function(scens, mods, locs, mos, yrs, decs, cmip3scens, cmip5scens, cmip3models, cmip5models){
	ind <- which(unlist(lapply(list(phases, scens, mods, locs, mos, yrs, decs), length))>0)
		if(length(ind)) choices <- c("Phase","Scenario", "Model", "Location", "Month", "Year", "Decade")[ind] else choices <- NULL
		if(length(choices)){
			if(length(scens) < 1) choices <- choices[choices!="Scenario"]
			if(length(mods) < 1) choices <- choices[choices!="Model"]
			if(!length(cmip3scens) | !length(cmip5scens)) choices <- choices[choices!="Phase"]
			if(!length(cmip3models) | !length(cmip5models)) choices <- choices[choices!="Phase"]
		} else choices <- NULL
	choices
}

# @knitr sh_func10
nGroups <- function(grp, scenarios, models, mos, decs, locs){
	if(is.null(grp) || grp=="None") return(1)
	if(grp=="Phase") return(2)
	if(grp=="Model") return(length(models))
	if(grp=="Scenario") return(length(scenarios))
	if(grp=="Month"){ x <- length(mos); if(x==0) x <- 12; return(x) }
	if(grp=="Decade"){ x <- length(decs); if(x==0) x <- 23; return(x) }
	if(grp=="Location") return(length(locs))
}
	
# @knitr sh_func11
getFacetChoicesHeatmap <- function(inx, iny=NULL, x.choices=NULL){
	if(!is.null(iny)){
		choices <- x.choices[-which(x.choices==inx | x.choices==iny)]
		if(length(choices)) return(c("None", choices)) else return()
	} else NULL
}

# @knitr sh_func12
getFacetPanels <- function(fct, mods, scens, mos, decs, locs){
	if(!is.null(fct) && fct!="None"){
		if(fct=="Phase") return(2)
		if(fct=="Model") return(length(mods))
		if(fct=="Scenario") return(length(scens))
		if(fct=="Month"){ x <- length(mos); if(x==0) x <- 12; return(x) }
		if(fct=="Decade"){ x <- length(decs); if(x==0) x <- 23; return(x) }
		if(fct=="Location") return(length(locs))
	} else NULL
}

# @knitr sh_func13
getPooledVars <- function(inx, iny=NULL, ingrp=NULL, infct, grp.fct.choices=NULL, choices, mos, years, decades, locs, scenarios, models, cmip3scens, cmip5scens, cmip3mods, cmip5mods){
	if(!is.null(ingrp) & !is.null(infct)){
		if(inx!="Year") grp.fct.choices <- union("Year", grp.fct.choices)
		ind <- which(grp.fct.choices %in% union(c("None", ingrp), infct))
		if(length(ind)) grp.fct.choices <- grp.fct.choices[-ind]
		if(length(grp.fct.choices)) choices <- grp.fct.choices else return()
	}
	if(!is.null(iny) & !is.null(infct)) ingrp <- iny
	if(!is.null(ingrp) & !is.null(infct)){
		pooled.var <- choices[!(choices %in% c(inx,ingrp,infct))]
		if(infct=="None"){
			pooled.var <- choices[sort(match( unique(c("Year", pooled.var[which(pooled.var %in% grp.fct.choices)])), choices))]
			if(inx=="Year") pooled.var <- pooled.var[pooled.var!="Year"]
		}
		if(length(years)==1) pooled.var <- pooled.var[pooled.var!="Year"]
		if(length(decades)==1) pooled.var <- pooled.var[pooled.var!="Decade"]
		if(length(locs)==1) pooled.var <- pooled.var[pooled.var!="Location"]
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
}

# @knitr sh_func14
getPlotSubTitle <- function(pooled, yrs, mos, mod, scen, phase=c("AR4", "AR5"), loc){
	if(!length(mos)) mos <- "Jan - Dec"
	yrs.lab <- ifelse("Year" %in% pooled, paste("Years: ", paste(yrs[1], "-", tail(yrs,1)), "\n", collapse=""), "")
	mos.lab <- ifelse("Month" %in% pooled, paste("Months: ", paste(mos, collapse=", "), "\n", collapse=""), "")
	mod.lab <- ifelse("Model" %in% pooled, paste("GCMs: ", paste(mod, collapse=", "), "\n", collapse=""), "")
	scen.lab <- ifelse("Scenario" %in% pooled, paste("Scenarios: ", paste(scen, collapse=", "), "\n", collapse=""), "")
	phase.lab <- ifelse("Phase" %in% pooled, paste("Phases: ", paste(phase, collapse=", "), "\n", collapse=""), "")
	loc.lab <- ifelse("Location" %in% pooled, paste("Locations: ", paste(loc, collapse=", "), "\n", collapse=""), "")
	no.pooled <- all(c(loc.lab, phase.lab, scen.lab, mod.lab, mos.lab, yrs.lab) == "")
	x <- ifelse(no.pooled, "", paste("Pooled variables:\n", loc.lab, phase.lab, scen.lab, mod.lab, mos.lab, yrs.lab, sep=""))
	x
}

# @knitr sh_func15
getPlotTitle <- function(grp, facet, pooled, yrs, mos, mod, scen, phase=c("AR4", "AR5"), loc){
	gfp <- c(grp, facet, pooled)
	if(!length(mos)) mos <- "Jan - Dec"
	yrs.lab <- ifelse("Year" %in% gfp, "", paste(yrs[1], "-", tail(yrs,1)))
	mos.lab <- ifelse("Month" %in% gfp, "", paste(mos, collapse=", "))
	mod.lab <- ifelse("Model" %in% gfp, "", paste(mod, collapse=", "))
	scen.lab <- ifelse("Scenario" %in% gfp, "", paste(scen, collapse=", "))
	loc.lab <- ifelse("Location" %in% gfp, "", paste(loc, collapse=", "))
	x <- paste(loc.lab, scen.lab, mod.lab, mos.lab, yrs.lab)
	x
}

# @knitr sh_func16
getSubjectChoices <- function(inx, ingrp, pooled.vars){
	if(inx=="Decade") return(NULL)
	x <- c()
	if(!is.null(pooled.vars)) x <- c(x, pooled.vars)
	if(inx!="Year") x <- c(x, "Year")
	x <- unique(c(ingrp, x[x!="Decade"]))
	x <- x[x!="" & x!="None"]
	x
}

# @knitr sh_func17
adjustGroup <- function(grp, n.grp){
	if(is.null(grp) || grp=="None") grp <- 1
	if(n.grp==1) grp <- 1
	grp
}

# @knitr sh_func18
withinGroupLines <- function(x, subjects){
	if(x=="Decade") subjects <- 1
	if(!length(subjects) || subjects[1] == "") subjects <- 1
	if(subjects[1]!=1){
		subjectlines <- TRUE
		if(length(subjects) > 1) subjects <- sprintf("interaction(%s)", paste0(subjects, collapse = ", "))
	} else subjectlines <- FALSE
	list(subjects=subjects, subjectlines=subjectlines)
}

# @knitr sh_func19
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

# @knitr sh_func20
scaleColFillMan <- function(g, default, colpal, n.grp, cbpalette){
	nominal.abb <- substr(c("CB-friendly", "Accent","Dark2","Pastel1","Pastel2","Paired","Set1","Set2","Set3"), 1, 4)
	if(substr(colpal, 1, 4) %in% nominal.abb) colseq <- "Nominal" else colseq <- "Not nominal"
	if(colseq=="Nominal" & default) g <- g + scale_colour_manual(values=cbpalette) + scale_fill_manual(values=cbpalette)
	if(!default){
		if(substr(colpal,1,3)=="HCL"){
			clr <- colorsHCL(n.grp)
			g <- g + scale_color_manual(values=clr) + scale_fill_manual(values=clr)
		} else if(substr(colpal, 1, 3)=="Rai"){
			clr <- rainbow(n.grp, s=1, v=1, start=0, end=max(1, n.grp-1)/n.grp, alpha=1)
			g <- g + scale_color_manual(values=clr) + scale_fill_manual(values=clr)
		} else if(colpal!="none"){
			g <- g + scale_color_brewer(palette=strsplit(colpal," ")[[1]][1]) + scale_fill_brewer(palette=strsplit(colpal," ")[[1]][1])
		}
	}
	g
}

# @knitr sh_func21
pooledVarsCaption <- function(pv, permit, ingrp=NULL){
	if(length(pv)){
		pv <- tolower(paste0(pv,"s"))
		if(length(pv)==2){
			pv <- paste(pv, collapse=" and ")
		} else if(length(pv)>2) {
			n <- length(pv)
			pv <- paste(c(paste(pv[1:(n-2)], collapse=", "), paste(pv[(n-1):n], collapse=" and ")), collapse=", ")
		}
		if(permit){
			if(is.null(ingrp) || ingrp=="None") h5(paste0("Observations include multiple ", pv, ".")) else h5(paste0("Observations in each color group include multiple ", pv, "."))
		}
	}
}

# @knitr sh_func22
getColorSeq <- function(d, grp=NULL, n.grp=NULL, heat=FALSE, overlay=FALSE){
	if(!is.null(d) && heat) return( c("Increasing","Centered") )
	if(is.null(grp) || grp=="None") return()
	if(overlay) n.grp <- n.grp + 1
	x <- "Nominal"
	if(n.grp>=8) x <- c("Increasing","Centered", "Cyclic") else if(!(grp %in% c("Phase", "Model", "Location"))) x <- c("Nominal","Increasing","Centered","Cyclic")
	if(!is.null(d)) x else NULL
}

# @knitr sh_func23
getColorPalettes <- function(id, colseq, grp=NULL, n.grp=NULL, fill.vs.border=NULL, fill.vs.border2=TRUE, heat=FALSE, overlay=FALSE){
	if(!is.null(colseq)){
		pal.inc <- c("Blues","BuGn","BuPu","GnBu","Greens","Greys","Oranges","OrRd","PuBu","PuBuGn","PuRd","Purples","RdPu","Reds","YlGn","YlGnBu","YlOrBr","YlOrRd")
		pal.cen <- c("BrBG","PiYG","PRGn","PuOr","RdBu","RdGy","RdYlBu","RdYlGn","Spectral")
		pal.nom <- c("Accent","Dark2","Pastel1","Pastel2","Paired","Set1","Set2","Set3")
		pal.cyc <- c("HCL", "Rainbow")
		x <- vector("list", length(colseq))
		if(!heat) if(is.null(grp) || grp=="None") return()
		if(!heat && overlay) n.grp <- n.grp + 1
		for(i in 1:length(x)){
			if(heat & colseq[i]=="Increasing") x[[i]] <- pal.inc
			if(heat & colseq[i]=="Centered") x[[i]] <- pal.cen
			if(!heat){
				if(colseq[i]=="Nominal"){
					pal <- pal.nom
					if(n.grp<=8) pal <- c("CB-friendly",pal)
					if(length(fill.vs.border) && fill.vs.border && fill.vs.border2) pal <- paste(rep(pal,each=2),c("fill","border")) 
				} else if(colseq[i]=="Cyclic"){
					pal <- pal.cyc
					if(length(fill.vs.border) && fill.vs.border && fill.vs.border2) pal <- paste(rep(pal,each=2),c("fill","border")) 
				} else if(colseq[i]=="Increasing"){
					pal <- pal.inc
				} else if(colseq[i]=="Centered"){
					pal <- pal.cen
				}
				if(exists("pal")) x[[i]] <- pal
			}
		}
		if(any(unlist(lapply(x, is.null)))) return()
		names(x) <- colseq
		return( selectizeInput(id, "Color palette", choices=x, selected=x[[1]][1], width="100%") )
	} else NULL
}

# @knitr sh_func24
annotatePlot <- function(g, data, x, y, y.fixed=NULL, text, col="black", bp=NULL, bp.position=NULL, n.groups=1){
	if(is.factor(data[[y]])) y.coord <- 0.525 else if(is.null(y.fixed)) y.coord <- max(data[[y]]) else y.coord <- y.fixed
	if(!is.null(bp) && bp) if(bp.position=="fill") y.coord <- 1 else if(bp.position=="stack") y.coord <- n.groups*y.coord
	x.coord <- if(is.factor(data[[x]])) 0.525 else min(data[[x]])
	g <- g + annotate("text", y=y.coord, x=x.coord, label=bquote(.(text)), hjust=0, vjust=1, fontface=3, colour=col)
	g
}

# @knitr sh_func25
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
