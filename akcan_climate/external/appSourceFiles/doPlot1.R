function(dat,x,y,facet.cols=min(facet.panels(),3),show.logo=F){
	scm <- sfm <- FALSE
	bar.pos <- "dodge"
	fontsize=as.numeric(input$plotFontSize)
	if(show.logo) fontsize <- fontsize - 4
	if(!is.null(dat.sub()) & !is.null(input$colorpalettes)){
		if(dat.sub()$Variable[1]=="Temperature") ylb <- paste0("Temperature (",input$units,")") else ylb <- paste0("Precipitation (",input$units,")")
		if(dat.sub()$Variable[1]=="Precipitation" & input$altplot) if(input$bartype=="Fill (Proportions)") ylb <- "Precipitation (proportions)"
		main <- paste(strsplit(input$locationSelect,", ")[[1]][1],dat.sub()$Region[1],sep=", ")
		if(input$jitterXY) point.pos <- position_jitter(0.1,0.1) else point.pos <- "identity"
		if(!is.null(input$bartype) & !is.null(input$altplot)) if(input$altplot) bar.pos <- tolower(strsplit(input$bartype," ")[[1]])
		color <- fill <- input$group
		x1 <- !length(grep("friendly",input$colorpalettes))
		if(x1){
			x1 <- length(grep("border",input$colorpalettes))
			if(x1) fill <- NULL	
		} else {
			scm <- sfm <- TRUE
			x1 <- length(grep("border",input$colorpalettes))
			if(x1) fill <- NULL
		}
		if(length(input$vert.facet)) if(input$vert.facet) facet.cols <- 1
		g <- ggplot(dat, aes_string(x=x,y=y,group=input$group,order=input$group,colour=color,fill=fill)) + 
			theme_grey(base_size=fontsize) + ylab(ylb) + theme(legend.position=tolower(input$legendPos1))
		if(!show.logo) g <- g + ggtitle(main)
		if(input$colorseq=="Nominal"){
			if(scm) g <- g + scale_colour_manual(values=cbpalette)
			if(sfm) g <- g + scale_fill_manual(values=cbpalette)
		}
		if(!scm & !sfm){
			if(input$colorseq=="Cyclic"){
				if(input$colorpalettes %in% c("Yellow-Red","Blue-Orange","Brown-Orange","Blue-Red")){
					colorcycle <- rep(strsplit(tolower(input$colorpalettes),"-")[[1]],2)[-4]
					g <- g + scale_colour_manual( values=colorRampPalette(colorcycle)(length(input$mos)) )
					g <- g + scale_fill_manual( values=colorRampPalette(colorcycle)(length(input$mos)) )
				}
			} else if(substr(input$colorpalettes,1,3)=="HCL"){
				g <- g + scale_color_manual(values=colorsHCL(n.groups())) + scale_fill_manual(values=colorsHCL(n.groups()))
			} else {
				g <- g + scale_color_brewer(palette=strsplit(input$colorpalettes," ")[[1]][1]) + scale_fill_brewer(palette=strsplit(input$colorpalettes," ")[[1]][1])
			}
		}
		if(!is.null(input$facet)) if(input$facet!="None/Force Pool") g <- g + facet_wrap(as.formula(paste("~",input$facet)), ncol=facet.cols)
		if(!is.null(input$altplot)){
			if(input$altplot){
				if(dat.sub()$Variable[1]=="Temperature"){
					g <- g +  geom_point(position=point.pos) + stat_summary(aes_string(group=input$group),fun.y=mean, geom="line")
				} else if(dat.sub()$Variable[1]=="Precipitation"){
					if(is.null(fill)){
						g <- g + stat_summary(data=dat.sub.collapsePooled(),aes_string(group=input$group),fun.y=mean, geom="bar", position=bar.pos)
					} else {
						g <- g + stat_summary(data=dat.sub.collapsePooled(),aes_string(group=input$group),fun.y=mean, geom="bar", position=bar.pos,colour="black")
					}
					if(!is.null(input$bardirection)) if(input$bardirection=="Horizontal bars") g <- g + coord_flip()
				}
			} else g <- g + geom_point(position=point.pos)
		} else g <- g + geom_point(position=point.pos)
		if(!is.null(input$yrange)) if(input$yrange) g <- g + stat_summary(aes_string(group=input$xtime), fun.y=mean, fun.ymin=min, fun.ymax=max, geom="errorbar", colour="black")
		if(!is.null(input$clbootbar)) if(input$clbootbar) g <- g + stat_summary(aes_string(group=input$xtime), fun.data="mean_cl_boot", geom="crossbar", colour="black")
		if(!is.null(input$clbootsmooth)){
			if(input$clbootsmooth){
				if(!is.null(pooled.var())){
					g <- g + stat_summary(data=dat.sub.collapsePooled(), fun.data="mean_cl_boot", geom="smooth")
				}
				g <- g + stat_summary(data=dat.sub.collapseGroups(), fun.data="mean_cl_boot", geom="smooth", colour="black", fill="black")
			}
		}
		if(show.logo){
			grid.bot <- arrangeGrob(textGrob(""), g, textGrob(""), ncol=3, widths=c(1/40,19/20,1/40))
			grid.top <- arrangeGrob(
				textGrob(""),
				textGrob(main, x=unit(0.075,"npc"), y=unit(0.5,"npc"), gp=gpar(fontsize=fontsize), just=c("left")),
				rasterGrob(logo.mat, x=unit(0.85,"npc"), y=unit(0.5,"npc"), just=c("right")),
				textGrob(""),
				widths=c(1/40,0.8,0.2,1/40), ncol=4)
			g <- grid.arrange(textGrob(""),grid.top,grid.bot,textGrob(""),heights=c(1/40,1/20,18/20,1/40),ncol=1)
		}
		print(g)
	} else plot(0,0,type="n",axes=F,xlab="",ylab="")
}
