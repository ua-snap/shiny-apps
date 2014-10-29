function(d, d2, x, y, z, panels, facet.cols=ceiling(sqrt(panels)), facet.by, fontsize=16, colpal, reverse.colors=FALSE, aspect_1to1=FALSE, show.values=FALSE,
	show.overlay=FALSE, overlay=NULL, plot.title="", plot.subtitle="", show.panel.text=FALSE, show.title=FALSE, lgd.pos="Top", units=c("C","mm"),
	pooled.var, plot.theme.dark=FALSE, show.logo=F, logo.mat=NULL){
		if(is.null(d)) return(plot(0,0,type="n",axes=F,xlab="",ylab=""))
		if(plot.theme.dark) { bg.theme <- "black"; color.theme <- "white" } else { bg.theme <- "white"; color.theme <- "black" }
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
		if(!length(lgd.pos)) lgd.pos="Top"
		if(!length(fontsize)) fontsize <- 16
		fontsize=as.numeric(fontsize)
		main <- paste0("Code this title: ", plot.title) # agg stat metrics adjustment required
		if(length(unique(d2[,z]))==1) g <- ggplot(d, aes_string(x=x, y=y, fill="Val")) else g <- ggplot(d2, aes_string(x=x, y=y, fill=z))
		if(plot.theme.dark) g <- g + theme_black(base_size=fontsize) else g <- g + theme_bw(base_size=fontsize)
		g <- g + geom_tile(colour=color.theme) + theme(legend.position=tolower(lgd.pos))
		if(aspect_1to1) g <- g + coord_fixed(ratio=1)
		brew.col <- colorRampPalette(rev(brewer.pal(8, colpal)))(50)
		if(reverse.colors) brew.col <- rev(brew.col)
		g <- g + scale_fill_gradientn(colours=brew.col)
		if(!show.logo && show.title) g <- g + ggtitle(bquote(atop(.(main))))
		if(!is.null(facet.by)) if(facet.by!="None") g <- g + facet_wrap(as.formula(paste("~",facet.by)), ncol=facet.cols)
		if(show.panel.text) g <- annotatePlot(g, data=d, x=x, y=y, text=plot.subtitle, col=color.theme)
		if(show.values) g <- g + geom_text(data=d2, aes_string(fill=z, label=z))
		g <- addLogo(g, show.logo, logo.mat, show.title, main, fontsize)
		print(g)
}