tsPlot <- function(x,w,i,yrs,decadal=F,style="Lines",v1name,v2name,cex1,mn,xlb,ylb,...){
	clrs <- c("orange","dodgerblue")
	seq.dec <- seq(yrs[1],yrs[2],by=10)
	par(mar=c(4,5,4,1))
	if(style=="Lines"){
		plot(x,w,type="l",lwd=4,col=clrs[1],cex.main=cex1,cex.lab=cex1,cex.axis=cex1,main=mn,xlab=xlb,ylab=ylb,...)
		lines(x,i,lwd=4,col=clrs[2])
		if(decadal) axis(1,at=seq.dec,labels=paste0(seq.dec,"s"),cex.lab=cex1,cex.axis=cex1)
		par(xpd=TRUE)
		legend("topright",inset=c(0,-0.15),c(v1name,v2name),lwd=4,col=clrs,bty="n",horiz=T,seg.len=3,cex=cex1,pt.lwd=4)
	} else if(style=="Bars"){
		if(decadal) xlabels <- paste0(seq.dec,"s") else xlabels <- as.numeric(yrs[1]):(as.numeric(yrs[2])+9)
		par(xpd=TRUE)
		barplot(rbind(w,i),ylim=c(0,1),beside=T,col=clrs,legend=c(v1name,v2name),names.arg=xlabels,cex.main=cex1,cex.lab=cex1,cex.names=cex1,cex.axis=cex1,main=mn,xlab=xlb,ylab=ylb,axis.lty=1,
			args.legend=list(x="topright",inset=c(0,-0.15),bty="n",horiz=T,cex=cex1))
		box()
	}
}
