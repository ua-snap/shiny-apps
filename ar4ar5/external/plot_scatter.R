# @knitr plot_scatter
function(d, x, y, x.name, y.name, Logx=FALSE, Logy=FALSE, flip.axes=FALSE, panels, grp, n.grp, facet.cols=ceiling(sqrt(panels)), facet.by, vert.facet=FALSE, fontsize=16,
	colpal, show.points=TRUE, contourlines=FALSE, hexbin=FALSE, pts.alpha=0.5, show.overlay=FALSE, overlay=NULL, jit=FALSE,
	plot.title="", plot.subtitle="", show.panel.text=FALSE, show.title=FALSE, lgd.pos="Top", units=c("C","mm"),
	pooled.var, plot.theme.dark=FALSE, show.logo=F, logo.mat=NULL){
		if(is.null(d)) return(plot(0,0,type="n",axes=F,xlab="",ylab=""))
		if(plot.theme.dark) { bg.theme <- "black"; color.theme <- "white" } else { bg.theme <- "white"; color.theme <- "black" }
		if(show.overlay & !is.null(overlay)) show.overlay <- TRUE else show.overlay <- FALSE
		if(show.overlay) overlay$Observed <- "CRU 3.2"
		if(!length(lgd.pos)) lgd.pos="Top"
		if(!length(fontsize)) fontsize <- 16
		fontsize=as.numeric(fontsize)
		if(is.null(pts.alpha)) pts.alpha <- 0.5
		if(flip.axes) { y2 <- x; y.name2 <- x.name; x <- y; x.name <- y.name; y <- y2; y.name <- y.name2 }
		if(x=="Temperature") Logx <- FALSE
		if(y=="Temperature") Logy <- FALSE
		if(Logx){
			units[2] <- paste("log", units[2])
			logx <- paste0("Log_", x)
			d[, c(logx) := round(log(get(x) + 1), 1)]
			if(show.overlay) overlay[, c(logx) := round(log(get(x) + 1), 1)]
			x <- logx
		}
		if(Logy){
			units[2] <- paste("log", units[2])
			logy <- paste0("Log_", y)
			d[, c(logy) := round(log(get(y) + 1), 1)]
			if(show.overlay) overlay[, c(logy) := round(log(get(y) + 1), 1)]
			y <- logy
		}
		if(x=="Temperature") xlb <- paste0(x.name, " temperature (",units[1],")")
		if(x=="Precipitation") xlb <- paste0(x.name, " precipitation (",units[2],")")
		if(y=="Temperature") ylb <- paste0(y.name, " temperature (",units[1],")")
		if(y=="Precipitation") ylb <- paste0(y.name, " precipitation (",units[2],")")
		main <- paste0("temperature and precipitation: ", plot.title)
		if(jit) point.pos <- position_jitter(0.1,0.1) else point.pos <- "identity"
		grp <- adjustGroup(grp=grp, n.grp=n.grp)
		if(grp==1) {colpal <- "none"; color <- fill <- NULL} else color <- fill <- grp
		scfm <- scaleColFillMan_prep(fill=fill, col=colpal)
		fill <- scfm$fill
		if(length(vert.facet)) if(vert.facet) facet.cols <- 1
		g <- ggplot(d, aes_string(x=x,y=y,group=grp,order=grp,colour=color,fill=fill))
		if(plot.theme.dark) g <- g + theme_black(base_size=fontsize) else g <- g + theme_bw(base_size=fontsize)
		g <- g + xlab(xlb) + ylab(ylb) + theme(legend.position=tolower(lgd.pos), legend.box="horizontal")
		if(!show.logo && show.title) g <- g + ggtitle(bquote(atop(.(main))))
		if(length(colpal)) g <- scaleColFillMan(g=g, default=scfm$scfm, colpal=colpal, n.grp=n.grp, cbpalette=cbpalette) # cbpalette source?
		if(!is.null(facet.by)) if(facet.by!="None") g <- g + facet_wrap(as.formula(paste("~",facet.by)), ncol=facet.cols)
		if(show.points) g <- g + geom_point(position=point.pos, pch=21, size=4, colour=color.theme, alpha=pts.alpha)
		if(!is.null(contourlines) && contourlines) g <- g + stat_density2d(size=1)
		if(hexbin) g <- g + scale_alpha(range=c(0.1,0.5), guide="none") + stat_binhex(bins=30, aes(alpha=..count..))
		if(show.overlay){
			observed.col <- if(grp==1) "red" else color.theme
			if(show.points) g <- g + geom_point(data=overlay, aes_string(x=x, y=y, colour=NULL, fill=NULL), position=point.pos, pch=21, size=4, fill=color.theme, colour="red", alpha=pts.alpha)
			if(!is.null(contourlines) && contourlines) g <- g + stat_density2d(data=overlay, aes_string(x=x, y=y, group=grp, colour=NULL, fill=NULL, size="Observed"), colour=observed.col) + guides(size=guide_legend(title="Observed"))
			if(hexbin) g <- g + stat_binhex(data=overlay, aes_string(x=x, y=y, colour=NULL, fill=NULL, alpha="..count..", size="Observed"), colour=observed.col, bins=30)
		}
		if(show.panel.text) g <- g + annotate("text", y=max(d[[y]]), x=min(d[[x]]), label=bquote(.(plot.subtitle)), hjust=0, vjust=1, fontface=3, colour=color.theme)
        g <- g + guides(fill=guide_legend(override.aes=list(alpha=1)), colour=guide_legend(override.aes=list(alpha=1)))
		g <- addLogo(g, show.logo, logo.mat, show.title, main, fontsize)
		print(g)
}
