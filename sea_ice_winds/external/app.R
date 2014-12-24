# Source reactive expressions and other code
source("external/appSourceFiles/reactives.R",local=T) # source reactive expressions
source("external/appSourceFiles/io.mainPanel.tp1.R",local=T) # source input/output objects associated with mainPanel tabPanel 1
source("external/appSourceFiles/plotFunctions.R",local=T) # source plotting functions

wind.cut <- reactive({ if(input$var!="Wind") input$cut else abs(as.numeric(input$cut)) })
varname <- reactive({ if(input$var!="Wind") input$var else tolower(input$var) })
main.prefix <- reactive({ if(input$coast=="Coastal only") "Coastal " else "" })
ylab.ann <- "Annual concentration / fraction"
main.ann <- reactive({paste0(main.prefix(),input$sea," annual ",input$mo,". sea ice concentration and fraction of days with ",varname(),"s > ",wind.cut()," m/s") })
ylab.dec <- "Decadal mean concentration / fraction"
main.dec <- reactive({ paste0(main.prefix(),input$sea," decadal mean ",input$mo,". sea ice concentration and fraction of days with ",varname(),"s > ",wind.cut()," m/s") })
cex <- 1.3

# Primary outputs
# Plot class error and confusion matrix
output$plotByYear <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		if(!is.null(w.prop.dec()) & !is.null(i.prop.dec()) & !is.null(input$annstyle)){
			tsPlot(w.prop.yrs()$Year,w.prop.yrs()$Freq,i.prop.yrs()$Con,yrs(),v1name=paste(input$mod,input$rcp,input$var),v2name="Composite RCP 8.5 Sea ice",style=input$annstyle,cex1=cex,
				ylim=c(0,1),xlb="Year",ylb=ylab.ann,mn=main.ann(),inset=c(0,-0.225))
		}
}, height=400, width=1200)

output$dl_plotByYear <- downloadHandler( # render plot to pdf for download
	filename = 'plotByYear.pdf',
	content = function(file){
		pdf(file = file, width=12, height=4)
		tsPlot(w.prop.yrs()$Year,w.prop.yrs()$Freq,i.prop.yrs()$Con,yrs(),v1name=paste(input$mod,input$rcp,input$var),v2name="Composite RCP 8.5 Sea ice",style=input$annstyle,cex1=cex-0.4,
			ylim=c(0,1),xlb="Year",ylb=ylab.ann,mn=main.ann(),inset=c(0,-0.3))
		dev.off()
	}
)

output$plotByDecade <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		if(!is.null(w.prop.dec()) & !is.null(i.prop.dec()) & !is.null(input$decstyle)){
			if(nrow(i.prop.dec())>1){
				tsPlot(w.prop.dec()$Year,w.prop.dec()$Freq,i.prop.dec()$Con,decadal=T,yrs(),v1name=paste(input$mod,input$rcp,input$var),v2name="Composite RCP 8.5 Sea ice",style=input$decstyle,xaxt="n",cex1=cex,
					ylim=c(0,1),xlb="Decade",ylb=ylab.dec,mn=main.dec(),inset=c(0,-0.225))
			}
		}
}, height=400, width=1200)

output$dl_plotByDecade <- downloadHandler( # render plot to pdf for download
	filename = 'plotByDecade.pdf',
	content = function(file){
		pdf(file = file, width=12, height=4)
		tsPlot(w.prop.dec()$Year,w.prop.dec()$Freq,i.prop.dec()$Con,decadal=T,yrs(),v1name=paste(input$mod,input$rcp,input$var),v2name="Composite RCP 8.5 Sea ice",style=input$decstyle,xaxt="n",cex1=cex-0.4,
			ylim=c(0,1),xlb="Decade",ylb=ylab.dec,mn=main.dec(),inset=c(0,-0.3))
		dev.off()
	}
)

output$pageviews <-	renderText({
	if (!file.exists("pageviews.Rdata")) pageviews <- 0 else load(file="pageviews.Rdata")
	pageviews <- pageviews + 1
	save(pageviews,file="pageviews.Rdata")
	paste("Visits:",pageviews)
})

# Temporary debugging 
output$debugging <- renderPrint({ yrs() }) #"Tab not yet available." })
