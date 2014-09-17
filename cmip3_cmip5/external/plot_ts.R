function(d, d.grp, d.pool, x, y, panels, grp, n.grp, ingroup.subjects=NULL, facet.cols=min(ceiling(sqrt(panels)),5), facet.by, vert.facet=FALSE, fontsize=16,
	colpal, colseq, linePlot, barPlot, pts.alpha=0.5, bartype, bardirection, show.points=TRUE, show.overlay=FALSE, overlay=NULL, jit=FALSE,
	plot.title="", plot.subtitle="", show.panel.text=FALSE, show.title=FALSE, lgd.pos="Top", units=c("C","mm"),
	mos=12, yrange, clbootbar, clbootsmooth, pooled.var, show.logo=F, logo.mat=NULL){
		if(is.null(d)) return(plot(0,0,type="n",axes=F,xlab="",ylab=""))
		if(show.overlay && !is.null(overlay)) show.overlay <- TRUE else show.overlay <- FALSE
		if(show.overlay) overlay$Observed <- "CRU 3.1"
		bar.pos <- "dodge"
		if(!length(lgd.pos)) lgd.pos="Top"
		if(!length(fontsize)) fontsize <- 16
		fontsize=as.numeric(fontsize)
		if(is.null(pts.alpha)) pts.alpha <- 0.5
		if(d$Var[1]=="Temperature") ylb <- paste0("Temperature (",units[1],")") else ylb <- paste0("Precipitation (",units[2],")")
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
		g <- ggplot(d, aes_string(x=x,y=y,group=wgl$subjects,order=grp,colour=color,fill=fill)) +
				theme_bw(base_size=fontsize) + ylab(ylb) + theme(legend.position=tolower(lgd.pos))
		if(!show.logo && show.title) g <- g + ggtitle(bquote(atop(.(main))))
		if(length(colpal) & length(colseq)) g <- scaleColFillMan(g=g, default=scfm$scfm, colseq=colseq, colpal=colpal, mos=mos, n.grp=n.grp, cbpalette=cbpalette) # cbpalette source?
		if(!is.null(facet.by)) if(facet.by!="None/Force Pool") g <- g + facet_wrap(as.formula(paste("~",facet.by)), ncol=facet.cols)
		if(!is.null(barPlot) && barPlot){
			if(is.null(fill)){
				g <- g + stat_summary(data=d.pool,aes_string(group=grp), fun.y=mean, geom="bar", position=bar.pos)
			} else g <- g + stat_summary(data=d.pool,aes_string(group=grp),fun.y=mean, geom="bar", position=bar.pos, colour="black")
			if(!is.null(bardirection)) if(bardirection=="Horizontal bars") g <- g + coord_flip()
		}
		if(!is.null(linePlot) && linePlot){
			if(wgl$subjectlines) g <- g + geom_line(position="identity", alpha=pts.alpha)
			if(show.points) g <- g + geom_point(position=point.pos, pch=21, size=4, colour="black", alpha=pts.alpha)
			g <- g + stat_summary(data=d, aes_string(group=grp),fun.y=mean, size=1, geom="line")
		} else {
			if(wgl$subjectlines) g <- g + geom_line(position="identity", alpha=pts.alpha)
			if(show.points) g <- g + geom_point(position=point.pos, pch=21, size=4, colour="black", alpha=pts.alpha)
		}
		if(!is.null(yrange)){
			if(yrange){
				dodge <- position_dodge(width=0.9)
				if(grp==1){
					g <- g + stat_summary(aes_string(group=grp), colour="orange", fun.y=mean, fun.ymin=min, fun.ymax=max, geom="errorbar", position=dodge, width=0.5)
				} else if(length(grep("fill",colpal))){
					g <- g + stat_summary(aes_string(group=grp), colour="black", fun.y=mean, fun.ymin=min, fun.ymax=max, geom="errorbar", position=dodge, width=0.5)
				} else g <- g + stat_summary(aes_string(group=grp, colour=grp), fun.y=mean, fun.ymin=min, fun.ymax=max, geom="errorbar", position=dodge, width=0.5)
			}
		}
		#if(!is.null(clbootbar)) if(clbootbar) g <- g + stat_summary(aes_string(group=x), fun.data="mean_cl_boot", geom="crossbar", colour="black")
		if(!is.null(clbootsmooth)){
			if(clbootsmooth){
				if(!is.null(pooled.var)) g <- g + stat_summary(data=d.pool, aes_string(group=grp, colour=grp, fill=grp), fun.data="mean_cl_boot", geom="smooth")
				g <- g + stat_summary(data=d.grp, aes_string(group=grp), fun.data="mean_cl_boot", geom="smooth", colour="black", fill="black")
			}
		}
		if(show.overlay){
			observed.col <- if(grp==1) "red" else "black"
			if(wgl$subjectlines) g <- g + geom_line(data=overlay, aes_string(x=x, y=y, group=wgl$subjects, colour=NULL, fill=NULL), position="identity", colour=observed.col, alpha=pts.alpha)
			if(!is.null(linePlot) && linePlot){
				g <- g + stat_summary(data=overlay, aes_string(x=x, y=y, group=grp, colour=NULL, fill=NULL, size="Observed"), fun.y=mean, geom="line", colour=observed.col)	
			}
			if(show.points) g <- g + geom_point(data=overlay, aes_string(x=x, y=y, group=NULL, colour=NULL, fill=NULL), position=point.pos, pch=21, size=4, fill="black", colour="red", alpha=pts.alpha)
		}
		if(show.panel.text) g <- annotatePlot(g, data=d, x=x, y=y, text=plot.subtitle, bp=barPlot, bp.position=bar.pos, n.groups=n.grp/2) #n.grp/2 is a rough estimate
		g <- addLogo(g, show.logo, logo.mat, show.title, main, fontsize)
		print(g)
}