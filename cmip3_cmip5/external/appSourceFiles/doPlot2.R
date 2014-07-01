function(d, x, y, form.string, panels, grp, n.grp, facet.cols=ceiling(sqrt(panels)), facet.by, vert.facet=FALSE, fontsize=16,
	colpal, colseq, contourlines=FALSE, hexbin=FALSE, jit=FALSE, lgd.pos="Top", units=c("C","mm"),
	mos=12, pooled.var, show.logo=F, logo.mat=NULL){
		if(!length(lgd.pos)) lgd.pos="Top"
		if(!length(fontsize)) fontsize <- 16
		fontsize=as.numeric(fontsize)
		#if(show.logo) fontsize <- fontsize - 0
		if(!is.null(d)){
			lab <- sp_xlabylab(units=units, form.string=form.string)
			main <- "No title yet" #paste(strsplit(input$locationSelect,", ")[[1]][1],d$Region[1],sep=", ")
			if(jit) point.pos <- position_jitter(0.1,0.1) else point.pos <- "identity"
			grp <- adjustGroup(grp=grp, n.grp=n.grp)
			if(grp==1) {colpal <- "none"; color <- fill <- NULL} else color <- fill <- grp
			scfm <- scaleColFillMan_prep(fill=fill, col=colpal)
			fill <- scfm$fill
			if(length(vert.facet)) if(vert.facet) facet.cols <- 1
			g <- ggplot(d, aes_string(x=x,y=y,group=grp,order=grp,colour=color,fill=fill)) + theme_bw(base_size=fontsize) + xlab(lab$xlb) + ylab(lab$ylb) + theme(legend.position=tolower(lgd.pos))
			if(!show.logo) g <- g + ggtitle(main)
			if(length(colpal) & length(colseq)) g <- scaleColFillMan(g=g, default=scfm$scfm, colseq=colseq, colpal=colpal, mos=mos, n.grp=n.grp, cbpalette=cbpalette) # cbpalette source?
			if(!is.null(facet.by)) if(facet.by!="None/Force Pool") g <- g + facet_wrap(as.formula(paste("~",facet.by)), ncol=facet.cols)
			if(!is.null(contourlines)){
					if(contourlines) g <- g + geom_point(position=point.pos, pch=21, size=4, colour="black") + stat_density2d() else g <- g + geom_point(position=point.pos, pch=21, size=4, colour="black")
			} else g <- g + geom_point(position=point.pos, pch=21, size=4, colour="black")
			if(hexbin) g <- g + scale_alpha(range=c(0.1,0.5), guide="none") + stat_binhex(bins=30, aes(alpha=..count..)) + scale_alpha(range=c(0.1,0.5), guide="none") 
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