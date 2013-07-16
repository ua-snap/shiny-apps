classErrorPlot <- function(class.error,confusion.melt,celltextsize,fontsize){
	fontsize <- as.numeric(fontsize)
	g1 <- ggplot(data=class.error,aes(x=Class,y=Error,group=Class,colour=Class,fill=Class)) +
	theme_grey(base_size=fontsize) + theme(legend.position="top", legend.key.width=unit(0.1/nlevels(class.error$Class),"npc")) +
	scale_fill_manual(values=c(clrs[1:(nlevels(class.error$Class))])) + scale_colour_manual(values=c(clrs[1:(nlevels(class.error$Class))])) +
	geom_bar(stat="identity")
	g2 <- ggplot(data=confusion.melt, aes(x = X, y = Y, fill = Count, label=Count)) + theme_grey(base_size=fontsize) + theme(legend.position="top", legend.key.width=unit(0.1,"npc")) +
		labs(x = "Predicted Class and Class Error", y = "Observed Class") +
		geom_raster() +
		scale_fill_gradient( low = "white", high = "purple4", na.value="black", name = "Count" ) +
		geom_text(size=celltextsize) +
		geom_rect(size=1, fill=NA, colour="black",
		   aes(xmin=length(levels(X))-0.5, xmax=length(levels(X))+0.5, ymin=1-0.5, ymax=length(levels(Y))+0.5)) +
		geom_rect(size=2, fill=NA, colour="black",
		   aes(xmin=1-0.5, xmax=length(levels(X))+0.5, ymin=1-0.5, ymax=length(levels(Y))+0.5)) +
		scale_x_discrete(expand = c(0, 0)) +
		scale_y_discrete(expand = c(0, 0))
	gA <- ggplot_gtable(ggplot_build(g1))
	gB <- ggplot_gtable(ggplot_build(g2))
	#leg1 <- with(gA$grobs[[8]], grobs[[1]]$widths[[4]])
	#leg2 <- with(gB$grobs[[8]], grobs[[1]]$widths[[4]])
	#gA$grobs[[8]] <- gtable_add_cols(gA$grobs[[8]], unit(-0.5*abs(diff(c(leg1, leg2))), "mm"))
	#gB$grobs[[8]] <- gtable_add_cols(gB$grobs[[8]], unit(0.5*abs(diff(c(leg1, leg2))), "mm"))
	gA$widths <- gB$widths
	grid.arrange(gA,gB,ncol=1)
}

importancePlot <- function(d,ylb,fontsize){
	fontsize <- as.numeric(fontsize)
	d <- d[order(d[,2]),]
	d$Predictor <- factor(as.character(d$Predictor),levels=rev(as.character(d$Predictor)))
	rownames(d) <- NULL
	abs.min <- abs(min(d[,2]))
	g1 <- ggplot(data=d,aes_string(x="Predictor",y=ylb,group="Predictor",colour="Predictor",fill="Predictor")) + geom_bar(stat="identity") + theme_grey(base_size=fontsize)
	if(ylb=="mda") g1 <- g1 + labs(y="Mean decrease in accuracy") else if(ylb=="mdg") g1 <- g1 + labs(y="Mean decrease in Gini")
	g1 <- g1 + theme(axis.text.x = element_text(angle=90,hjust=1,vjust=0.4)) + geom_hline(yintercept=abs.min,linetype="dashed",colour="black")
	print(g1)
}

impTablePlot <- function(importance.melt,lab,celltextsize,fontsize){
	fontsize <- as.numeric(fontsize)
	g1 <- ggplot(data=importance.melt, aes(x = X, y = Y, fill = Importance, label=Importance)) + theme_grey(base_size=fontsize) + theme(legend.position="top", legend.key.width=unit(0.1,"npc")) +
    labs(x = "Response class and mean performance measures", y = "Predictor") +
    geom_raster() +
	geom_text(size=celltextsize) +
	scale_fill_gradient( low = "white", high = "purple4", na.value="black", name = "Importance" ) +
	geom_rect(size=1, fill=NA, colour="black",
       aes(xmin=length(levels(X))-1-0.5, xmax=length(levels(X))-1+0.5, ymin=1-0.5, ymax=length(levels(Y))+0.5)) +
	geom_rect(size=2, fill=NA, colour="black",
       aes(xmin=1-0.5, xmax=length(levels(X))+0.5, ymin=1-0.5, ymax=length(levels(Y))+0.5)) +
    scale_x_discrete(expand = c(0, 0),labels=lab) +
    scale_y_discrete(expand = c(0, 0)) +
	theme(axis.text.x = element_text(angle=90,hjust=1,vjust=0.4))
	print(g1)
}

mdsPlot <- function(d,fontsize){
	fontsize <- as.numeric(fontsize)
	g1 <- ggplot(data=d,aes_string(x=names(d)[1],y=names(d)[2],group=names(d)[3],colour=names(d)[3])) + theme_grey(base_size=fontsize) + theme(legend.position="top") +
	scale_fill_manual(values=c(clrs[1:(nlevels(d[,3]))])) + scale_colour_manual(values=c(clrs[1:(nlevels(d[,3]))])) +
	geom_point(size=3)
	print(g1)
}

