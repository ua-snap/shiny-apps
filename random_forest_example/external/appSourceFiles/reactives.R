# Datasets, variables
#dat <- reactive({
#	if(!is.null(input$dat.name)){
#		if(input$dat.name=="Flags") dat <- d else dat <- NULL #else if(input$dat.name=="some other dataset") dat <- some_other_dataset
#	} else dat <- NULL
#	dat
#})

dat <- reactive({ d })

varnames <- reactive({
	if(!is.null(dat())) v <- names(dat())[-1] else v <- NULL
	v
})

varnamesfactors <- reactive({
	print(var.is.factor)
	if(!is.null(varnames())) v <- varnames()[var.is.factor] else v <- NULL
	v
})

explanatoryvars <- reactive({
	if(!is.null(dat())){
		if(!is.null(input$response)) v <- varnames()[which(!(varnames() %in% input$response))] else v <- NULL
	} else v <- NULL
	v
})

responseclasses <- reactive({
	if(!is.null(input$response)){
		v <- dat()[,input$response]
		if(is.factor(v)) out <- levels(v) else if(is.numeric(v)) out <- unique(v) # no binning, only discrete variables present
	} else out <- NULL
	out
})

# Data subsetting
d.sub <- reactive({	if(!is.null(dat())) subset(dat(),select = -1) else NULL })

d.sub2 <- reactive({ if(!is.null(dat())) subset(d.sub(),select = -which(names(d.sub())==input$response)) else NULL })

# Random Forest model
rf1 <- reactive({
	if(!is.null(input$goButton)){
		if(input$goButton==0) return()
		isolate(
			rf1 <- randomForest(formula(paste(input$response,"~ .")), data=subset(d.sub(),select=which(names(d.sub()) %in% c(input$response,input$explanatory))),
					ntree=input$ntrees, importance=TRUE, proximity=TRUE)
		)
	} else return()
})

# Mean class error and confusion matrix
confusion.dat <- reactive({
	if(!is.null(rf1())){
		d <- data.frame(rf1()$confusion)
		names(d)[ncol(d)] <- "Error"
	} else d <- NULL
	d
})

class.error <- reactive({
	if(!is.null(confusion.dat())){
		d <- confusion.dat()[ncol(confusion.dat())]
		d <- data.frame(Class=rownames(d),Error=d[,1])
		rownames(d) <- NULL
	} else d <- NULL
	d
})

confusion.melt <- reactive({
	if(!is.null(confusion.dat())){
		d <- melt(data.frame(rownames(confusion.dat()),round(confusion.dat(),3)))
		names(d) <- c("Y","X","Count")
	} else d <- NULL
	d
})

# Variable importance measures
importance.dat <- reactive({
	if(!is.null(rf1())){
		d <- data.frame(rownames(importance(rf1())),round(importance(rf1()),2))
		names(d)[c(1,ncol(d)-1,ncol(d))] <- c("Predictor","mda","mdg")
		rownames(d) <- NULL
	} else d <- NULL
	d
})

predictor.acc <- reactive({
	if(!is.null(importance.dat())){
		d <- importance.dat()[c(1,ncol(importance.dat())-1)]
	} else d <- NULL
	d
})

predictor.gini <- reactive({
	if(!is.null(importance.dat())){
		d <- importance.dat()[c(1,ncol(importance.dat()))]
	} else d <- NULL
	d
})

importance.lab <- reactive({
	if(!is.null(importance.dat())){
		v <- c(names(importance.dat())[2:(ncol(importance.dat())-2)], "Mean decrease\nin accuracy", "Mean decrease\nin Gini")
	} else v <- NULL
	v
})

importance.melt <- reactive({
	if(!is.null(importance.dat())){
		d <- melt(importance.dat())
		names(d) <- c("Y","X","Importance")
	} else d <- NULL
	d
})

# Multi-dimensional scaling, classification margins, and outliers
d.new <- reactive({
	if(!is.null(rf1())){
		mds <- cmdscale(1 - rf1()$proximity, eig=TRUE) ## Do MDS on 1 - proximity
		d <- data.frame(mds$points,d.sub()[,input$response],mds$eig,dat()[,1],as.numeric(margin(rf1())),outlier(rf1()))
		names(d) <- c("Dim.1","Dim.2",input$response,"Eigen values",names(dat())[1],"Margin","Outliers")
	} else d <- NULL
	d
})

# Classification margin extrema
margin.extrema <- reactive({
	if(!is.null(d.new())){
		d <- sort(as.numeric(unlist(by(d.new(),d.new()[,3],FUN = function(x) rownames(x)[c(which.min(x$Margin),which.max(x$Margin))]))))
		d <- data.frame(dat()[d,1],d.new()[d,c(3,6)])
		names(d) <- c(names(dat())[1],names(d.new())[3],"Margin")
	} else d <- NULL
	d
})

# Partial dependence plot
pd <- reactive({
	if(!is.null(input$predictor)){
		partialPlot_x.var_globalEnv_Placeholder <<- input$predictor # ridiculous, but necessary when using partialPlot inside a function
		pd <- do.call(data.frame,partialPlot(rf1(),pred.data=d.sub(),x.var=sprintf("%s",partialPlot_x.var_globalEnv_Placeholder),which.class=input$responseclass,plot=F))
		names(pd) <- c(input$predictor,input$responseclass)
	} else pd <- NULL
	pd
})

# Number of variables
numVar <- reactive({
	input$cvRepsButton
	d <- NULL
	isolate(
		if(!is.null(input$cvRepsButton) & !is.null(input$n.reps)){
			if(input$cvRepsButton!=0){
				n <- as.numeric(input$n.reps)
				#x <- some output from parLapply or parSapply??? #faster, depends on number of cores used, unfortuantely can't make this work, might not be possible with Shiny
				x <- replicate(n, rfcv(d.sub2(), d.sub()[,input$response],step=0.75), simplify=FALSE) #slower, serial, takes about n minutes
				err.cv <- sapply(x, "[[", "error.cv")
				d <- data.frame(x[[1]]$n.var, err.cv,rowMeans(err.cv))
				names(d) <- c("NV",paste("Rep",c(1:n),sep="."),"Mean")
				d <- melt(d,id="NV")
				names(d)[2:3] <- c("Replicate","CV.error")
			}
		}
	)
	d
})
