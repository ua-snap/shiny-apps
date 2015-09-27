# @knitr plot_variability
function(d, d.grp, d.pool, x, y, y.name, stat="SD", around.mean=FALSE, error.bars=FALSE, panels, grp, n.grp, ingroup.subjects=NULL,
	facet.cols=min(ceiling(sqrt(panels)),5), facet.by, vert.facet=FALSE, fontsize=16,
	colpal, boxplots=FALSE, pts.alpha=0.5, bartype, bardirection, show.points=FALSE, show.lines=FALSE, show.overlay=FALSE, overlay=NULL, jit=FALSE,
	plot.title="", plot.subtitle="", show.panel.text=FALSE, show.title=FALSE, lgd.pos="Top", units=c("C","mm"),
	yrange, clbootbar, clbootsmooth, plot.theme.dark=FALSE, show.logo=F, logo.mat=NULL){
		if(is.null(d)) return(plot(0,0,type="n",axes=F,xlab="",ylab=""))
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
			if(show.overlay) n.grp <- n.grp + 1
		}
		
		if(around.mean) ylb.insert <- "" else ylb.insert <- paste0(stat, " ")
		if(d$Var[1]=="Temperature") ylb <- paste0(y.name, " temperature ", ylb.insert, "(",units[1],")") else ylb <- paste0(y.name, " precipitation ", ylb.insert, "(",units[2],")")
		main <- paste0("", tolower(d$Var[1]), " variability: ", plot.title)
		if(jit) point.pos <- position_jitter(0.1,0.1) else point.pos <- "identity"
		if(!is.null(bartype)){
			bar.pos <- tolower(strsplit(bartype," ")[[1]][1])
			if(bartype=="Fill (Proportions)") ylb <- "Precipitation (proportions)"
		} else bar.pos <- "dodge"
		wgl <- withinGroupLines(x=x, subjects=ingroup.subjects)
		ingroup.subjects <- wgl$subjects
		subject.lines <- wgl$subjectlines
		if(is.null(grp) || grp=="None") grp <- 1
		if(n.grp==1) grp <- 1
		if(grp==1) {colpal <- "none"; color <- fill <- NULL} else color <- fill <- grp
		scfm <- scaleColFillMan_prep(fill=fill, col=colpal)
		fill <- scfm$fill
		if(length(vert.facet)) if(vert.facet) facet.cols <- 1
		if(grp==1) ply.vars <- x else ply.vars <- c(x,grp)
		if(!is.null(facet.by) && facet.by!="None") ply.vars <- c(ply.vars, facet.by)
		
		d.sum <- ddply(d, ply.vars, here(summarise),
			Mean1=mean(eval(parse(text=y))),
			SD1=sd(eval(parse(text=y))),
			SE=sd(eval(parse(text=y)))/sqrt(length(eval(parse(text=y)))),
			tval95=qt(0.975, df=length(eval(parse(text=y)))), Min=min(eval(parse(text=y))), Max=max(eval(parse(text=y))))
		names(d.sum)[length(ply.vars) + c(1:2)] <- c("Mean", "SD")
		
		if(around.mean){
			if(is.null(boxplots) || boxplots==FALSE) { g <- ggplot(d, aes_string(x=x,y=y,order=grp,colour=color,fill=fill)) } else { d$Year <- factor(d$Year); g <- ggplot(d, aes_string(x=x,y=y)) }
		} else g <- ggplot(d, aes_string(x=x,y=y,group=grp,order=grp,colour=color,fill=fill))
		if(plot.theme.dark) g <- g + theme_black(base_size=fontsize) else g <- g + theme_bw(base_size=fontsize)
		g <- g + ylab(ylb) + theme(legend.position=tolower(lgd.pos), legend.box="horizontal")
		if(!show.logo && show.title) g <- g + ggtitle(bquote(atop(.(main))))
		if(length(colpal)) g <- scaleColFillMan(g=g, default=scfm$scfm, colpal=colpal, n.grp=n.grp, cbpalette=cbpalette) # cbpalette source?
		if(!is.null(facet.by)) if(facet.by!="None") g <- g + facet_wrap(as.formula(paste("~",facet.by)), ncol=facet.cols)
		if(!around.mean & stat %in% c("SD", "SE", "Full Spread")){
			fsd <- function(x) { x <- sd(x); if(is.na(x)) return(0) else return(x) } # force zero when NA
			f <- switch(stat, "SD" = fsd, "SE" = function(x) fsd(x)/sqrt(length(x)), "Full Spread" = function(x) diff(range(x)))
			if(length(grep("border",colpal))){
				g <- g + stat_summary(aes_string(group=grp), fun.y=f, geom="bar", position=bar.pos)
			} else g <- g + stat_summary(aes_string(group=grp), colour=color.theme, fun.y=f, geom="bar", position=bar.pos)
		}
		if(around.mean){
			if(subject.lines){
				if(grp==1) g <- g + geom_line(aes_string(group=ingroup.subjects), position="identity", colour=color.theme, alpha=pts.alpha) else g <- g + geom_line(aes_string(group=ingroup.subjects, colour=grp), position="identity", alpha=pts.alpha)
			}
			if(grp==1) basic.fill.clr <- NULL else basic.fill.clr <- grp
			if(boxplots & !show.points) if(grp==1) g <- g + geom_boxplot(fill="#AAAAAA", colour=color.theme, outlier.colour=color.theme) else g <- g + geom_boxplot(aes_string(fill=basic.fill.clr), colour=color.theme, outlier.colour=color.theme)
			if(boxplots & show.points){
				if(is.character(grp) & n.grp>1){
					g <- g + geom_boxplot(aes_string(colour=basic.fill.clr), fill=bg.theme, outlier.colour=NA, position=dodge)
					g <- g + geom_point(aes_string(x=xdodge, fill=basic.fill.clr), pch=21, size=4, colour=color.theme, alpha=pts.alpha, position=position_jitter(width=wid/(x.n*mean(dodge.pts$grp.n))))
				} else {
					g <- g + geom_boxplot(fill=bg.theme, colour=color.theme, outlier.colour=NA, position=dodge)
					g <- g + geom_point(aes_string(fill=basic.fill.clr), pch=21, size=4, colour=color.theme, fill="red", alpha=pts.alpha, position=position_jitter(width=wid/x.n))
				}
			}
			if(is.null(boxplots) || boxplots==FALSE){
				g <- g + aes_string(group=grp)
				if(!subject.lines) g <- g + stat_summary(fun.y=mean, geom="line", lwd=1)
				if(show.points){
					if(is.character(grp) & n.grp>1){
						g <- g + geom_point(position=point.pos, pch=21, size=4, colour=color.theme, alpha=pts.alpha)
					} else {
						g <- g + geom_point(position=point.pos, pch=21, size=4, colour=color.theme, fill="red", alpha=pts.alpha)
					}
				}
				if(stat=="95% CI") g <- g + geom_errorbar(aes(y=Mean, ymin = Mean-tval95*SE, ymax = Mean+tval95*SE), data=d.sum, width=0.25)
				if(stat=="SD") g <- g + geom_errorbar(aes(y=Mean, ymin = Mean-SD, ymax = Mean+SD), data=d.sum, width=0.25)
				if(stat=="SE") g <- g + geom_errorbar(aes(y=Mean, ymin = Mean-SE, ymax = Mean+SE), data=d.sum, width=0.25)
				if(stat=="Range") g <- g + geom_errorbar(aes(y=Mean, ymin = Min, ymax = Max), data=d.sum, width=0.25)
			}
		}

		if(!is.null(bardirection)) if(bardirection=="Horizontal bars") g <- g + coord_flip()
		if(show.panel.text){
			if(around.mean){
				g <- annotatePlot(g, data=d, x=x, y=y, text=plot.subtitle, col=color.theme, bp=FALSE, bp.position=bar.pos, n.groups=n.grp/2) #n.grp/2 is a rough estimate
			} else {
				max.val <- if(stat=="SD") max(d.sum[,"SD"]) else if(stat=="SE") max(d.sum[,"SE"]) else if(stat=="Full Spread") max(d.sum[,"Max"] - d.sum[,"Min"])
				if(!is.na(max.val)) g <- annotatePlot(g, data=d, x=x, y=y, y.fixed=max.val, text=plot.subtitle, col=color.theme, bp=TRUE, bp.position=bar.pos, n.groups=n.grp) #n.grp is a rough estimate
			}
		}
        g <- g + guides(fill=guide_legend(override.aes=list(alpha=1)), colour=guide_legend(override.aes=list(alpha=1)))
		g <- addLogo(g, show.logo, logo.mat, show.title, main, fontsize)
		if(length(g$layers)) print(g)
}
