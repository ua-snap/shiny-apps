plotFun <- function(m,file=NULL, colpal){
	# setup
	brks <- seq(-1.05,1.05,length.out=length(colpal)+1)
	zlm <- range(brks)
	yrs <- as.numeric(rownames(m))
	x.scale <- (yrs-min(yrs))/(length(yrs)-1)
	lab <- seq(yrs[1],tail(yrs,1), by=10); lab <- lab + which(yrs%%10==0)[1] - 1
	if(length(lab)<5) { lab <- seq(yrs[1],tail(yrs,1), by=5); lab <- lab + which(yrs%%5==0)[1] - 1 }
	ind <- match(lab, yrs)
	binwidth <- diff(brks)[1]
	x <- seq(zlm[1]+binwidth/2, zlm[2]-binwidth/2, by=binwidth)
	
	cex.axis1 <- 2.8; cex.axis2 <- 3.2; cex.axis3 <- 2.3
	cex.lab1 <- cex.main1 <- 3.0
	
	if(!is.null(file)){
		png(file, height=2700, width=3700, res=200)
		cex.axis1 <- 3.3; cex.axis2 <- 3.7; cex.axis3 <- 2.8
		cex.lab1 <- cex.main1 <- 4.0
	}
	layout(matrix(c(1,2,nrow=2)),height=c(24,1))
	par(mar=c(11,14,5,10)+0.1, mgp=c(4,1.3,0))
	
	# primary plotting region
	image(m, col=colpal, axes=FALSE, breaks=brks, zlim=zlm) 
	axis(2, at=seq(0,1, length=length(colnames(m))), labels=colnames(m), las=1, cex.axis=cex.axis1, tck=-0.01)  
	axis(1, at=x.scale, labels=FALSE, tck=-0.005)
	par(mgp=c(4,2.6,0))
	axis(1, at=x.scale[ind], labels=lab, cex.axis=cex.axis2, tck=-0.01)
	abline(h=0.5) 
	title(ylab="Monthly climatic variable", cex.lab=cex.lab1, line=10.8) 
	title(xlab="Last year of interval", cex.lab=cex.lab1, line=6.9) 
	box() 
	title(main="Moving average intervals: Correlation values", cex.main=cex.main1) 

	# legend
	op <- par(mar=c(4,7,0,2)+0.1)
	image(x,1,t(matrix(x,1,length(x))),axes=F,xlab="", ylab="",col=colpal)
	box()
	par(mgp=c(4,2,0)) 
	axis(1, at=seq(-1,1,by=0.1), labels=round(seq(-1,1,by=0.1),2), cex.axis=cex.axis3)
	par(op) 
	if(!is.null(file)) dev.off() 
}
