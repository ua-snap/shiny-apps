library(shiny)
library(datasets)
rt2 <- function(n=500,dft=15){ rt(n=n,df=dft) }
formals(rgamma)[1:2] <- c(500,1)
rchisq2 <- function(n=500,dfx=1){ rchisq(n=n,df=dfx) }
formals(rf)[1:3] <- c(500,1,15)
rexp2 <- function(n=500,rate2=1){ rexp(n=n,rate=rate2) }
formals(rbeta)[1:3] <- c(500,2,2)
expr.norm <- expression(italic(paste(displaystyle(f(x)~"="~frac(1,sqrt(2*pi*sigma^scriptscriptstyle("2")))~e^{frac(-1,2*sigma^{scriptscriptstyle("2")})*(x-mu)^scriptscriptstyle("2")})
					~~~~displaystyle(list(paste(-infinity<x) <infinity, paste(-infinity<mu) <infinity, paste(0<sigma^scriptscriptstyle("2")) <infinity))
					)))
expr.unif <- expression(italic(paste(displaystyle(f(x)~"="~frac(1,b-a)
					~~~~displaystyle(paste(-infinity<paste(a<=paste(x<=b))) <infinity))
					)))
expr.t <- expression(italic(paste(displaystyle(f(x)~"="~frac(Gamma~bgroup("(",frac(nu+1,2),")"),sqrt(nu*pi)~Gamma~bgroup("(",frac(nu,2),")"))~bgroup("(",1+frac(x^2,nu),")")^{-frac(nu+1,2)})
					~~~~displaystyle(list(paste(-infinity<x) <infinity, nu > 0))
					)))
expr.F <- expression(italic(paste(displaystyle(f(x)~"="~frac(Gamma~bgroup("(",frac(nu[1]+nu[2],2),")"),Gamma~bgroup("(",frac(nu[1],2),")")~Gamma~bgroup("(",frac(nu[2],2),")"))
					~bgroup("(",frac(nu[1],nu[2]),")")^{frac(nu[1],2)}~frac(x^{frac(nu[1],2)-1},bgroup("(",1+frac(d[1],d[2])*x,")")^{frac(d[1]+d[2],2)}))
					~~~~displaystyle(paste(0<=x) <infinity~and~list(d[1],d[2]) > 0)
					)))
expr.gam <- expression(italic(paste(displaystyle(f(x)~"="~frac(beta^alpha,Gamma(alpha))*x^{alpha-1}*e^{-beta*x})
					~~~~displaystyle(list(paste(0<x) <infinity, paste(0<alpha) <infinity, paste(0<beta) <infinity))
					)))
expr.exp <- expression(italic(paste(displaystyle(f(x)~"="~lambda*e^{-lambda*x})
					~~~~displaystyle(list(paste(0<=x) <infinity,lambda>0))
					)))
expr.chisq <- expression(italic(paste(frac(1,2^{frac(nu,2)}*Gamma~bgroup("(",frac(nu,2),")"))*x^{frac(nu,2)-1}*e^{-frac(x,2)}
					~~~~displaystyle(list(paste(0<=x) <infinity, nu %in% bold(N)))
					)))
expr.lnorm <- expression(italic(paste(displaystyle(f(x)~"="~frac(1,x*sigma*sqrt(2*pi))~e^{-frac((log(x)-mu)^2,2*sigma^2)})
					~~~~displaystyle(list(paste(0<x) <infinity, paste(-infinity<log(mu)) <infinity, paste(0<sigma^scriptscriptstyle("2")) <infinity))
					)))
expr.beta <- expression(italic(paste(displaystyle(f(x)~"="~frac(Gamma(alpha+beta),Gamma(alpha)*Gamma(beta))*x^{alpha-1}*(1-x)^{beta-1})
					~~~~displaystyle(list(paste(0<=x) <=1, paste(0<alpha) <infinity, paste(0<beta) <infinity))
					)))
					
#plot(0,0,type="n")
#text(0,0,expr.F,cex=.7)



shinyServer(function(input,output){
	dat <- reactive({
		dist <- switch(input$dist,
			norm=rnorm,	unif=runif,	t=rt2, F=rf, gam=rgamma, exp=rexp2,	chisq=rchisq2, lnorm=rlnorm, beta=rbeta)

		def.args <- switch(input$dist,
			norm=c(input$mean,input$sd), unif=c(input$min,input$max), t=c(input$dft), F=c(input$df1,input$df2),
			gam=c(input$shape,input$rate), exp=c(input$rate2), chisq=c(input$dfx), lnorm=c(input$meanlog,input$sdlog), beta=c(input$shape1,input$shape2))
			
		f <- formals(dist);	f <- f[names(f)!="n"]; len <- min(length(f),3-1); f <- f[1:len]
		argList <- list(n=input$n)
		for(i in 1:len) argList[[names(f)[i]]] <- def.args[i]
		return(list(do.call(dist,argList),names(f)))
	})

	output$dist1 <- renderUI({
		lab <- switch(input$dist,
			norm="Mean:", unif="Minimum:", t="Degrees of freedom:", F="Numerator degrees of freedom:", gam="Shape:", exp="Rate:",
			chisq="Degrees of freedom:", lnorm="Mean(log):", beta="Alpha:")
		ini <- switch(input$dist,
			norm=0, unif=0, t=15, F=1, gam=1, exp=1, chisq=1, lnorm=0, beta=2)
		numericInput(dat()[[2]][1],lab,ini)
	})
	
	output$dist2 <- renderUI({
		lab <- switch(input$dist,
			norm="Standard deviation:", unif="Maximum:", F="Denominator degrees of freedom:", gam="Rate:", lnorm="Standard deviation(log)", beta="Beta:")
		ini <- switch(input$dist,
			norm=1, unif=1, F=15, gam=1, lnorm=1, beta=2)
		if(any(input$dist==c("norm","unif","F","gam","lnorm","beta"))) numericInput(dat()[[2]][2],lab,ini)
	})
	
	output$dldat <- downloadHandler(
		filename = function() { paste(input$dist, '.csv', sep='') },
		content = function(file) {
			write.csv(data.frame(x=dat()[[1]]), file)
		}
	)

	output$plot <- renderPlot({
		dist <- input$dist
		n <- input$n
		expr <- get(paste("expr",dist,sep="."))
		par(mar=c(2,2,10,1))
		hist(dat()[[1]],main=expr,xlab="Observations",col="orange",cex.main=1.5,cex.axis=1.2,cex.lab=1.2,prob=T)
		if(input$density) lines(density(dat()[[1]],adjust=input$bw),lwd=2)
	})
	
	output$summary <- renderPrint({
		summary(dat()[[1]])
	})
	
	output$table <- renderTable({
		data.frame(x=dat()[[1]])
	})
})
