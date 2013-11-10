# Source reactive expressions and other code
source("external/appSourceFiles/reactives.R",local=T) # source reactive expressions

source("external/appSourceFiles/io.sidebar.wp1.R",local=T) # source input/output objects associated with sidebar wellPanel 1

#source("external/appSourceFiles/io.sidebar.wp2.R",local=T) # source input/output objects associated with sidebar wellPanel 2

#source("external/appSourceFiles/io.mainPanel.tp1.R",local=T) # source input/output objects associated with mainPanel tabPanel 1

#source("external/appSourceFiles/plotFunctions.R",local=T) # source plotting functions

# Primary outputs
# Plot class error and confusion matrix
output$mhplot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		if(!is.null(d())){
			panplot(d()[[1]], d()[[2]], d()[[3]], d()[[4]], N=as.numeric(input$totaldoors))
		}
}, height=1200, width=1200)

output$dl_mhplotPDF <- downloadHandler( # render plot to pdf for download
	filename = 'current_mhplot.pdf',
	content = function(file){
		pdf(file=file, width=12, height=12, pointsize=8)
		panplot(d()[[1]], d()[[2]], d()[[3]], d()[[4]], N=as.numeric(input$totaldoors))
		dev.off()
	}
)

output$dl_mhplotPNG <- downloadHandler( # render plot to pdf for download
	filename = 'current_mhplot.png',
	content = function(filename){ panplot(d()[[1]], d()[[2]], d()[[3]], d()[[4]], N=as.numeric(input$totaldoors), file=filename) },
	contentType = 'image/png'
)

# Temporary debugging 
output$debugging <- renderPrint({ yrs() }) #"Tab not yet available." })
