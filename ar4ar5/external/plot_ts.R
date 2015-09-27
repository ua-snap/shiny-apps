# @knitr plot_ts
function(d, d.grp, d.pool, x, y, y.name, Log=FALSE, panels, grp, n.grp, ingroup.subjects=NULL, facet.cols=min(ceiling(sqrt(panels)),5), facet.by, vert.facet=FALSE, fontsize=16,
	colpal, linePlot, barPlot, pts.alpha=0.5, bartype, bardirection, show.points=TRUE, show.lines=FALSE, show.overlay=FALSE, overlay=NULL, jit=FALSE,
	plot.title="", plot.subtitle="", show.panel.text=FALSE, show.title=FALSE, lgd.pos="Top", units=c("C","mm"),
	yrange, clbootbar, clbootsmooth, pooled.var, plot.theme.dark=FALSE, show.logo=F, logo.mat=NULL){
		if(is.null(d)) return(plot(0,0,type="n",axes=F,xlab="",ylab=""))
		if(plot.theme.dark) { bg.theme <- "black"; color.theme <- "white" } else { bg.theme <- "white"; color.theme <- "black" }
		if(d$Var[1]=="Temperature") { bartype <- barPlot <- NULL; Log <- FALSE }
		if(!show.lines) ingroup.subjects <- NULL
		if(show.overlay && !is.null(overlay)) show.overlay <- TRUE else show.overlay <- FALSE
		if(show.overlay) overlay$Observed <- "CRU 3.2"
		bar.pos <- "dodge"
		if(!length(lgd.pos)) lgd.pos="Top"
		if(!length(fontsize)) fontsize <- 16
		fontsize=as.numeric(fontsize)
		if(is.null(pts.alpha)) pts.alpha <- 0.5
		
		#### Point dodging when using grouping variable
		wid <- 0.9
		dodge <- position_dodge(width=wid)
		x.n <- length(unique(d[, get(x)]))
		if(is.character(grp) & n.grp>1){
			dodge.pts <- dodgePoints(d, x, grp, n.grp, facet.by, width=wid)
			xdodge <- "xdodge"
			d$xdodge <- dodge.pts$x.num + dodge.pts$grp.num
		}
		if(Log){
			units[2] <- paste("log", units[2])
			logy <- paste0("Log_", y)
			d[, c(logy) := round(log(get(y) + 1), 1)]; d.pool[, c(logy) := round(log(get(y) + 1), 1)]; d.grp[, c(logy) := round(log(get(y) + 1), 1)]
			if(show.overlay) overlay[, c(logy) := round(log(get(y) + 1), 1)]
			y <- logy
		}
		if(d$Var[1]=="Temperature") ylb <- paste0(y.name, " temperature (",units[1],")") else ylb <- paste0(y.name, " precipitation (",units[2],")")
		main <- paste0("", tolower(d$Var[1]), ": ", plot.title)
		if(jit) point.pos <- position_jitter(0.1,0.1) else point.pos <- "identity"
		if(!is.null(bartype) & !is.null(barPlot)){
			if(barPlot) bar.pos <- tolower(strsplit(bartype," ")[[1]][1])
			if(bartype=="Fill (Proportions)") ylb <- "Precipitation (proportions)"
		}
		wgl <- withinGroupLines(x=x, subjects=ingroup.subjects)
		grp <- adjustGroup(grp=grp, n.grp=n.grp)
		if(grp==1) {colpal <- "none"; color <- fill <- NULL} else color <- fill <- grp
		scfm <- scaleColFillMan_prep(fill=fill, col=colpal)
		fill <- scfm$fill
		if(length(vert.facet)) if(vert.facet) facet.cols <- 1
		g <- ggplot(d, aes_string(x=x,y=y,group=wgl$subjects,order=grp,colour=color,fill=fill))
		if(plot.theme.dark) g <- g + theme_black(base_size=fontsize) else g <- g + theme_bw(base_size=fontsize)
		g <- g + ylab(ylb) + theme(legend.position=tolower(lgd.pos), legend.box="horizontal")
		if(!show.logo && show.title) g <- g + ggtitle(bquote(atop(.(main))))
		if(length(colpal)) g <- scaleColFillMan(g=g, default=scfm$scfm, colpal=colpal, n.grp=n.grp, cbpalette=cbpalette) # cbpalette source?
		if(!is.null(facet.by)) if(facet.by!="None") g <- g + facet_wrap(as.formula(paste("~",facet.by)), ncol=facet.cols)
		if(!is.null(barPlot) && barPlot){
			if(is.null(fill)){
				g <- g + stat_summary(data=d.pool,aes_string(group=grp), fun.y=mean, geom="bar", position=bar.pos)
			} else g <- g + stat_summary(data=d.pool,aes_string(group=grp),fun.y=mean, geom="bar", position=bar.pos, colour=color.theme)
			if(!is.null(bardirection)) if(bardirection=="Horizontal bars") g <- g + coord_flip()
		}
		if(!is.null(linePlot) && linePlot){
			if(wgl$subjectlines) { if(grp==1) g <- g + geom_line(position="identity", colour=color.theme, alpha=pts.alpha) else g <- g + geom_line(position="identity", alpha=pts.alpha) }
			if(show.points){
				if(!is.null(barPlot) && barPlot && is.character(grp) && n.grp>1 && x!="Year"){
					g <- g + geom_point(aes_string(x=xdodge), pch=21, size=4, colour=color.theme, alpha=pts.alpha, position=position_jitter(width=wid/(x.n*mean(dodge.pts$grp.n))))
				} else {
					g <- g + geom_point(pch=21, size=4, colour=color.theme, alpha=pts.alpha, position=point.pos)
				}
			}
			if(grp==1) g <- g + stat_summary(data=d, aes_string(group=grp),fun.y=mean, colour=color.theme, size=1, geom="line") else g <- g + stat_summary(data=d, aes_string(group=grp),fun.y=mean, size=1, geom="line")
		} else {
			if(wgl$subjectlines) { if(grp==1) g <- g + geom_line(position="identity", colour=color.theme, alpha=pts.alpha) else g <- g + geom_line(position="identity", alpha=pts.alpha) }
			if(show.points){
				if(!is.null(barPlot) && barPlot && is.character(grp) && n.grp>1 && x!="Year"){
					g <- g + geom_point(aes_string(x=xdodge), pch=21, size=4, colour=color.theme, alpha=pts.alpha, position=position_jitter(width=wid/(x.n*mean(dodge.pts$grp.n))))
				} else {
					g <- g + geom_point(pch=21, size=4, colour=color.theme, alpha=pts.alpha, position=point.pos)
				}
			}
		}

		if(!is.null(yrange)){
			if(yrange){
				dodge <- position_dodge(width=0.9)
				if(grp==1){
					g <- g + stat_summary(aes_string(group=grp), colour="orange", fun.y=mean, fun.ymin=min, fun.ymax=max, geom="errorbar", position=dodge, width=0.5)
				} else if(length(grep("fill",colpal))){
					g <- g + stat_summary(aes_string(group=grp), colour=color.theme, fun.y=mean, fun.ymin=min, fun.ymax=max, geom="errorbar", position=dodge, width=0.5)
				} else g <- g + stat_summary(aes_string(group=grp, colour=grp), fun.y=mean, fun.ymin=min, fun.ymax=max, geom="errorbar", position=dodge, width=0.5)
			}
		}
		#if(!is.null(clbootbar)) if(clbootbar) g <- g + stat_summary(aes_string(group=x), fun.data="mean_cl_boot", geom="crossbar", colour="black")
		if(!is.null(clbootsmooth)){
			if(clbootsmooth){
				if(!is.null(pooled.var)) g <- g + stat_summary(data=d.pool, aes_string(group=grp, colour=grp, fill=grp), fun.data="mean_cl_boot", geom="smooth")
				g <- g + stat_summary(data=d.grp, aes_string(group=grp), fun.data="mean_cl_boot", geom="smooth", colour=color.theme, fill=color.theme)
			}
		}
		if(show.overlay){
			observed.col <- if(grp==1) "red" else color.theme
			if(wgl$subjectlines) g <- g + geom_line(data=overlay, aes_string(x=x, y=y, group=wgl$subjects, colour=NULL, fill=NULL), position="identity", colour=observed.col, alpha=pts.alpha)
			if(!is.null(linePlot) && linePlot){
				g <- g + stat_summary(data=overlay, aes_string(x=x, y=y, group=grp, colour=NULL, fill=NULL, size="Observed"), fun.y=mean, geom="line", colour=observed.col)	
			}
			if(show.points) g <- g + geom_point(data=overlay, aes_string(x=x, y=y, group=NULL, colour=NULL, fill=NULL), position=point.pos, pch=21, size=4, fill=color.theme, colour="red", alpha=pts.alpha)
		}
		if(show.panel.text) g <- annotatePlot(g, data=d, x=x, y=y, text=plot.subtitle, col=color.theme, bp=barPlot, bp.position=bar.pos, n.groups=n.grp/2) #n.grp/2 is a rough estimate
        g <- g + guides(fill=guide_legend(override.aes=list(alpha=1)), colour=guide_legend(override.aes=list(alpha=1)))
		g <- addLogo(g, show.logo, logo.mat, show.title, main, fontsize)
		print(g)
}
