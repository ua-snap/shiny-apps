# Source reactive expressions and other code
source("external/appSourceFiles/reactives.R",local=T) # source reactive expressions

source("external/appSourceFiles/io.sidebar.wp1.R",local=T) # source input/output objects associated with sidebar wellPanel 1

source("external/appSourceFiles/io.sidebar.wp2.R",local=T) # source input/output objects associated with sidebar wellPanel 2

source("external/appSourceFiles/io.mainPanel.tp1.R",local=T) # source input/output objects associated with mainPanel tabPanel 1

doPlot1 <- source("external/appSourceFiles/doPlot1.R",local=T)$value # this plotting function is not reactive but depends on reactive elements

# Primary outputs
output$plot1 <- renderPlot({ # render plot from doPlot1 for mainPanel tabsetPanel tabPanel 1
		input$goButton
		input$updateButton
		input$colorpalettes
		#input$altplot
		input$bartype
		input$bardirection
		input$legendPos1
		input$plotFontSize
		isolate( doPlot1(dat=dat.sub(), x=input$xtime, y="value") )
}, height=700, width=1200)

output$dlCurPlot1 <- downloadHandler( # render plot from doPlot1 to pdf for download
	filename = 'curPlot1.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		doPlot1(dat=dat.sub(), x=input$xtime, y="value",show.logo=T)
		dev.off()
	}
)

output$dlCurTable1 <- downloadHandler( # render table of data subset to csv for download
	filename = function() { 'curTable1.csv' },
	content = function(file) {
		write.csv(dat.sub(), file)
	}
)

output$pageviews <-	renderText({
	if (!file.exists("pageviews.Rdata")) pageviews <- 0 else load(file="pageviews.Rdata")
	pageviews <- pageviews + 1
	save(pageviews,file="pageviews.Rdata")
	paste("Visits:",pageviews)
})

# Temporary debugging 
output$debugging <- renderPrint({ "This tab and others not yet available." }) # levels(dat.sub()$Month) }) # 
