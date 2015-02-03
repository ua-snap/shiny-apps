tsPlot <- function(x, w, i, yrs, decadal=F, style="Lines", v1name, v2name, cex1, mn, xlb, ylb, ...){
	clrs <- c("orange","dodgerblue")
	seq.dec <- yrs
	seq.yrs <- yrs[1]:(tail(yrs,1)+9)
	par(mar=c(4,5,4,1))
	if(style=="Lines"){
		plot(x,w,type="l", ylim=c(0, 1.15), yaxs="i", lwd=4,col=clrs[1],cex.main=cex1,cex.lab=cex1,cex.axis=cex1,main=mn,xlab=xlb,ylab=ylb)
		lines(x,i,lwd=4,col=clrs[2])
		if(decadal) axis(1,at=seq.dec,labels=paste0(seq.dec,"s"),cex.lab=cex1,cex.axis=cex1)
		legend("topright", c(v1name,v2name), lwd=4, col=clrs, bty="n", horiz=T, seg.len=3, cex=cex1*0.75, pt.lwd=4)
	} else if(style=="Bars"){
		if(decadal) {
			plot.axes <- TRUE; xlabels <- paste0(seq.dec,"s")
		} else if(length(seq.yrs)<=20) {
			plot.axes <- FALSE; xlabels <- seq.yrs
		} else {
			plot.axes <- FALSE; xlabels <- seq.yrs[which(seq.yrs%%10==0)]
		}
		barplot(rbind(w,i), ylim=c(0, 1.15), yaxs="i", beside=T,col=clrs,legend=c(v1name,v2name),names.arg=xlabels,axes=plot.axes,axisnames=plot.axes,cex.main=cex1,cex.lab=cex1,cex.names=cex1,cex.axis=cex1,main=mn,xlab=xlb,ylab=ylb,axis.lty=1,
			args.legend=list(x="topright", bty="n", horiz=T, cex=cex1*0.75), ...)
		if(!decadal & length(seq.yrs)<=20) {
			axis(1,at=seq(2,3*(length(seq.yrs)-1/3),length=length(xlabels)),labels=xlabels,cex.axis=cex1,cex.lab=cex1,...)
		} else if (!decadal & length(seq.yrs)>20) {
			axis(1,at=seq(2,3*(length(seq.yrs)-9-1/3),length=length(xlabels)),labels=xlabels,cex.axis=cex1,cex.lab=cex1,...)
		}
		box()
	}
}
