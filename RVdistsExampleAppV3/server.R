library(shiny)
pkgs <- c("VGAM")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(VGAM)
load("samplingAppV3.RData", envir=.GlobalEnv)

shinyServer(function(input,output){
	dat <- reactive({
		dist <- switch(input$dist,
			bern=rbern, bin=rbinom2, dunif=drunif, geom=rgeom2, hgeom=rhyper2, nbin=rnbinom2, poi=rpois2, # discrete
			beta=rbeta2, cauchy=rcauchy2, chisq=rchisq2, exp=rexp2, F=rf2, gam=rgamma2, lap=rlaplace2, # continuous
			logi=rlogis2, lnorm=rlnorm, norm=rnorm, pareto=rpareto2, t=rt2, unif=runif, weib=rweibull2,
			)

		def.args <- switch(input$dist,
			# discrete
			bern=c(input$bern.prob),
			bin=c(input$binom.size,input$binom.prob),
			dunif=c(input$drunif.min,input$drunif.max,input$drunif.step),
			geom=c(input$geom.prob),
			hgeom=c(input$hyper.M,input$hyper.N,input$hyper.K),
			nbin=c(input$nbin.size,input$nbin.prob),
			poi=c(input$poi.lambda),
			# continuous
			beta=c(input$beta.shape1,input$beta.shape2),
			cauchy=c(input$cau.location,input$cau.scale),
			chisq=c(input$chisq.df),
			exp=c(input$exp.rate),
			F=c(input$F.df1,input$F.df2),
			gam=c(input$gam.shape,input$gam.rate),
			lap=c(input$lap.location,input$lap.scale),
			logi=c(input$logi.location,input$logi.scale),
			lnorm=c(input$meanlog,input$sdlog),
			norm=c(input$mean,input$sd),
			pareto=c(input$pareto.location,input$pareto.shape),
			t=c(input$t.df),
			unif=c(input$min,input$max),
			weib=c(input$weib.shape,input$weib.scale)
			)

		f <- formals(dist)
		f <- f[names(f)!="nn" & names(f)!="n"]
		if(any(input$dist==c("dunif","hgeom"))){ len <- min(length(f),4-1); f <- f[1:len]
		} else { len <- min(length(f),3-1); f <- f[1:len] }
		argList <- list(n=input$n)
		for(i in 1:len) argList[[names(f)[i]]] <- def.args[i]
		return(list(do.call(dist,argList),names(f)))
	})

	output$dist1 <- renderUI({
		lab <- switch(input$dist,
			bern="Probability:", bin="Size:", dunif="Discrete sequence minimum:", geom="Probability:", hgeom="M:", nbin="Number of successes:",	poi="Mean and Variance:", # discrete
			beta="Alpha:", cauchy="Location:", chisq="Degrees of freedom:", exp="Rate:", F="Numerator degrees of freedom:", gam="Shape:", lap="Location:",
			logi="Location:", lnorm="Mean(log):", norm="Mean:", pareto="Location:",	t="Degrees of freedom:", unif="Minimum:", weib="Shape:"
			# logistic and log-normal are switched on plotmath expressions graphic!
			)
		ini <- switch(input$dist,
			bern=0.5, bin=10, dunif=0, geom=0.5, hgeom=10, nbin=10, poi=10,	# discrete
			beta=2, cauchy=0, chisq=1, exp=1, F=1, gam=1, lap=0, logi=0, lnorm=0, norm=0, pareto=1,	t=15, unif=0, weib=1 # continuous
			)
		numericInput(dat()[[2]][1],lab,ini)
	})
	
	output$dist2 <- renderUI({
		lab <- switch(input$dist,
			bin="Probability:",	dunif="Discrete sequence maximum:",	hgeom="N:",	nbin="Probability:", # discrete
			beta="Beta:", cauchy="Scale:", F="Denominator degrees of freedom:", gam="Rate:", lap="Scale:", # continuous
			logi="Scale:", lnorm="Standard deviation(log)", norm="Standard deviation:", pareto="Shape:", unif="Maximum:", weib="Scale:"
			)
		ini <- switch(input$dist,
			bin=0.5, dunif=100, hgeom=20, nbin=0.5,
			beta=2, cauchy=1, F=15, gam=1, lap=1, logi=1, lnorm=1, norm=1, pareto=3, unif=1, weib=1
			)
		if(any(input$dist==c("bin","dunif","hgeom","nbin","cauchy","lap","logi","pareto","weib",
							"beta","F","gam","lnorm","norm","unif"))) numericInput(dat()[[2]][2],lab,ini)
	})
	
	output$dist3 <- renderUI({
		lab <- switch(input$dist,
			dunif="Step size:",	hgeom="K:")
		ini <- switch(input$dist,
			dunif=1, hgeom=5)
		if(any(input$dist==c("dunif","hgeom"))) numericInput(dat()[[2]][3],lab,ini)
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
		par(mar=c(4,4,10,1))
		hist(dat()[[1]],main=expr,xlab="Observations",col="orange",cex.main=1.5,cex.axis=1.3,cex.lab=1.3,prob=T)
		if(input$density) lines(density(dat()[[1]],adjust=input$bw),lwd=2)
	},
	height=750, width=1000
	)
	
	output$summary <- renderPrint({
		summary(dat()[[1]])
	})
	
	output$table <- renderTable({
		data.frame(x=dat()[[1]])
	})
	
})
