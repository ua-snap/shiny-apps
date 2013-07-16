# Source reactive expressions and other code
source("external/appSourceFiles/reactives.R",local=T) # source reactive expressions

source("external/appSourceFiles/io.sidebar.wp1.R",local=T) # source input/output objects associated with sidebar wellPanel 1

source("external/appSourceFiles/io.sidebar.wp2.R",local=T) # source input/output objects associated with sidebar wellPanel 2

source("external/appSourceFiles/io.mainPanel.tp1.R",local=T) # source input/output objects associated with mainPanel tabPanel 1

source("external/appSourceFiles/plotFunctions.R",local=T) # source plotting functions

fs <- 20 # temporarily hardcoded
fs.sub <- 4
cs <- 6
cs.sub <- 3

# Primary outputs
# Plot class error and confusion matrix
output$classErrorPlot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		input$goButton
		isolate( if(!is.null(input$goButton)) if(input$goButton!=0) classErrorPlot(class.error=class.error(), confusion.melt=confusion.melt(), cs, fs) )
}, height=1000, width=1600)

output$dl_classErrorPlot <- downloadHandler( # render plot to pdf for download
	filename = 'classErrorPlot.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		classErrorPlot(class.error=class.error(), confusion.melt=confusion.melt(), cs-cs.sub, fs-fs.sub)
		dev.off()
	}
)

# Plot variable importance
output$impAccPlot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		input$goButton
		isolate( if(!is.null(input$goButton)) if(input$goButton!=0) importancePlot(d=predictor.acc(), ylb="mda", fs) )
}, height=1000, width=1600)

output$dl_impAccPlot <- downloadHandler( # render plot to pdf for download
	filename = 'meanDecreaseAccuracyPlot.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		importancePlot(d=predictor.acc(), ylb="mda", fs-fs.sub)
		dev.off()
	}
)

output$impGiniPlot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		input$goButton
		isolate( if(!is.null(input$goButton)) if(input$goButton!=0) importancePlot(d=predictor.gini(), ylb="mdg", fs) )
}, height=1000, width=1600)

output$dl_impGiniPlot <- downloadHandler( # render plot to pdf for download
	filename = 'meanDecreaseGiniPlot.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		importancePlot(d=predictor.gini(), ylb="mdg", fs-fs.sub)
		dev.off()
	}
)

output$impTablePlot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		input$goButton
		isolate( if(!is.null(input$goButton)) if(input$goButton!=0) impTablePlot(importance.melt=importance.melt(), lab=importance.lab(), cs, fs) )
}, height=1000, width=1600)

output$dl_impTablePlot <- downloadHandler( # render plot to pdf for download
	filename = 'varImportanceTablePlot.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		impTablePlot(importance.melt=importance.melt(), lab=importance.lab(), cs-cs.sub, fs-fs.sub)
		dev.off()
	}
)

# Multi-dimensional scaling plot (2-D)
output$mdsPlot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		input$goButton
		isolate( if(!is.null(input$goButton)) if(input$goButton!=0) mdsPlot(d=d.new(), fs) )
}, height=1000, width=1600)

output$dl_mdsPlot <- downloadHandler( # render plot to pdf for download
	filename = 'mdsPlot.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		mdsPlot(d=d.new(), fs-fs.sub)
		dev.off()
	}
)

# Classification margin plot with extreme values
output$marginPlot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		input$goButton
		isolate( if(!is.null(input$goButton)) if(input$goButton!=0) marginPlot(d=d.new(), extrema=margin.extrema(), clrs=clrs, cs, fs) )
}, height=1000, width=1600)

output$dl_marginPlot <- downloadHandler( # render plot to pdf for download
	filename = 'marginPlot.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		marginPlot(d=d.new(), extrema=margin.extrema(), clrs=clrs, cs-cs.sub, fs-fs.sub)
		dev.off()
	}
)

# Partial dependence plot
output$pdPlot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		input$goButton
		input$responseclass
		input$predictor
		isolate(
			if(!is.null(input$goButton) & !is.null(input$responseclass) & !is.null(input$predictor)){
				if(input$goButton!=0) pdPlot(pd=pd(), clrs=clrs, fs)
			}
		)
}, height=1000, width=1600)

output$dl_pdPlot <- downloadHandler( # render plot to pdf for download
	filename = 'pdPlot.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		pdPlot(pd=pd(), clrs=clrs, fs-fs.sub)
		dev.off()
	}
)

# Outlier plot
output$outlierPlot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		input$goButton
		input$n.outliers
		isolate(
			if(!is.null(input$goButton) & !is.null(input$n.outliers)){
				if(input$goButton!=0) outlierPlot(d=d.new(), n=input$n.outliers, clrs=clrs, cs, fs)
			}
		)
}, height=1000, width=1600)

output$dl_outlierPlot <- downloadHandler( # render plot to pdf for download
	filename = 'outlierPlot.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		outlierPlot(d=d.new(), n=input$n.outliers, clrs=clrs, cs-cs.sub, fs-fs.sub)
		dev.off()
	}
)

# Error rates plot
output$errorRatePlot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		input$goButton
		isolate(
			if(!is.null(input$goButton)) if(input$goButton!=0) errorRatePlot(err=rf1()$err.rate, clrs=clrs, fs)
		)
}, height=1000, width=1600)

output$dl_errorRatePlot <- downloadHandler( # render plot to pdf for download
	filename = 'errorRatePlot.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		errorRatePlot(err=rf1()$err.rate, clrs=clrs, fs-fs.sub)
		dev.off()
	}
)

# Plot of number of times variables used across all trees
output$varsUsedPlot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		input$goButton
		isolate(
			if(!is.null(input$goButton)) if(input$goButton!=0) varsUsedPlot(d=d.sub2(), rf1=rf1(), fs)
		)
}, height=1000, width=1600)

output$dl_varsUsedPlot <- downloadHandler( # render plot to pdf for download
	filename = 'varsUsedPlot.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		varsUsedPlot(d=d.sub2(),rf1=rf1(), fs-fs.sub)
		dev.off()
	}
)

# Number of variables cross-validation error reduction plot
output$numVarPlot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		numVar()
		isolate(
			if(!is.null(numVar())) numVarPlot(d=numVar(), fs)
		)
}, height=1000, width=1600)

output$dl_numVarPlot <- downloadHandler( # render plot to pdf for download
	filename = 'numVarPlot.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		numVarPlot(d=numVar, fs-fs.sub)
		dev.off()
	}
)

# Temporary debugging 
output$debugging <- renderPrint({ "This tab and others not yet available." }) # levels(dat.sub()$Month) }) # 
