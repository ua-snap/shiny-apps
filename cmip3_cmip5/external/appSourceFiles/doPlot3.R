function(d, d.grp, d.pool, x, y, stat="SD", around.mean=FALSE, error.bars=FALSE, panels, grp, n.grp, ingroup.subjects=NULL, facet.cols=min(panels,3), facet.by, vert.facet=FALSE, fontsize=16,
	colpal, colseq, altplot, boxplots=FALSE, bartype, bardirection, show.points=FALSE, jit=FALSE, lgd.pos="Top", units=c("C","mm"),
	mos=12, yrange, clbootbar, clbootsmooth, show.logo=F, logo.mat=NULL){
		bar.pos <- "dodge"
		if(!length(lgd.pos)) lgd.pos="Top"
		if(!length(fontsize)) fontsize <- 16
		dodge <- position_dodge(width = 0.9)
		if(is.character(grp) & n.grp>1){
			x.n <- length(unique(d[,x]))
			grp.n <- length(unique(d[,grp]))
			x.num <- as.numeric(factor(d[,x]))
			grp.num <- 0.9*( (as.numeric(factor(d[,grp]))/grp.n)-(1/grp.n + ((grp.n-1)/2)/(grp.n)) )
			d$xdodge <- x.num + grp.num
			xdodge <- "xdodge"
		}
		fontsize=as.numeric(fontsize)
		#if(show.logo) fontsize <- fontsize - 0
		if(!is.null(d)){
			if(around.mean) ylb.insert <- "" else ylb.insert <- paste0(stat, " ")
			if(d$Var[1]=="Temperature") ylb <- paste0("Temperature ", ylb.insert, "(",units[1],")") else ylb <- paste0("Precipitation ", ylb.insert, "(",units[2],")")
			#if(d$Var[1]=="Precipitation" & altplot) if(bartype=="Fill (Proportions)") ylb <- "Precipitation (proportions)"
			main <- "No title yet" #paste(strsplit(input$locationSelect,", ")[[1]][1],d$Region[1],sep=", ")
			if(jit) point.pos <- position_jitter(0.1,0.1) else point.pos <- "identity"
			if(!is.null(bartype)){
				bar.pos <- tolower(strsplit(bartype," ")[[1]])
				if(bartype=="Fill (Proportions)") ylb <- "Precipitation (proportions)"
			} else bar.pos <- "dodge"
			wgl <- withinGroupLines(x=x, subjects=ingroup.subjects)
			ingroup.subjects <- wgl$subjects
			subject.lines <- wgl$subjectlines
			if(is.null(grp) || grp=="None/Force Pool") grp <- 1
			if(n.grp==1) grp <- 1
			if(grp==1) {colpal <- "none"; color <- fill <- NULL} else color <- fill <- grp
			scfm <- scaleColFillMan_prep(fill=fill, col=colpal)
			fill <- scfm$fill
			if(length(vert.facet)) if(vert.facet) facet.cols <- 1
			if(around.mean){
				if(is.null(boxplots) || boxplots=="") { g <- ggplot(d, aes_string(x=x,y=y,order=grp,colour=color,fill=fill)) } else { d$Year <- factor(d$Year); g <- ggplot(d, aes_string(x=x,y=y)) }
			} else g <- ggplot(d, aes_string(x=x,y=y,group=grp,order=grp,colour=color,fill=fill))
			g <- g + theme_bw(base_size=fontsize) + ylab(ylb) + theme(legend.position=tolower(lgd.pos))
			if(!show.logo) g <- g + ggtitle(main)
			if(length(colpal) & length(colseq)) g <- scaleColFillMan(g=g, default=scfm$scfm, colseq=colseq, colpal=colpal, mos=mos, n.grp=n.grp, cbpalette=cbpalette) # cbpalette source?
			if(!is.null(facet.by)) if(facet.by!="None/Force Pool") g <- g + facet_wrap(as.formula(paste("~",facet.by)), ncol=facet.cols)
			if(!around.mean & stat %in% c("SD", "SE", "Full Spread")){
				f <- switch(stat, "SD" = sd, "SE" = function(x) sd(x)/sqrt(length(x)), "Full Spread" = function(x) diff(range(x)))
				if(length(grep("border",colpal))){
					g <- g + stat_summary(aes_string(group=grp), fun.y=f, geom="bar", position=bar.pos)
				} else g <- g + stat_summary(aes_string(group=grp), colour="black", fun.y=f, geom="bar", position=bar.pos)
			}
			#g <- g + geom_bar(stat=stat, position=bar.pos)
			#g <- g + stat_summary(data=d.pool,aes_string(group=grp),fun.y=stat, geom="bar", position=bar.pos)
			if(around.mean){
				if(subject.lines){
					if(grp==1){
						g <- g + geom_line(aes_string(group=ingroup.subjects), position="identity")
					} else {
						g <- g + geom_line(aes_string(group=ingroup.subjects, colour=grp), position="identity")
					}
				}
				if(grp==1) basic.fill.clr <- NULL else basic.fill.clr <- grp
				if(boxplots=="Basic") g <- g + geom_boxplot(aes_string(fill=basic.fill.clr))
				if(boxplots=="Add points"){
					g <- g + geom_boxplot(aes_string(colour=basic.fill.clr), fill="white", outlier.colour=NA, position=dodge)
					if(is.character(grp) & n.grp>1){
						g <- g + geom_point(aes_string(x=xdodge, fill=basic.fill.clr), pch=21, size=4, colour="black", alpha=0.8, position=position_jitter(width=1/(x.n*grp.n)))
					} else {
						g <- g + geom_point(aes_string(fill=basic.fill.clr), pch=21, size=4, colour="black", alpha=0.8, position=position_jitter(width=1))
					}
				}
				if(is.null(boxplots) || boxplots==""){
					#if(subject.lines) g <- g + geom_line(aes_string(group=ingroup.subjects), position="identity")
					if(show.points) g <- g + geom_point(position=point.pos)
					g <- g + aes_string(group=grp)
					g <- g + stat_summary(fun.y=mean, geom="line", lwd=1)
				
					ply.vars <- c(x,grp)
					if(!is.null(facet.by) && facet.by!="None/Force Pool") ply.vars <- c(ply.vars, facet.by)
					d.sum <- ddply(d, ply.vars, summarise, Mean=mean(Val), SD=sd(Val), SE=sd(Val)/sqrt(length(Val)), tval95=qt(0.975, df=length(Val)), Min=min(Val), Max=max(Val))
					
					if(stat=="95% CI") g <- g + geom_errorbar(aes(y=Mean, ymin = Mean-tval95*SE, ymax = Mean+tval95*SE), data=d.sum, width=0.25)
					if(stat=="SD") g <- g + geom_errorbar(aes(y=Mean, ymin = Mean-SD, ymax = Mean+SD), data=d.sum, width=0.25)
					if(stat=="SE") g <- g + geom_errorbar(aes(y=Mean, ymin = Mean-SE, ymax = Mean+SE), data=d.sum, width=0.25)
					if(stat=="Range") g <- g + geom_errorbar(aes(y=Mean, ymin = Min, ymax = Max), data=d.sum, width=0.25)
				}
				#g <- g + stat_summary(aes_string(group=grp), fun.y=mean, fun.ymin=function(x) errFun(x, type), fun.ymax=function(x) mean(x) + sd(x), geom="errorbar", width=0.25)#, colour="black")
			}
			# + stat_summary(aes_string(group=grp),fun.y=mean, geom="line", lwd=2)
			if(!is.null(bardirection)) if(bardirection=="Horizontal bars") g <- g + coord_flip()

			#if(!is.null(yrange)) if(yrange) g <- g + stat_summary(aes_string(group=x), fun.y=mean, fun.ymin=min, fun.ymax=max, geom="errorbar", colour="black")
			#if(!is.null(clbootbar)) if(clbootbar) g <- g + stat_summary(aes_string(group=x), fun.data="mean_cl_boot", geom="crossbar", colour="black")
			#if(!is.null(clbootsmooth)){
			#		if(clbootsmooth){
			#				if(!is.null(pooled.var)){
			#						g <- g + stat_summary(data=d.pool, aes_string(group=grp, colour=grp, fill=grp), fun.data="mean_cl_boot", geom="smooth")
			#				}
			#				g <- g + stat_summary(data=d.grp, aes_string(group=grp), fun.data="mean_cl_boot", geom="smooth", colour="black", fill="black")
			#		}
			#}
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
