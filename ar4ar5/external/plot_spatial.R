# @knitr plot_spatial
function(d, d.grp, d.pool, x, y, panels, grp, n.grp, ingroup.subjects=NULL, plottype, thin.sample=NULL,
	facet.cols=min(ceiling(sqrt(panels)),5), facet.by, vert.facet=FALSE, fontsize=16,
	colpal, boxplots=FALSE, linePlot, pts.alpha=0.5, density.type, strip.direction, show.points=FALSE, show.lines=FALSE, show.overlay=FALSE, overlay=NULL, jit=FALSE,
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
			d <- rbind(d, overlay)
			if(x=="Year") d$Year <- factor(d$Year)
			d[, Source := factor(c(rep("Modeled", n.d), rep("Observed", nrow(overlay))))]
			d[, Model := factor(d$Model, levels=c(overlay$Model[1], mods.d))]
		}
		if(!is.null(thin.sample) && is.numeric(thin.sample)) d <- d[seq(1, nrow(d), by=round(1/thin.sample)),]
		bar.pos <- "dodge"
		if(!length(lgd.pos)) lgd.pos="Top"
		if(!length(fontsize)) fontsize <- 16
		fontsize=as.numeric(fontsize)
		if(is.null(pts.alpha)) pts.alpha <- 0.5
		
		#### Point dodging when using grouping variable
		wid <- 0.9
		dodge <- position_dodge(width=wid)
		x.n <- length(unique(d[, get(x)]))
		if(x!=y & is.character(grp) & n.grp>1){
			dodge.pts <- dodgePoints(d, x, grp, n.grp, facet.by, width=wid)
			xdodge <- "xdodge"
			d$xdodge <- dodge.pts$x.num + dodge.pts$grp.num
		}
		
		if(d$Var[1]=="Temperature") ylb <- paste0("Temperature (",units[1],")") else ylb <- paste0("Precipitation (",units[2],")")
		if(x==y) { xlb <- ylb; ylb <- "Density" }
		main <- paste0("", tolower(d$Var[1]), " distribution: ", plot.title)
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
		if(plottype!="Stripchart") {
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
		} else if(plottype=="Stripchart") {
			if(grp==1) basic.fill.clr <- NULL else basic.fill.clr <- grp
			if(boxplots & !show.points){
				if(grp==1){
					g <- g + geom_boxplot(aes_string(x=x, y=y), fill="#AAAAAA", colour=color.theme, outlier.colour=color.theme)
				} else {
					g <- g + geom_boxplot(aes_string(x=x, y=y, fill=basic.fill.clr), colour=color.theme, outlier.colour=color.theme)
				}
			}
			if(boxplots & show.points){
				if(grp==1) g <- g + geom_boxplot(aes_string(x=x, y=y), fill=bg.theme, colour=color.theme, outlier.colour=NA, position=dodge)
				if(grp!=1) g <- g + geom_boxplot(aes_string(x=x, y=y, colour=basic.fill.clr), fill=bg.theme, outlier.colour=NA, position=dodge) 
			}
			if(show.points){
				if(is.character(grp) & n.grp>1){
					if(!boxplots) g <- g + geom_boxplot(aes_string(x=x, y=y), fill=bg.theme, colour=bg.theme, outlier.colour=NA, position=dodge)
					g <- g + geom_point(aes_string(x=xdodge, y=y, fill=basic.fill.clr), pch=21, size=4, colour=color.theme, alpha=pts.alpha, position=position_jitter(width=wid/(x.n*mean(dodge.pts$grp.n))))
				} else {
					g <- g + geom_point(aes_string(x=x, y=y, fill=basic.fill.clr), pch=21, size=4, colour=color.theme, fill="red", alpha=pts.alpha, position=position_jitter(width=wid/x.n))
				}
			}
		}

		if(plot.theme.dark) g <- g + theme_black(base_size=fontsize) else g <- g + theme_bw(base_size=fontsize)
		g <- g + ylab(ylb) + theme(legend.position=tolower(lgd.pos), legend.box="horizontal")
		if(x==y) g <- g + xlab(xlb)
		if(!show.logo && show.title) g <- g + ggtitle(bquote(atop(.(main))))
		if(length(colpal)) g <- scaleColFillMan(g=g, default=scfm$scfm, colpal=colpal, n.grp=n.grp, cbpalette=cbpalette) # cbpalette source?
		if(!is.null(facet.by)) if(facet.by!="None") g <- g + facet_wrap(as.formula(paste("~",facet.by)), ncol=facet.cols)

		if(plottype=="Stripchart" && !is.null(strip.direction) && strip.direction=="Horizontal strips") g <- g + coord_flip()
		if(show.panel.text){
			if(plottype=="Stripchart"){
				g <- annotatePlot(g, data=d, x=x, y=y, text=plot.subtitle, col=color.theme, bp=FALSE, bp.position=bar.pos, n.groups=n.grp/2) #n.grp/2 is a rough estimate
			} else {
				#max.val <- if(stat=="SD") max(d.sum[,"SD"]) else if(stat=="SE") max(d.sum[,"SE"]) else if(stat=="Full Spread") max(d.sum[,"Max"] - d.sum[,"Min"])
				#g <- annotatePlot(g, data=d, x=x, y=y, y.fixed=max.val, text=plot.subtitle, col=color.theme, bp=TRUE, bp.position=bar.pos, n.groups=n.grp) #n.grp is a rough estimate
			}
		}
        g <- g + guides(fill=guide_legend(override.aes=list(alpha=1)), colour=guide_legend(override.aes=list(alpha=1)))
		g <- addLogo(g, show.logo, logo.mat, show.title, main, fontsize)
		print(g)
}
