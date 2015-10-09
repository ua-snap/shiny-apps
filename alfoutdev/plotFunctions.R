# @knitr plotFRPbyBuffer
# plot FRP ~ buffer radius, grouped/colored by modeled vs. observed
plotFRPbyBuffer <- function(data, min.buffer, colpal, subject, grp="", fontsize=16, leg.pos="top", maintitle="", xlb="", ylb="", facet.by=NULL, facet.cols=1, facet.scales=NULL){
	d <- filter(data.table(data), Buffer_km >= as.numeric(min.buffer))
	g <- ggplot(d, aes_string(x="Buffer_km", y="FRP", group=subject, colour="Source")) +
		scale_color_manual(values=colpal) + scale_fill_manual(values=colpal)
	if(grp!=""){
		g <- g + geom_line(data=filter(d, Source=="Modeled"), colour="gray")
		g <- g + geom_line(aes_string(group=grp, colour=grp), data=filter(d, Source=="Observed"), size=1) +
			scale_color_manual(values=colpal[-c(1,2)]) + scale_fill_manual(values=colpal[-c(1,2)])
	} else g <- g + geom_line() + geom_line(data=filter(d, Source=="Observed"), size=1)
	g <- g + theme_bw(base_size=fontsize) + theme(legend.position=tolower(lgd.pos)) +
		ggtitle(bquote(paste(.(maintitle) >= .(paste(min.buffer,"km"))))) + xlab(xlb) + ylab(ylb)
	if(!is.null(facet.by)){
        string <- if(length(facet.by)==1) paste("~", facet.by) else paste(facet.by[1], "~", facet.by[2])
        g <- g + facet_wrap(as.formula(string), ncol=as.numeric(facet.cols), scales=facet.scales)
    }
	print(g)
}

# @knitr plotRABbyTime
# plot time series of cumulative or non-cumulative annual relative area burned for a given buffer size
plotRABbyTime <- function(data, buffersize, year.range, cumulative=F, subject, grp="", colpal, fontsize=16, lgd.pos="top", facet.by=NULL, facet.cols=1, facet.scales=NULL, ...){
    d <- data.table(data)
	d <- filter(d, Buffer_km %in% as.numeric(buffersize) & Year >= year.range[1] & Year <= year.range[2])
	xlb="Year"
	if(cumulative){
        d %>% group_by(Replicate, Buffer_km, Location) %>% mutate(Value=cumsum(Value)) -> d
		maintitle <- paste(year.range[1], "-", year.range[2], "Cumulative Relative Area Burned ~ Time | Buffer")
		ylb <- "CRAB (%)"
	} else {
		maintitle <- paste(year.range[1], "-", year.range[2], "Relative Area Burned ~ Time | Buffer")
		ylb <- "RAB (%)"
	}
	g <- ggplot(d, aes_string(x="Year", y="Value", group=subject, colour="Source"))
	if(cumulative){
		if(grp!=""){
			g <- g + geom_step(data=filter(d, Source=="Modeled"), colour="gray")
			g <- g + geom_step(aes_string(group=grp, colour=grp), data=filter(d, Source=="Observed"), size=1) +
				scale_color_manual(values=colpal[-c(1,2)]) + scale_fill_manual(values=colpal[-c(1,2)])
		} else g <- g + geom_step() + geom_step(data=filter(d, Source=="Observed"), size=1) + scale_color_manual(values=colpal) + scale_fill_manual(values=colpal)
	} else {
		if(grp!=""){
			g <- g + geom_point(data=filter(d, Source=="Modeled"), colour="gray")
			g <- g + geom_point(aes_string(group=grp, colour=grp), data=filter(d, Source=="Observed"), size=2.5) +
				scale_color_manual(values=colpal[-c(1,2)]) + scale_fill_manual(values=colpal[-c(1,2)])
		} else g <- g + geom_point() + geom_point(data=filter(d, Source=="Observed"), size=2.5) + scale_color_manual(values=colpal) + scale_fill_manual(values=colpal)
	}
	g <- g + theme_bw(base_size=fontsize) + theme(legend.position=tolower(lgd.pos)) + ggtitle(bquote(paste(.(maintitle) == .(paste(buffersize,"km"))))) + xlab(xlb) + ylab(ylb)
	if(!is.null(facet.by)){
        string <- if(length(facet.by)==1) paste("~", facet.by) else paste(facet.by[1], "~", facet.by[2])
        g <- g + facet_wrap(as.formula(string), ncol=as.numeric(facet.cols), scales=facet.scales)
    }
	print(g)
}

