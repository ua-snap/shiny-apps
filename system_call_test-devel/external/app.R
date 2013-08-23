# Source reactive expressions and other code
source("external/appSourceFiles/reactives.R",local=T) # source reactive expressions

source("external/appSourceFiles/io.sidebar.wp1.R",local=T) # source input/output objects associated with sidebar wellPanel 1

#source("external/appSourceFiles/io.sidebar.wp2.R",local=T) # source input/output objects associated with sidebar wellPanel 2

source("external/appSourceFiles/io.mainPanel.tp1.R",local=T) # source input/output objects associated with mainPanel tabPanel 1

source("external/appSourceFiles/plotFunctions.R",local=T) # source plotting functions

observe({ system(paste0("external/shell.txt external/script.R")) }) #sysCall() })

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

# Temporary debugging 
output$debugging <- renderPrint({ "This tab and others not yet available." }) # levels(dat.sub()$Month) }) # 
