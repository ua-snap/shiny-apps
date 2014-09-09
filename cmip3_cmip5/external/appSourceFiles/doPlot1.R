function(d, d.grp, d.pool, x, y, panels, grp, n.grp, ingroup.subjects=NULL, facet.cols=min(ceiling(sqrt(panels)),5), facet.by, vert.facet=FALSE, fontsize=16,
	colpal, colseq, linePlot, barPlot, pts.alpha=0.5, bartype, bardirection, show.points=TRUE, show.overlay=FALSE, overlay=NULL, jit=FALSE, plot.title="", plot.subtitle="", lgd.pos="Top", units=c("C","mm"),
	mos=12, yrange, clbootbar, clbootsmooth, pooled.var, show.logo=F, logo.mat=NULL){
		if(show.overlay && !is.null(overlay)) show.overlay <- TRUE else show.overlay <- FALSE
		if(show.overlay) overlay$Observed <- "CRU 3.1"
		bar.pos <- "dodge"
		if(!length(lgd.pos)) lgd.pos="Top"
		if(!length(fontsize)) fontsize <- 16
		fontsize=as.numeric(fontsize)
		#if(show.logo) fontsize <- fontsize - 0
		if(is.null(pts.alpha)) pts.alpha <- 0.5
		if(!is.null(d)){
			if(d$Var[1]=="Temperature") ylb <- paste0("Temperature (",units[1],")") else ylb <- paste0("Precipitation (",units[2],")")
			#if(d$Var[1]=="Precipitation" & altplot) if(bartype=="Fill (Proportions)") ylb <- "Precipitation (proportions)"
			main <- paste0("", tolower(d$Var[1]), ": ", plot.title)
			if(jit) point.pos <- position_jitter(0.1,0.1) else point.pos <- "identity"
			if(!is.null(bartype) & !is.null(barPlot)){
				if(barPlot) bar.pos <- tolower(strsplit(bartype," ")[[1]])
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
			if(!show.logo) g <- g + ggtitle(bquote(atop(.(main))))
			if(length(colpal) & length(colseq)) g <- scaleColFillMan(g=g, default=scfm$scfm, colseq=colseq, colpal=colpal, mos=mos, n.grp=n.grp, cbpalette=cbpalette) # cbpalette source?
			if(!is.null(facet.by)) if(facet.by!="None/Force Pool") g <- g + facet_wrap(as.formula(paste("~",facet.by)), ncol=facet.cols)
			if(!is.null(barPlot) && barPlot){#d$Var[1]=="Precipitation"){
						if(is.null(fill)){
							g <- g + stat_summary(data=d.pool,aes_string(group=grp), fun.y=mean, geom="bar", position=bar.pos)
						} else g <- g + stat_summary(data=d.pool,aes_string(group=grp),fun.y=mean, geom="bar", position=bar.pos, colour="black")
						#if(wgl$subjectlines) g <- g + geom_line(position="identity", alpha=pts.alpha)
						#if(show.points) g <- g + geom_point(position=point.pos, pch=21, size=4, colour="black", alpha=pts.alpha)
						if(!is.null(bardirection)) if(bardirection=="Horizontal bars") g <- g + coord_flip()
			}
			if(!is.null(linePlot) && linePlot){
				#if(linePlot){
					#if(d$Var[1]=="Temperature"){
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
			if(!is.factor(d[[x]])) g <- g + annotate("text", y=max(d[[y]]), x=min(d[[x]]), label=bquote(.(plot.subtitle)), hjust=0, vjust=1, fontface=3)
			if(show.logo){
				grid.bot <- arrangeGrob(textGrob(""), g, textGrob(""), ncol=3, widths=c(1/40,19/20,1/40))
				grid.top <- arrangeGrob(
					textGrob(""),
					textGrob(main, x=unit(0.075,"npc"), y=unit(0.5,"npc"), gp=gpar(fontsize=fontsize), just=c("left")),
					rasterGrob(logo.mat, x=unit(0.85,"npc"), y=unit(0.5,"npc"), just=c("right")), # logo source?
					textGrob(""),
					widths=c(1/40,0.8,0.2,1/40), ncol=4)
				g <- grid.arrange(textGrob(""), grid.top, grid.bot, textGrob(""), heights=c(1/40,1/20,18/20,1/40), ncol=1)
			}
			print(g)
		} else plot(0,0,type="n",axes=F,xlab="",ylab="")
}