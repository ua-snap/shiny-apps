library(shiny)
library(datasets)
rt2 <- function(n=500,dft=15){ rt(n=n,df=dft) }
formals(rgamma)[1:2] <- c(500,1)
rchisq2 <- function(n=500,dfx=1){ rchisq(n=n,df=dfx) }
formals(rf)[1:3] <- c(500,1,15)
rexp2 <- function(n=500,rate2=1){ rexp(n=n,rate=rate2) }
formals(rbeta)[1:3] <- c(500,2,2)

shinyServer(function(input,output){
	dat <- reactive(function(){
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

	output$dist1 <- reactiveUI(function(){
		lab <- switch(input$dist,
			norm="Mean:", unif="Minimum:", t="Degrees of freedom:", F="Numerator degrees of freedom:", gam="Shape:", exp="Rate:",
			chisq="Degrees of freedom:", lnorm="Mean(log):", beta="Alpha:")
		ini <- switch(input$dist,
			norm=0, unif=0, t=15, F=1, gam=1, exp=1, chisq=1, lnorm=0, beta=2)
		numericInput(dat()[[2]][1],lab,ini)
	})
	
	output$dist2 <- reactiveUI(function(){
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

	output$plot <- reactivePlot(function(){
		dist <- input$dist
		n <- input$n
		hist(dat()[[1]],main="",xlab="Observations",col="orange",cex.axis=1.2,cex.lab=1.2,prob=T)
		if(input$density) lines(density(dat()[[1]],adjust=input$bw),lwd=2)
	})
	
	output$summary <- reactivePrint(function(){
		summary(dat()[[1]])
	})
	
	output$table <- reactiveTable(function(){
		data.frame(x=dat()[[1]])
	})
})
