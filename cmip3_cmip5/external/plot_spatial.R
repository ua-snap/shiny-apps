
# Density when grouping:
# position: identity, dodge, fill (Do not allow stack)
# stat: bin or density for geom_histogram
# stat: density for geom_line
# histogram border color only with stat="bin", otherwise acts as fill

#if(grp==1) histogram color and fill are black or white (opposite each other regardless of background color)
#if(grp!=1) fill or colour histogram (not both) by group if stat is bin; color by group if stat is density
#if(grp==1) lines are black or white (opposite background color)
#if(grp!=1) lines remain black or white (opposite background color) with hist/density present; otherwise color by group

#Two classes of plots: (Break out) boxplots/points along categorical x-axis or (Pool/aggregate) histograms/density curves along continuous x-axis (may still group, facet, or draw subject curves)

function(d, d.grp, d.pool, x, y, panels, grp, n.grp, ingroup.subjects=NULL, plottype,
	facet.cols=min(ceiling(sqrt(panels)),5), facet.by, vert.facet=FALSE, fontsize=16,
	colpal, colseq, boxplots=FALSE, linePlot, pts.alpha=0.5, density.type, strip.direction, show.points=FALSE, show.lines=FALSE, show.overlay=FALSE, overlay=NULL, jit=FALSE,
	plot.title="", plot.subtitle="", show.panel.text=FALSE, show.title=FALSE, lgd.pos="Top", units=c("C","mm"),
	plot.theme.dark=FALSE, show.logo=F, logo.mat=NULL){
		if(is.null(d)) return(plot(0,0,type="n",axes=F,xlab="",ylab=""))
		if(x %in% c("Temperature", "Precipitation")) x <- y
		if(plot.theme.dark) { bg.theme <- "black"; color.theme <- "white" } else { bg.theme <- "white"; color.theme <- "black" }
		if(!show.lines) ingroup.subjects <- NULL
		if(show.overlay & !is.null(overlay)) show.overlay <- TRUE else show.overlay <- FALSE
		if(show.overlay){
			n.d <- nrow(d)
			mods.d <- unique(d$Model)
			yrs.tmp <- as.numeric(c(as.character(d$Year), as.character(overlay$Year)))
			d <- data.frame(rbind(d[1:7], overlay[1:7]), Year=yrs.tmp, rbind(d[9:ncol(d)], overlay[9:ncol(overlay)]))
			d$Year <- yrs.tmp
			d$Source <- factor(c(rep("Modeled", n.d), rep("Observed", nrow(overlay))))
			d$Model <- factor(d$Model, levels=c(overlay$Model[1], mods.d))
		}
		bar.pos <- "dodge"
		if(!length(lgd.pos)) lgd.pos="Top"
		if(!length(fontsize)) fontsize <- 16
		dodge <- position_dodge(width = 0.9)
		if(is.null(pts.alpha)) pts.alpha <- 0.5
		
		if(x!=y){
		#### Point dodging when using grouping variable
		x.n <- length(unique(d[,x]))
		if(is.character(grp) & n.grp>1){
			if(facet.by=="None"){
				x.names <- unique(as.character(d[,x]))
				x.num <- grp.n <- grp.num <- rep(NA, nrow(d))
				for(m in 1:length(x.names)){
					ind <- which(as.character(d[,x])==x.names[m])
					grp.n[ind] <- length(unique(d[ind, grp]))
					x.num[ind] <- m
					grp.num[ind] <- 0.9*( (as.numeric(factor(d[ind ,grp]))/grp.n[ind])-(1/grp.n[ind] + ((grp.n[ind]-1)/2)/(grp.n[ind])) )
				}
				d$xdodge <- x.num + grp.num
			} else if(facet.by!="None") {
				x.names <- unique(as.character(d[,x]))
				panel.names <- unique(as.character(d[,facet.by]))
				n.panels <- length(panel.names)
				x.num <- grp.n <- grp.num <- rep(NA, nrow(d))
				for(m in 1:n.panels){
					for(mm in 1:length(x.names)){
						ind <- which(as.character(d[,facet.by])==panel.names[m] & as.character(d[,x])==x.names[mm])
						grp.n[ind] <- length(unique(d[ind, grp]))
						x.num[ind] <- mm - 1 + as.numeric(factor(d[ind, x]))
						grp.num[ind] <- 0.9*( (as.numeric(factor(d[ind ,grp]))/grp.n[ind])-(1/grp.n[ind] + ((grp.n[ind]-1)/2)/(grp.n[ind])) )
					}
				}
				d$xdodge <- x.num + grp.num
			}
			xdodge <- "xdodge"
			if(show.overlay) n.grp <- n.grp + 1
		}
		#### End point dodge code
		}
		
		fontsize=as.numeric(fontsize)
		if(d$Var[1]=="Temperature") ylb <- paste0("Temperature (",units[1],")") else ylb <- paste0("Precipitation ", ylb.insert, "(",units[2],")")
		if(x==y) { xlb <- ylb; ylb <- "Density" }
		main <- paste0("", tolower(d$Var[1]), " variability: ", plot.title)
		if(jit) point.pos <- position_jitter(0.1,0.1) else point.pos <- "identity"
		if(!is.null(density.type)){
			if(density.type=="Overlay") den.pos <- "identity" else if(density.type=="Fill/Relative") den.pos <- "fill"
			if(density.type=="Fill/Relative") ylb <- "Relative density"
		} else den.pos <- "identity"
		wgl <- withinGroupLines(x=x, subjects=ingroup.subjects)
		ingroup.subjects <- wgl$subjects
		subject.lines <- wgl$subjectlines
		if(is.null(grp) || grp=="None") grp <- 1
		if(n.grp==1) grp <- 1
		if(grp==1) {colpal <- "none"; color <- fill <- NULL} else color <- fill <- grp
		scfm <- scaleColFillMan_prep(fill=fill, col=colpal)
		fill <- scfm$fill
		if(length(vert.facet)) if(vert.facet) facet.cols <- 1
		
		g <- ggplot(data=d)
		if(plottype!="Boxplots/Points") {
			if(plottype=="Histogram") {
				if(grp==1) g <- g + geom_histogram(aes_string(x=x, y="..density.."), colour=color.theme, fill=bg.theme, stat="bin", position=den.pos)
				if(grp!=1) g <- g + geom_histogram(aes_string(x=x, y="..density..", fill=fill), colour=color.theme, stat="bin", position=den.pos, alpha=pts.alpha)
			} else if(plottype=="Density") {
				if(grp==1) g <- g + stat_density(aes_string(x=x, y="..density.."), colour=color.theme, fill=bg.theme, position=den.pos)
				if(grp!=1) g <- g + stat_density(aes_string(x=x, y="..density..", fill=fill), position=den.pos, alpha=pts.alpha)
			}
			if(subject.lines){
				if(grp==1){
					g <- g + geom_line(aes_string(x=x, y="..density..", group=ingroup.subjects), stat="density", position=den.pos, colour=color.theme, alpha=pts.alpha)
				} else {
					if(den.pos=="identity") g <- g + geom_line(aes_string(x=x, y="..density..", group=ingroup.subjects, colour=grp), stat="density", position=den.pos, alpha=pts.alpha)
					#if(den.pos=="fill") g <- g + geom_line(aes_string(x=x, y="..density..", ymax=1, group=ingroup.subjects, colour=grp), stat="density", position=den.pos, alpha=pts.alpha) #### THIS IS DIFFICULT TO FORCE
				}
			}
			if(!is.null(linePlot) && linePlot){
				if(den.pos=="identity") g <- g + geom_line(aes_string(x=x, y="..density..", group=grp, colour=grp), stat="density", position=den.pos, size=1)
				if(den.pos=="fill") g <- g + geom_line(aes_string(x=x, y="..density..", ymax=1, group=grp, colour=grp), stat="density", position=den.pos, size=1)
			}
			#if(!is.null(linePlot) && linePlot) if(grp==1) g <- g + stat_summary(data=d, aes_string(group=grp),fun.y=mean, colour=color.theme, size=1, geom="line") else g <- g + stat_summary(data=d, aes_string(group=grp),fun.y=mean, size=1, geom="line")
		} else if(plottype=="Boxplots/Points") {
			if(grp==1) basic.fill.clr <- NULL else basic.fill.clr <- grp
			if(boxplots & !show.points) if(is.null(basic.fill.clr)) g <- g + geom_boxplot(aes_string(fill=basic.fill.clr), fill="#DDDDDD") else g <- g + geom_boxplot(aes_string(fill=basic.fill.clr))
			if(boxplots & show.points) g <- g + geom_boxplot(aes_string(colour=basic.fill.clr), fill=bg.theme, outlier.colour=NA, position=dodge) ############
			if(show.points){
				if(is.character(grp) & n.grp>1){
					g <- g + geom_point(aes_string(x=xdodge, fill=basic.fill.clr), pch=21, size=4, colour=color.theme, alpha=pts.alpha, position=position_jitter(width=0.9/(x.n*grp.n)))
				} else {
					g <- g + geom_point(aes_string(fill=basic.fill.clr), pch=21, size=4, colour=color.theme, fill="red", alpha=pts.alpha, position=position_jitter(width=0.9/x.n))
				}
			}
		}

		if(plot.theme.dark) g <- g + theme_black(base_size=fontsize) else g <- g + theme_bw(base_size=fontsize)
		g <- g + ylab(ylb) + theme(legend.position=tolower(lgd.pos))
		if(x==y) g <- g + xlab(xlb)
		if(!show.logo && show.title) g <- g + ggtitle(bquote(atop(.(main))))
		if(length(colpal) & length(colseq)) g <- scaleColFillMan(g=g, default=scfm$scfm, colseq=colseq, colpal=colpal, n.grp=n.grp, cbpalette=cbpalette) # cbpalette source?
		if(!is.null(facet.by)) if(facet.by!="None") g <- g + facet_wrap(as.formula(paste("~",facet.by)), ncol=facet.cols)

		if(plottype=="Boxplots/Points" && !is.null(strip.direction) && strip.direction=="Horizontal strips") g <- g + coord_flip()
		if(show.panel.text){
			if(plottype=="Boxplots/Points"){
				g <- annotatePlot(g, data=d, x=x, y=y, text=plot.subtitle, col=color.theme, bp=FALSE, bp.position=bar.pos, n.groups=n.grp/2) #n.grp/2 is a rough estimate
			} else {
				#max.val <- if(stat=="SD") max(d.sum[,"SD"]) else if(stat=="SE") max(d.sum[,"SE"]) else if(stat=="Full Spread") max(d.sum[,"Max"] - d.sum[,"Min"])
				#g <- annotatePlot(g, data=d, x=x, y=y, y.fixed=max.val, text=plot.subtitle, col=color.theme, bp=TRUE, bp.position=bar.pos, n.groups=n.grp) #n.grp is a rough estimate
			}
		}
		g <- addLogo(g, show.logo, logo.mat, show.title, main, fontsize)
		print(g)
}