marginPlot <- function(d,extrema,clrs,celltextsize,fontsize){
	fontsize <- as.numeric(fontsize)
	g1 <- ggplot(data=d,aes_string(x=names(d)[3],y='Margin',group=names(d)[3],colour=names(d)[3])) + theme_grey(base_size=fontsize) +  theme(legend.position="top") +
	scale_fill_manual(values=c(clrs[1:(nlevels(d[,3]))])) + scale_colour_manual(values=c(clrs[1:(nlevels(d[,3]))])) +
	geom_line() + geom_hline(yintercept=0,linetype="dashed",colour="black") +
	geom_point(size=3, position = position_jitter(width=0.1)) +
	labs(y="Classification Margin") + 
	geom_text(data=extrema,aes_string(label=names(extrema)[1]),colour="black",size=celltextsize,hjust=-0.1,vjust=0)
	print(g1)
}

pdPlot <- function(pd,clrs,fontsize){
	fontsize <- as.numeric(fontsize)
	ylb <- names(pd)[2]
	names(pd)[2] <- gsub(" ","",names(pd)[2])
	if(is.numeric(pd[,1])){
		g1 <- ggplot(data=pd,aes_string(x=names(pd)[1],y=names(pd)[2])) + theme_grey(base_size=fontsize)
		g1 <- g1 + #scale_colour_gradient2( low = "orange4", mid="white", high = "purple4") +
		theme(legend.position="top", legend.key.width=unit(0.1,"npc")) +
		#geom_line(aes_string(colour=names(pd)[2]),size=1.5)
		geom_line(colour="black",size=1.5)
	} else {
		g1 <- ggplot(data=pd,aes_string(x=names(pd)[1],y=names(pd)[2],colour=names(pd)[1],fill=names(pd)[1],order=names(pd)[1])) + theme_grey(base_size=fontsize)
		g1 <- g1 + theme(legend.position="top") + geom_bar(stat="identity") +
		scale_fill_manual(values=c(clrs[1:(nlevels(pd[,1]))])) + scale_colour_manual(values=c(clrs[1:(nlevels(pd[,1]))])) +
		labs(y=ylb) +
		theme(axis.text.x = element_text(angle=90,hjust=1,vjust=0.4))
	}
	print(g1)
}

outlierPlot <- function(d,n,clrs,celltextsize,fontsize){
	fontsize <- as.numeric(fontsize)
	out.ind <- head(rev(order(abs(d$Outliers))),n)
	extreme.outliers <- d[out.ind,c(5,7)]
	g1 <- ggplot(data=d,aes(x=Country,y=Outliers,group=Country,fill=Outliers,order=Country)) + theme_grey(base_size=fontsize) + theme(legend.position="top", legend.key.width=unit(0.1,"npc")) +
	geom_bar(stat="identity",position="dodge") +
	scale_fill_gradient2(low="purple", mid="white", high="purple") +
	geom_hline(yintercept=0,linetype="dashed",colour="black") +
	theme(axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
	geom_text(data=extreme.outliers,aes(label=Country),colour="black",size=celltextsize,hjust=-0.1,vjust=0)
	print(g1)
}

errorRatePlot <- function(err,clrs,fontsize){
	fontsize <- as.numeric(fontsize)
	errors.dat <- cbind(1:nrow(err),melt(data.frame(err)))
	names(errors.dat) <- c("Trees","Type","Error")
	errors.dat$Type <- factor(errors.dat$Type,levels(errors.dat$Type)[c(2:nlevels(errors.dat$Type),1)])
	g1 <- ggplot(data=errors.dat,aes(x=Trees,y=Error,colour=Type,group=Type,order=Type)) + theme_grey(base_size=fontsize) + theme(legend.position="top") +
	scale_colour_manual(values=c(clrs[1:(nlevels(errors.dat$Type)-1)],"#000000")) +
	geom_line(size=1) +	labs(y="Error Rate")
	print(g1)
}

varsUsedPlot <- function(d,rf1,fontsize){
	fontsize <- as.numeric(fontsize)
	varsUsed.dat <- data.frame(Predictor=factor(names(d),levels=names(d)[rev(order(varUsed(rf1())))]),Times=varUsed(rf1()))
	g1 <- ggplot(data=varsUsed.dat,aes(x=Predictor,y=Times,fill=Predictor,colour=Predictor,group=Predictor)) + theme_grey(base_size=fontsize) +
	geom_bar(stat="identity") +
	labs(y="Total times used for splitting across all trees") +
	theme(axis.text.x = element_text(angle=90,hjust=1,vjust=0.4))
	print(g1)
}
	
numVarPlot <- function(d,fontsize){
	fontsize <- as.numeric(fontsize)
	g1 <- ggplot(data=d,aes(x=NV,y=CV.error,colour=Replicate,group=Replicate)) + theme_grey(base_size=fontsize) + theme(legend.position="top") +
		scale_colour_manual(values=c(clrs[1:(nlevels(d$Replicate)-1)],"#000000")) +
		geom_line(size=1) +
		labs(x="Number of Predictors",y="CV Error")
	print(g1)
}