# @knitr plotRegionalTABbyTime
# plot time series of regional cumulative or non-cumulative annual total area burned for a given vegetation class or collection of vegetation classes
plotRegionalTABbyTime <- function(data, vegetation, agg.veg=F, year.range, cumulative=F, subject, grp="", colpal, fontsize=16, lgd.pos="top", facet.by=NULL, facet.cols=1, facet.scales=NULL, ...){
    d <- data.table(filter(data, Vegetation %in% vegetation & Year >= year.range[1] & Year <= year.range[2]))
    if(agg.veg) {
        d[, Vegetation:=NULL]
        d <- group_by(d, Source, Replicate, Year)
        given.veg <- ""
    } else {
        d <- group_by(d, Source, Replicate, Vegetation, Year)
        given.veg <- "| Vegetation"
    }
	xlb="Year"
	if(cumulative){
		d %>% summarise(Value=sum(FS)) %>% mutate(Value=cumsum(Value)) -> d
		maintitle <- paste(year.range[1], "-", year.range[2], "Regional Cumulative Total Area Burned ~ Time", given.veg)
		ylb <- expression("CTAB ("~km^2~")")
	} else {
        d <- summarise(d, Value=sum(FS))
		maintitle <- paste(year.range[1], "-", year.range[2], "Regional Total Area Burned ~ Time", given.veg)
		ylb <- expression("TAB ("~km^2~")")
	}
    print(head(d))
    print(subject)
    print(grp)
	g <- ggplot(d, aes_string(x="Year", y="Value", group=subject, colour="Source"))
	if(cumulative){
		if(grp!=""){
			g <- g + geom_step(data=filter(d, Source=="Modeled"), colour="gray")
			g <- g + geom_step(aes_string(colour=grp), data=filter(d, Source=="Observed"), size=1) +
				scale_color_manual(values=colpal[-c(1,2)]) + scale_fill_manual(values=colpal[-c(1,2)])
		} else g <- g + geom_step() + geom_step(data=filter(d, Source=="Observed"), size=1) + scale_color_manual(values=colpal) + scale_fill_manual(values=colpal)
	} else {
		if(grp!=""){
			g <- g + geom_point(data=filter(d, Source=="Modeled"), colour="gray")
			g <- g + geom_point(aes_string(colour=grp), data=filter(d, Source=="Observed"), size=2.5) +
				scale_color_manual(values=colpal[-c(1,2)]) + scale_fill_manual(values=colpal[-c(1,2)])
		} else g <- g + geom_point() + geom_point(data=filter(d, Source=="Observed"), size=2.5) + scale_color_manual(values=colpal) + scale_fill_manual(values=colpal)
	}
    if(agg.veg | length(vegetation) > 1) ttl <- maintitle else ttl <- bquote(paste(.(maintitle) == .(vegetation)))
	g <- g + theme_bw(base_size=fontsize) + theme(legend.position=tolower(lgd.pos)) + ggtitle(ttl) + xlab(xlb) + ylab(ylb)
	if(!is.null(facet.by)){
        string <- if(length(facet.by)==1) paste("~", facet.by) else paste(facet.by[1], "~", facet.by[2])
        g <- g + facet_wrap(as.formula(string), ncol=as.numeric(facet.cols), scales=facet.scales)
    }
	print(g)
}

