output$dat.name <- renderUI({
	selectInput("dat.name","Data:",choices="Simulated data",selected="Simulated data")
})

dat <- reactive({
	if(!is.null(input$dat.name)){
		if(input$dat.name=="Simulated data"){
			dat <- dat1
		} else dat <- NULL
	} else dat <- NULL
	dat
})

output$vars <- renderUI({
	if(!is.null(dat()))	checkboxGroupInput("vars","Explanatory variables:",names(dat()[-1]),selected=names(dat()[2]))
})

output$n.trees <- renderUI({
	if(!is.null(dat()))	sliderInput("n.trees","Number of trees:",100,10000,100,step=100)
})

output$bag.fraction <- renderUI({
	if(!is.null(dat()))	sliderInput("bag.fraction","Bag fraction:",0.1,1,0.5,step=0.05)
})

output$train.fraction <- renderUI({
	if(!is.null(dat()))	sliderInput("train.fraction","Training fraction:",0.1,1,0.5,step=0.05)
})

output$n.minobsinnode <- renderUI({
	if(!is.null(dat()))	sliderInput("n.minobsinnode","Min. obs. in terminal nodes:",1,10,5,step=1)
})

output$cv.folds <- renderUI({
	if(!is.null(dat()))	sliderInput("cv.folds","Cross-validation folds:",1,10,1,step=1)
})

output$shrinkage <- renderUI({
	if(!is.null(dat()))	selectInput("shrinkage","Shrinkage rate:",choices=c(0.001,0.005,0.01,0.05,0.1),selected=0.05)
})

output$interaction.depth <- renderUI({
	if(!is.null(dat()))	selectInput("interaction.depth","Interaction depth:",choices=1:length(input$vars),selected=1)
})

gbm1 <- reactive({
	if(input$goButton==0) gbm1 <- NULL
	isolate(
		if(!is.null(dat()) & length(input$vars)){
			gbm1 <- isolate(
				gbm(
					as.formula(paste(names(dat()[1]),"~",paste(input$vars,collapse="+"))),
					data=dat(),
					var.monotone=rep(0,length(input$vars)),
					distribution="gaussian",
					n.trees=input$n.trees,
					shrinkage=as.numeric(input$shrinkage),
					interaction.depth=as.numeric(input$interaction.depth),
					bag.fraction=input$bag.fraction,
					#nTrain=round(nrow(dat())*input$train.fraction),
					train.fraction=input$train.fraction,
					n.minobsinnode=input$n.minobsinnode,
					cv.folds=input$cv.folds,
					n.cores=min(input$cv.folds,4)
				)
			)
		} else gbm1 <- NULL
	)
	gbm1
})

best.iter <- reactive({
	if(input$goButton==0) return()
	isolate(
		if(!is.null(gbm1())){
			rnames <- c("Optimal Number of Trees","Training Set Error","Test Set Error")
			if(input$cv.folds<2){
				d <- data.frame(gbm.perf(gbm1(),method="OOB",plot.it=F), gbm.perf(gbm1(),method="test",plot.it=F))
				names(d) <- c(paste0(100*(1-input$bag.fraction),"% Out of Bag"),paste0(100*(1-input$train.fraction),"% Test Set"))
			} else {
				d <- data.frame(gbm.perf(gbm1(),method="OOB",plot.it=F), gbm.perf(gbm1(),method="test",plot.it=F), gbm.perf(gbm1(),method="cv",plot.it=F))
				names(d) <- c(paste0(100*(1-input$bag.fraction),"% Out of Bag"),paste0(100*(1-input$train.fraction),"% Test Set"),paste0(input$cv.folds,"-fold Cross-Validation"))
				rnames <- c(rnames,"Cross-Validation Error")
			}
			d1 <- unlist(d[1,])
			d <- rbind(d, gbm1()$train.error[d1], gbm1()$valid.error[d1])
			if(input$cv.folds>1) d <- rbind(d,gbm1()$cv.error[d1])
			rownames(d) <- rnames
			return(d)
		} else return()
	)
})

ri <- reactive({
	if(input$goButton==0) return()
	isolate(
		if(!is.null(best.iter())){
			b <- unlist(best.iter()[1,])
			if(input$cv.folds<2){
				ri <- ldply(list("OOB"=summary(gbm1(),n.trees=b[1],order=F,plotit=F),
								 "Test"=summary(gbm1(),n.trees=b[2],order=F,plotit=F)), data.frame)
				names(ri) <- c("Method","Variable","RI")
			} else {
				ri <- ldply(list("OOB"=summary(gbm1(),n.trees=b[1],order=F,plotit=F),
								 "Test"=summary(gbm1(),n.trees=b[2],order=F,plotit=F),
								 "CV"=summary(gbm1(),n.trees=b[3],order=F,plotit=F)), data.frame)
				names(ri) <- c("Method","Variable","RI")
			}
			return(ri)
		} else return()
	)
})

output$best.iter.table <- renderTable({ if(!is.null(best.iter())) best.iter() })

output$ri.table.oob <- renderTable({ if(!is.null(ri())) ri()[ri()$Method=="OOB",] })

output$ri.table.test <- renderTable({ if(!is.null(ri())) ri()[ri()$Method=="Test",] })

output$ri.table.cv <- renderTable({ if(!is.null(ri())) if("CV" %in% ri()$Method) ri()[ri()$Method=="CV",] })

doPlot.best.iter <- function(...){
	if(input$goButton==0) plot(0,0,type="n",axes=F,xlab="",ylab="")
	isolate(
	if(!is.null(best.iter())){
		n <- gbm1()$n.trees
		b <- unlist(best.iter()[1,])
		d <- data.frame(Trees=1:n,Training.Error=gbm1()$train.error,Test.Error=gbm1()$valid.error)
		if(input$cv.folds>1) d$CV.Error <- gbm1()$cv.error
		d <- melt(d,id="Trees")
		names(d) <- c("Number of Trees","Type of Error","Error")
		g <- ggplot(d, aes(x=`Number of Trees`,y=Error,group=`Type of Error`,colour=`Type of Error`)) + geom_line()
		print(g)
	}
	)
}

doPlot.ri <- function(...){
	if(input$goButton==0) plot(0,0,type="n",axes=F,xlab="",ylab="")
	isolate(
	if(!is.null(ri())){
		g <- ggplot(ri(), aes(Method,RI,fill=Variable)) + geom_bar(stat="identity", position="dodge")
		print(g)
	}
	)
}

output$no.vars.selected <- renderUI({
	HTML(paste('<div>','Select at least one explanatory variable to use gradient boosting to estimate the response.','</div>',sep="",collapse=""))
})

output$plot.best.iter <- renderPlot({ doPlot.best.iter() }, height=600, width=1000)

output$plot.ri <- renderPlot({ doPlot.ri() }, height=400, width=1000)

output$pageviews <-	renderText({
	if (!file.exists("pageviews.Rdata")) pageviews <- 0 else load(file="pageviews.Rdata")
	pageviews <- pageviews + 1
	save(pageviews,file="pageviews.Rdata")
	paste("Visits:",pageviews)
})
