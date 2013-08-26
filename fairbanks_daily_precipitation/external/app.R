# Source reactive expressions and other code
source("external/appSourceFiles/reactives.R",local=T) # source reactive expressions

source("external/appSourceFiles/io.sidebar.wp1.R",local=T) # source input/output objects associated with sidebar wellPanel 1

#source("external/appSourceFiles/io.sidebar.wp2.R",local=T) # source input/output objects associated with sidebar wellPanel 2

source("external/appSourceFiles/io.mainPanel.tp1.R",local=T) # source input/output objects associated with mainPanel tabPanel 1

source("external/appSourceFiles/plotFunctions.R",local=T) # source plotting functions

doPlot <- function(filename,addLogo=F, cex.master=1.3, cex.lab=1.3, cex.axis=1.1) {
	dailyPlot(d(), file=filename, mo1=match(input$mo,month.abb), cex.exp=7, xaxis.day=15, dates=moyr365, colpalvec=colPal(), num.colors=20, alpha=85,
		tformColBar=function(x) x, tformCol=function(x) recursiveLog(x,N=2), tformColMar=function(x) recursiveLog(x,N=10),
		bars=T, bar.means=T, marginal=T, loess.span=0.2, col.totals="gray80", bg.plot="black",
		main.title="Fairbanks daily precipitation", xlb="", ylab="", logo=addLogo, logofile=logo,
		pch=21, col.ax.lab="white", col.main="white", col.lab="white", col.axis="white", cex.lab=cex.lab, cex.axis=cex.axis, las=2, cex.master=cex.master)
}

plotHeight <- function() if(!is.null(input$yrs)) (4/12)*1200+(length(seq(input$yrs[1],input$yrs[2],by=1))/16)*800 else 0

# Primary outputs
# Plot class error and confusion matrix
output$plotDailyPrecip <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
		if(!is.null(colPal()) & !is.null(input$yrs)){
			if(length(seq(input$yrs[1],input$yrs[2],by=1))>1) doPlot(filename=NULL, cex.master=1.8, cex.lab=1.8, cex.axis=1.5) else { par(mar=c(0,0,0,0),bg="black"); plot(0,0,type="n",axes=F) }
		}
}, height=plotHeight, width=1200)

output$dl_plotDailyPrecipPDF <- downloadHandler( # render plot to pdf for download
	filename = 'plotDailyPrecip.pdf',
	content = function(file){
		pdf(file = file, width=10, height=10*plotHeight()/1200)
			doPlot(filename=NULL,addLogo=T)
		dev.off()
	}
)

output$dl_plotDailyPrecipPNG <- downloadHandler( # render plot to pdf for download
	filename = 'plotDailyPrecip.png',
	content = function(filename){ doPlot(filename=filename,addLogo=T) },
	contentType = 'image/png'
)

# Temporary debugging 
output$debugging <- renderPrint({ "Tab not yet available." })
