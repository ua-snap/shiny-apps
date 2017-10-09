library(VGAM)
library(ggplot2)

shinyServer(function(input, output, session){

	is_discrete <- reactive({ if(!is.null(input$dist) && input$dist %in% discrete) TRUE else FALSE })
	
	cur_dist <- reactive({
	  switch(input$dist,
           bern = rbern, bin = rbinom2, dunif = drunif, geom = rgeom2, hgeom = rhyper2, nbin = rnbinom2, poi = rpois2,
           beta = rbeta2, cauchy = rcauchy2, chisq = rchisq2, exp = rexp2, F = rf2, gam = rgamma2, lap = rlaplace2,
           logi = rlogis2, lognorm = rlnorm, norm = rnorm, pareto = rpareto2, t = rt2, unif = runif, weib = rweibull2
	  )
	})
	
	raw_formals <- reactive({
	  x <- formals(cur_dist())
	  x[names(x) != "nn" & names(x) != "n"]
	})
	
	cur_length <- reactive({
	  n <- length(raw_formals())
	  if(input$dist %in% c("dunif", "hgeom")) min(n, 4 - 1) else min(n, 3 - 1)
	})
	
	cur_formals <- reactive({ raw_formals()[1:cur_length()] })
	
	def_args <- reactive({
	  switch(
	    input$dist,
      bern = c(input$bern.prob),
      bin = c(input$binom.size, input$binom.prob),
      dunif = c(input$drunif.min, input$drunif.max, input$drunif.step),
      geom = c(input$geom.prob),
      hgeom = c(input$hyper.M, input$hyper.N, input$hyper.K),
      nbin = c(input$nbin.size, input$nbin.prob),
      poi = c(input$poi.lambda),
      beta = c(input$beta.shape1, input$beta.shape2),
      cauchy = c(input$cau.location, input$cau.scale),
      chisq = c(input$chisq.df),
      exp = c(input$exp.rate),
      F = c(input$F.df1, input$F.df2),
      gam = c(input$gam.shape, input$gam.rate),
      lap = c(input$lap.location, input$lap.scale),
      logi = c(input$logi.location, input$logi.scale),
      lognorm = c(input$meanlog, input$sdlog),
      norm = c(input$mean, input$sd),
      pareto = c(input$pareto.scale, input$pareto.shape),
      t = c(input$t.df),
      unif = c(input$min, input$max),
      weib = c(input$weib.shape, input$weib.scale)
	  )
	})
	
	cur_args <- reactive({
	  x <- list(n = input$n)
	  for(i in 1:cur_length()) x[[names(cur_formals())[i]]] <- def_args()[i]
	  x
	})
	
	dat <- reactive({ list(do.call(cur_dist(), cur_args()), names(cur_formals()))	})

	output$dist1 <- renderUI({ 
	  input$dist
	  isolate(numericInput(dat()[[2]][1], arg1$lab[[input$dist]], arg1$ini[[input$dist]], step = arg1$step[[input$dist]]))
	})
	output$dist2 <- renderUI({
	  input$dist
	  isolate({
	    if(input$dist %in% two_args)
		    numericInput(dat()[[2]][2], arg2$lab[[input$dist]], arg2$ini[[input$dist]], step = arg2$step[[input$dist]])
	  })
	})
	output$dist3 <- renderUI({
	  input$dist
	  isolate({
	    if(input$dist %in% three_args) 
		    numericInput(dat()[[2]][3], arg3$lab[[input$dist]], arg3$ini[[input$dist]], step = arg3$step[[input$dist]])
		})
	})
	
	doPlot <- function(){
	  d <- dat()[[1]]
	  dist <- input$dist
	  n <- input$n
	  expr <- get(paste("expr", dist, sep = "."))
	  if(is_discrete()){
	    d <- table(d)
	    d <- data.frame(x = factor(names(d), levels = names(d)), y = as.numeric(d) / n)
	    ymx <- 1.25*max(d$y)
	    ggplot(d, aes(x, y)) + geom_col(colour = "black", fill = "white") + 
	      labs(title = paste(names(discrete)[discrete == dist], "distribution"), x = "Observations", y = "Density") +
	      annotate("text", x = -Inf, y = ymx, hjust = -1, vjust = 1.5, size = 7, label = as.character(expr), parse = TRUE) +
	      scale_y_continuous(expand = c(0, 0))  + theme_gray(base_size = 18)
	  } else {
	    d <- data.frame(x = d)
	    ggplot(d, aes(x, y=..density..)) + geom_histogram(colour = "black", fill = "white", bins = 15) + 
	      geom_line(stat = "density", adjust = 2) +
	      labs(title = paste(names(continuous)[continuous == dist], "distribution"), x = "Observations", y = "Density") +
	      annotate("text", x = -Inf, y = Inf, hjust = -1, vjust = 1.5, size = 7, label = as.character(expr), parse = TRUE) +
	      scale_y_continuous(expand = expand_scale(mult = c(0, 0.25))) + theme_gray(base_size = 18)
	  }
	}
	
	output$plot <- renderPlot({
	  x <- input$dist
	  a1 <- if(x %in% names(arg1$lab)) input[[dat()[[2]][1]]] else NULL
	  a2 <- if(x %in% names(arg2$lab)) input[[dat()[[2]][2]]] else NULL
	  a3 <- if(x %in% names(arg3$lab)) input[[dat()[[2]][3]]] else NULL
	  x <- list(a1, a2, a3)[1:cur_length()]
	  if(!length(x) || any(sapply(x, is.null))) return()
	  doPlot()
	})
	
	output$dlCurPlot <- downloadHandler(
		filename = 'plot.pdf',
		content = function(file){
			pdf(file = file, width = 20, height = 10)
			print(doPlot())
			dev.off()
		}
	)
})
