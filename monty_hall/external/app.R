# Source reactive expressions and other code
source("external/appSourceFiles/reactives.R",local=T) # source reactive expressions
source("external/appSourceFiles/io.sb.R",local=T) # source input/output objects associated with sidebar

output$mhplot <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		if(!is.null(d())){
			panplot(d()[[1]], d()[[2]], d()[[3]], d()[[4]], N=as.numeric(input$totaldoors))
		}
}, height=function() session$clientData$output_mhplot_width, width="auto")

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
