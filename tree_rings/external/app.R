# Source reactive expressions and other code
source("external/appSourceFiles/reactives.R",local=T) # source reactive expressions

source("external/appSourceFiles/io.sidebar.wp1.R",local=T) # source input/output objects associated with sidebar wellPanel 1

#source("external/appSourceFiles/io.sidebar.wp2.R",local=T) # source input/output objects associated with sidebar wellPanel 2

source("external/appSourceFiles/io.mainPanel.tp1.R",local=T) # source input/output objects associated with mainPanel tabPanel 1

source("external/appSourceFiles/plotFunctions.R",local=T) # source plotting functions

# Primary outputs
# Plot class error and confusion matrix
output$macorplot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		if(!is.null(input$dataset)){
			plotFun(m=get(input$dataset),file=NULL,colpal=colpal)
		}
}, height=875, width=1200)

output$dl_macorplotPDF <- downloadHandler( # render plot to pdf for download
	filename = 'current_macorplot.pdf',
	content = function(file){
		pdf(file=file, width=12, height=8.75, pointsize=8)
		plotFun(m=get(input$dataset),file=NULL,colpal=colpal)
		dev.off()
	}
)

output$dl_macorplotPNG <- downloadHandler( # render plot to pdf for download
	filename = 'current_macorplot.png',
	content = function(filename){ plotFun(m=get(input$dataset),file=filename,colpal=colpal) },
	contentType = 'image/png'
)

# Temporary debugging 
output$debugging <- renderPrint({ yrs() }) #"Tab not yet available." })