# @knitr plotFRIboxplot
# plot boxplots of fire return intervals for given buffer sizes, locations, replicates, source data
plotFRIboxplot <- function(d, x, y, grp=NULL, Log=FALSE, colpal, ylim=NULL, show.points=TRUE, show.outliers=FALSE, pts.alpha=1, fontsize=16, leg.pos="top", facet.by=NULL, facet.cols=1, facet.scales=NULL, lgd.pos="top"){
	d$Buffer_km <- factor(d$Buffer_km)
	if(Log) { d$FRI <- log(d$FRI + 1); units <- "Log(Years)" } else units <- "(Years)"
	dodge <- position_dodge(width = 0.9)
	if(is.null(pts.alpha)) pts.alpha <- 1
	if(!length(grp) || grp=="") grp <- 1
	if(is.character(grp)){
		if(grp!="Source") colpal <- colpal[-c(1:2)] # Only used black and gray when coloring observed vs. modeled
		n.grp <- length(unique(d[,grp]))
	} else n.grp <- 1
	x.n <- length(unique(d[,x]))
	if(is.character(grp) & n.grp>1){
		if(is.null(facet.by)) {
			x.names <- sort(unique(as.character(d[,x])))
			x.num <- grp.n <- grp.num <- rep(NA, nrow(d))
			for(m in 1:length(x.names)){
				ind <- which(as.character(d[,x])==x.names[m])
				grp.n[ind] <- length(unique(d[ind, grp]))
				x.num[ind] <- m
				grp.num[ind] <- 0.9*( (as.numeric(factor(d[ind ,grp]))/grp.n[ind])-(1/grp.n[ind] + ((grp.n[ind]-1)/2)/(grp.n[ind])) )
			}
			d$xdodge <- x.num + grp.num
		} else {
			x.names <- sort(unique(as.character(d[,x])))
			panel.names <- unique(as.character(d[,facet.by]))
			n.panels <- length(panel.names)
			x.num <- grp.n <- grp.num <- rep(NA, nrow(d))
			for(m in 1:n.panels){
				for(mm in 1:length(x.names)){
					ind <- which(as.character(d[,facet.by])==panel.names[m] & as.character(d[,x])==x.names[mm])
					grp.n[ind] <- length(unique(d[ind, grp]))
					x.num[ind] <- mm - 1 + as.numeric(factor(d[ind, x]))
					grp.num[ind] <- 0.9*( (as.numeric(factor(d[ind ,grp]))/grp.n[ind])-(1/grp.n[ind] + ((grp.n[ind]-1)/2)/(grp.n[ind])) )
				}
			}
			d$xdodge <- x.num + grp.num
		}
		xdodge <- "xdodge"
	}
	
	xlb=x
	maintitle <- "Fire Return Interval Distributions"
	ylb <- paste("Fire Return Interval", units)
    outlier.col <- if(show.outliers) "black" else NA
	if(grp==1) basic.fill.clr <- NULL else basic.fill.clr <- grp
	g <- ggplot(d, aes_string(x=x, y=y, colour=basic.fill.clr)) + scale_color_manual(values=colpal) + scale_fill_manual(values=colpal)
	g <- g + geom_boxplot(fill="white", outlier.colour=outlier.col, position=dodge)
	if(show.points){
		if(is.character(grp) & n.grp>1){
			g <- g + geom_point(aes_string(x=xdodge, fill=basic.fill.clr), pch=21, size=1, colour="black", alpha=pts.alpha, position=position_jitter(width=0.9/(x.n*grp.n)))
		} else {
			g <- g + geom_point(aes_string(fill=basic.fill.clr), pch=21, size=1, colour="black", fill="red", alpha=pts.alpha, position=position_jitter(width=0.9/x.n))
		}
	}
	g <- g + theme_bw(base_size=fontsize) + theme(legend.position=lgd.pos) + xlab(xlb) + ylab(ylb) + ylim(ylim)
	if(!is.null(facet.by)){
        string <- if(length(facet.by)==1) paste("~", facet.by) else paste(facet.by[1], "~", facet.by[2])
        g <- g + facet_wrap(as.formula(string), ncol=as.numeric(facet.cols), scales=facet.scales)
    }
	print(g)
}
