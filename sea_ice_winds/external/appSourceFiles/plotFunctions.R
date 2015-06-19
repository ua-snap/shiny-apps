tsPlot <- function(x, w, i, yrs, decadal=F, v1name, v2name, cex1, mn, xlb, ylb, ...){
	clrs <- c("orange","dodgerblue")
	seq.dec <- yrs
	seq.yrs <- yrs[1]:(tail(yrs,1)+9)
	par(mar=c(4,5,4,1))
	if(!decadal){ # annual plot
		plot(x,w,type="l", ylim=c(0, 1.15), yaxs="i", lwd=4,col=clrs[1],cex.main=cex1,cex.lab=cex1,cex.axis=cex1,main=mn,xlab=xlb,ylab=ylb)
		lines(x,i,lwd=4,col=clrs[2])
		legend("topright", c(v1name,v2name), lwd=4, col=clrs, bty="n", horiz=T, seg.len=3, cex=cex1*0.75, pt.lwd=4)
	} else { # decadal plot
		xlabels <- paste0(seq.dec,"s")
		barplot(rbind(w,i), ylim=c(0, 1.15), yaxs="i", beside=T, col=clrs, legend=c(v1name,v2name), cex.main=cex1,cex.lab=cex1,cex.names=cex1,cex.axis=cex1,main=mn,xlab=xlb,ylab=ylb,axis.lty=1,
			args.legend=list(x="topright", bty="n", horiz=T, cex=cex1*0.75), ...)
        axis(1, at=seq(2, 3*length(xlabels), by=3), labels=xlabels,cex.axis=cex1,cex.lab=cex1)
		box()
	}
}
