dailyPlot <- function(d,file=NULL,mo1=7,cex.exp=1,xaxis.day=15,dates,main.title="Plot",xlb="x-axis",colpalvec=c("orange","purple"),num.colors=20,alpha=50,
					   col.ax.lab="black", col.totals="gray", logo=F, logofile=NULL,
					   tformSize=function(x) log(x+1), tformCol=function(x) log(x+1), tformColBar=function(x) log(x+1), tformColMar=function(x) log(x+1),
					   bg.plot="white", bars=F, bar.means=F, marginal=F, loess.span=0.50, cex.master=1.3,...){
	
	# setup: the year cycle (start and end dates)
	yrs <- unique(d$Year)
	mo1 <- mo1-6 # Month 1 changes meaning from year start date to six months earlier for centering start date on plot
	if(mo1<1) mo1 <- mo1 + 12
	if(mo1<=6) { n1 <- which(dates$Month==mo1+6)[1] - which(dates$Month==mo1)[1]; n2 <- 365-n1 }
	if(mo1>=7) { n2 <- which(dates$Month==mo1)[1] - which(dates$Month==mo1-6)[1]; n1 <- 365-n2 }
	if(mo1!=1){
		day1 <- with(dates,which(Month==mo1 & Day==1)) # Cycle required to begin on first of a month
		dates <- dates[c(day1:365,1:(day1-1)),] # reorder dates by new cycle
		yrs.p <- c(paste(yrs-1,yrs,sep="-"),paste(tail(yrs,1),tail(yrs,1)+1,sep="-")) # rename years
		n <- length(yrs.p)
		n.end.yr.avail <- min(length(which(d$Year==tail(yrs,1))),365) # these lines make a new year name vector based on existing time series
		yrs.new <- c(rep(yrs.p[1],day1-1),rep(yrs.p[2:(n-2)],each=365),rep(yrs.p[n-1],365-day1+1+min(n.end.yr.avail,day1-1)))
		if(n.end.yr.avail > day1-1) yrs.new <- c(yrs.new, rep(tail(yrs.p,1),n.end.yr.avail-day1+1)) else yrs.p <- yrs.p[-length(yrs.p)]
	}
	# seteup: colors based on values, force 365-day years in dataframe, overwrite old year info based on given year definition
	pal <- colorRampPalette(colpalvec)
	clrs.all <- paste0(pal(num.colors)[as.numeric(cut(tformCol(d$P_in),breaks=num.colors))],alpha)
	clrs.vec <- c()
	drp.vec <- n.v <- c()
	for(i in 1:length(yrs)){
		v <- d$P_in[d$Year==yrs[i]]
		clrs <- clrs.all[d$Year==yrs[i]]
		drp <- which.min(abs(which(v==0)-60))
		n.v <- c(n.v,length(v))
		if(n.v[i]==366) { v <- v[-drp]; clrs <- clrs[-drp] }
		clrs.vec <- c(clrs.vec,clrs)
		if(i==1 & n.v[i]==366) drp.vec <- drp else if(i>1 & n.v[i]==366) drp.vec <- c(drp.vec,drp+sum(n.v[1:(i-1)]))
	}
	d <- d[-drp.vec,]
	if(mo1!=1){ d$Year <- yrs.new; yrs <- yrs.p }
	d$clrs <- clrs.vec
	yrs.n <- length(yrs)
	clrs.list <- v.list <- list()
	for(i in 1:length(yrs)){
		v <- d$P_in[d$Year==yrs[i]]
		clrs <- d$clrs[d$Year==yrs[i]]
		v.list[[i]] <- v
		clrs.list[[i]] <- clrs
	}
	
	# Plot: Complete setup, open PNG device, create plotting regions, margins, title, axes, background lines
	x.at <- which(d$Day[d$Year==yrs[2]]==xaxis.day) # Using 2nd year guarantees full 365-day cycle
	if(mo1==1) mo.ind <- 1:12 else mo.ind <- c(mo1:12,1:(mo1-1))
	x.labels <- paste(month.abb,xaxis.day)[mo.ind]
	max.pix <- 3000
	ht <- min((1/3)*max.pix+(yrs.n/16)*(2/3)*max.pix, max.pix)
	if(!is.null(file)) png(file,width=max.pix,height=ht,res=300)
	par(bg=bg.plot)
	if(bars & marginal){
		layout(matrix(c(1,1,2,3,4,5),3,2,byrow=T),width=c(4,1),height=c(1,3,yrs.n))
	} else if(bars & !marginal){
		layout(matrix(c(1,1,2,3),2,2,byrow=T),width=c(4,1),height=c(1,yrs.n))
	} else if(marginal){
		layout(matrix(1:3,nrow=3),height=c(1,3,yrs.n))
	} else {
		layout(matrix(1:2,nrow=2),height=c(1,yrs.n))
	}
	par(mar=c(0,0,0,0))
	plot.new()
	legend("center",main.title,bty="n",text.col=col.ax.lab,cex=1.7)
	
	# Plot: smoothed marginal seasonal signal (optional) and bar means (optional)
	if(marginal){
		x <- 1:365
		ind <- which(tapply(d$Year,d$Year,length)==365) # use only complete 365-day seasonal cycles for marginal TS density
		y <- tapply(d$P_in[d$Year %in% names(ind)], rep(1:365,length(ind)),mean)
		lo <- loess(y~x,span=loess.span)
		clrs.margin <- paste0(pal(num.colors)[as.numeric(cut(tformColMar(y),breaks=num.colors))],alpha)
		par(mar=c(0.2,7,0,2),mgp = c(4,1,0))
		plot(x,y,xlim=c(1,365),pch=21,col=col.ax.lab,bg=clrs.margin,cex=cex.master,axes=F,ylab=expression("Historical mean"~('in')~""),col.lab=col.ax.lab,cex.lab=cex.master)
		axis(2,col=col.ax.lab,...)
		par(mgp = c(3,1,0))
		lines(predict(lo),lwd=3,col=col.ax.lab)
		if(bars){ # Must compile bars data early since bar totals must be plotted first in an earlier layout panel
			v.bars.list <- list()
			for(i in 1:yrs.n){
				v <- v.list[[i]]
				n <- length(v)
				if(length(v)==365){
					v <- c(-sum(v[1:n1]),sum(v[n2:n]))
				} else if(i==1 & n<=n2) {
					v <- c(0,sum(v))
				} else if(i==1 & n>n2) {
					v <- c(-sum(head(v,n-n2)),sum(tail(v,n2)))
				} else if(i==yrs.n & n<=n1) {
					v <- c(-sum(v),0)
				} else if(i==yrs.n & n>n1) {
					v <- c(-sum(v[1:n1]),sum(tail(v,n-n1)))
				}
				v.bars.list[[i]] <- v
			}
			clrs.all <- matrix(paste0(pal(num.colors)[as.numeric(cut(tformColBar(abs(unlist(v.bars.list))),breaks=num.colors))],alpha),nrow=2)
			if(!bar.means){ # if bars==TRUE, must leave a blank plotting region to the right, above the bars, before proceeding, unless also plotting bar means
				plot.new()
			} else {
				means <- abs(rowMeans(do.call(cbind,v.bars.list)))
				clrs.means <- paste0(pal(num.colors)[as.numeric(cut(tformColBar(c(means,abs(unlist(v.bars.list)))),breaks=num.colors))],alpha)[1:2]
				bp <- barplot(means,col=clrs.means,border=NA,axes=F,ylab=expression("Mean 6-month totals"~('in')~""),col.lab=col.ax.lab,cex.lab=cex.master)
				text(bp,max(means)/20,labels=c(expression(italic("before")),expression(italic("after"))),col=col.totals,pos=4,srt=90,cex=cex.master)
				axis(2,col=col.ax.lab,...)
			}
		}
	}
	
	par(mar=c(5,7,0,2))
	plot(0, 0, xlim=c(1,365), ylim=c(1,yrs.n), type="n",axes=F,xlab=xlb,main="",...)
	axis(1,at=x.at,labels=x.labels,col=col.ax.lab,...)
	axis(2,at=1:yrs.n,labels=gsub("-"," -\n",as.character(yrs)),col=col.ax.lab,...)
	abline(h=1:yrs.n,lty=1,col="gray")
	abline(v=x.at,lty=2,col="gray")
	if(mo1!=1) arrows(x0=365-day1,y0=1-0.4,y1=1+0.4,length=0.125,angle=90,code=3,col=col.ax.lab,lwd=3)
	arrows(x0=length(d$Year[d$Year==tail(yrs,1)]),y0=yrs.n-0.4,y1=yrs.n+0.4,length=0.125,angle=90,code=3,col=col.ax.lab,lwd=3)

	# Plot: add points for each year
	for(i in 1:yrs.n){
		v <- v.list[[i]]
		if(length(v)==365) x <- 1:365 else if(i==1) x <- rev(365+1-seq(length=length(v))) else if(i==yrs.n) x <- 1:length(v)
		points(x, rep((1:yrs.n)[i],length(v)), col=col.ax.lab, bg=clrs.list[[i]], cex=cex.exp*tformSize(v),...)
	}
	box(col=col.ax.lab)
	
	# Plot: add floating bars comparing half-year totals (optional)
	if(bars){
		par(mar=c(5,0,0,2))
		plot(0, 0, xlim=range(v.bars.list), ylim=c(1,yrs.n), type="n",axes=F,xlab="",main="",...)
		for(i in 1:yrs.n){
			v <- v.bars.list[[i]]
			rect(v[1], (1:yrs.n)[i]-0.25, 0, (1:yrs.n)[i]+0.25, col=clrs.all[1,i],border=NA,...) # floating bars are made using rect(), not barplot()
			rect(0, (1:yrs.n)[i]-0.25, v[2], (1:yrs.n)[i]+0.25, col=clrs.all[2,i],border=NA,...)
			abline(v=0,col=col.ax.lab)
			text(0,(1:yrs.n)[i],labels=paste(abs(v[1]),"in"),pos=2,col=col.totals,cex=cex.master)
			text(0,(1:yrs.n)[i],labels=paste(v[2],"in"),pos=4,col=col.totals,cex=cex.master)
		}
		par(xpd=T)
		text(0,(1:yrs.n)[1]-0.5,expression(italic("before")),pos=2,col=col.totals,cex=cex.master)
		text(0,(1:yrs.n)[1]-0.5,expression(italic("after")),pos=4,col=col.totals,cex=cex.master)
		text(0,(1:yrs.n)[1]-0.75,paste(as.numeric(dates[n1+1,]),sep="",collapse="/"),col=col.totals,cex=cex.master)
	}
	
	# Plot: Add a logo to bottom right of plot
	if(logo) { 
		require(png)
		require(grid)
		p <- readPNG(logofile)
		if(is.null(file)) p <- rasterGrob(image=p,x=unit(0.925,"npc"),y=unit(0.025,"npc"),width=unit(.26/2,"npc"),height=unit(.1/2,"npc")) # hardcoded size/position for specific logo
		if(!is.null(file)) p <- rasterGrob(image=p,x=unit(0.925,"npc"),y=unit(0.025,"npc"),width=unit(.26/2,"npc"),height=unit((max.pix/ht)*.1/2,"npc")) # hardcoded size/position for specific logo
		par(mar=c(2,2,2,2))
		grid.draw(p)
	}
	if(!is.null(file)) dev.off()
}
