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
	if(!is.null(dat()))	sliderInput("cv.folds","Cross-validation folds:",2,10,2,step=1)
})

output$shrinkage <- renderUI({
	if(!is.null(dat()))	selectInput("shrinkage","Shrinkage rate:",choices=c(0.001,0.005,0.01,0.05,0.1),selected=0.05)
})

output$interaction.depth <- renderUI({
	if(!is.null(dat()))	selectInput("interaction.depth","Interaction depth:",choices=1:length(input$vars),selected=1)
})

gbm1 <- reactive({
	if(!is.null(dat()) & length(input$vars)){
		gbm1 <- gbm(
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
			n.cores=1
		)
	} else gbm1 <- NULL
	gbm1
})

best.iter <- reactive({
	if(!is.null(gbm1())){
		d <- data.frame(gbm.perf(gbm1(),method="OOB",plot.it=F), gbm.perf(gbm1(),method="test",plot.it=F), gbm.perf(gbm1(),method="cv",plot.it=F))
		names(d) <- c(paste0(100*(1-input$bag.fraction),"% Out of Bag"),paste0(100*(1-input$train.fraction),"% Test Set"),paste0(input$cv.folds,"-fold Cross-Validation"))
	} else d <- NULL
	d
})

ri <- reactive({
	if(!is.null(gbm1())){
		b <- best.iter()[1,]
		ri <- ldply(list("OOB"=summary(gbm1(),n.trees=b[1],order=F,plotit=F),
						 "test"=summary(gbm1(),n.trees=b[2],order=F,plotit=F),
						 "cv"=summary(gbm1(),n.trees=b[3],order=F,plotit=F)), data.frame)
		names(ri) <- c("Method","Variable","Relative Influence")
	} else ri <- NULL
	ri
})

output$best.iter.table <- renderTable({ if(!is.null(best.iter)) best.iter() })

output$ri.table <- renderTable({ ri() })

doPlot.best.iter <- function(...){
	if(!is.null(gbm1())){
		n <- gbm1()$n.trees
		b <- best.iter()[1,]
		plot(1:n,gbm1()$train.error,type="l",lwd=1,col=1)
		lines(1:n,gbm1()$valid.error,lwd=1,col="orange")
		lines(1:n,gbm1()$cv.error,lwd=1,col="dodgerblue")
		points(b,gbm1()$valid.error[b],pch="*",cex=1.5)
		points(b,gbm1()$cv.error[b],pch="*",cex=1.5)
	} else NULL
}

doPlot.ri <- function(...){
	if(!is.null(gbm1())){
		g <- ggplot(ri(), aes_string("Method","Relative Influence",fill="Variable")) + geom_bar(stat="identity", position="dodge")
		print(g)
	} else NULL
}

output$plot.best.iter <- renderPlot({ doPlot.best.iter() }, height=800, width=1000)

output$plot.ri <- renderPlot({ doPlot.ri() }, height=800, width=1000)

output$num.cv.folds <- renderPrint({ names(gbm1()) })
