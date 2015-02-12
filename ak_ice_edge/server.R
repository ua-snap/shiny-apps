lapply(list("shiny", "raster", "rasterVis", "png", "gridExtra"), function(x) library(x, character.only=T))

logo <- readPNG("www/img/SNAP_acronym_100px.png")
logo.alpha <- 1
logo.mat <- matrix(rgb(logo[,,1],logo[,,2],logo[,,3],logo[,,4]*logo.alpha), nrow=dim(logo)[1])

shinyServer(function(input, output, session){

output$Compare <- renderUI({
	vars <- c("Decade", "Month")
	vars <- vars[-which(vars == input$color_by)]
	selectInput("compare", "Secondary variable", choices=c("", vars), selected="", width="100%")
})

Decades <- reactive({
	decades <- input$decades
	if(input$color_by=="Month"){
		decades <- decades[1:(min(length(decades), 2))] # Cannot exceed two decades if not coloring by decade; truncated to first two
		if(!length(input$compare) || input$compare!="Decade") decades <- decades[1] # If no comparison variable selected, truncate secondary variable to first only
	}
	decades
})

Months_Int <- reactive({
	mos.int <- match(input$months_abb, month.abb)
	if(input$color_by=="Decade"){
		mos.int <- mos.int[1:(min(length(mos.int), 2))] # Cannot exceed two months if not coloring by month; truncated to first two
		if(!length(input$compare) || input$compare!="Month") mos.int <- mos.int[1] # If no comparison variable selected, truncate secondary variable to first only
	}
	mos.int
})

Mos <- reactive({ c(paste0("0", 1:9), 10:12)[Months_Int()] })

Mos_Abb <- reactive({ month.abb[Months_Int()] })

ncols <- reactive({ if(input$color_by=="Decade") length(Mos()) else length(Decades()) })

nrows <- reactive({ if(input$color_by=="Decade") length(Decades()) else length(Mos()) })

SLDF_names <- reactive({
	if(input$color_by=="Decade") {
		x <- paste("line", rep(Mos(), each=nrows()), rep(Decades(), ncols()), sep=".")
	} else {
		x <- paste("line", rep(Mos(), ncols()), rep(Decades(), each=nrows()), sep=".")
	}
	x <- substr(x, 1, nchar(x)-1)
	x
})

SLDF_annual_names <- reactive({
	if(input$color_by=="Decade") {
		x <- paste("annual.lines", rep(Mos(), each=nrows()), rep(Decades(), ncols()), sep=".")
	} else {
		x <- paste("annual.lines", rep(Mos(), ncols()), rep(Decades(), each=nrows()), sep=".")
	}
	x <- substr(x, 1, nchar(x)-1)
	x
})

Main_title <- reactive({ if(input$include_annual) "Annual and Mean Decadal 15% Sea Ice Concentration Edges" else "Mean Decadal 15% Sea Ice Concentration Edge" })

Key_title <- reactive({
	if(input$color_by=="Decade"){ # Designed for up to two columns in the plot key
		if(ncols()==1) keytitle <- eval(substitute(expression(bolditalic(x)), list(x=Mos_Abb()[1])))
		if(ncols()==2) keytitle <- eval(substitute(expression(bolditalic(x~~~~~~~~~~~~~~y~~"")), list(x=Mos_Abb()[1], y=Mos_Abb()[2])))
	} else if(input$color_by=="Month") {
		if(ncols()==1) keytitle <- eval(substitute(expression(bolditalic(x)), list(x=as.character(Decades()[1]))))
		if(ncols()==2) keytitle <- eval(substitute(expression(bolditalic(""~~x~~~~~~y~~"")), list(x=Decades()[1], y=Decades()[2])))
	}
	keytitle
})

Key_text <- reactive({ if(input$color_by=="Decade") list(rep(Decades(), ncols())) else list(rep(Mos_Abb(), ncols())) })

Colors <- reactive({
	n <- nrows()
	colpal <- strsplit(input$colpal, " \\[")[[1]][1]
	ind <- which(rownames(brewer.pal.info)==colpal)
	maxcol <- brewer.pal.info$maxcolors[ind]
	type <- brewer.pal.info$category[ind]
	x <- if(type=="qual") rep(rev(brewer.pal(maxcol, colpal)), length=n) else colorRampPalette(rev(brewer.pal(maxcol, colpal)))(n+1)
	if(type=="div") x <- x[-round(median(1:n))] else if(type=="seq")  x <- x[-(n+1)]
	x
})

doPlot_plotMap <- function(...){
	if(!(is.na(Mos()[1]) | !length(Decades()) | is.null(nrows()) | is.null(ncols()) | is.null(Key_text()) | is.null(Key_title()) | is.null(SLDF_names()) | is.null(input$include_annual))){
		plotMap(r=r3, nr=nrows(), nc=ncols(), key.text=Key_text(), key.title=Key_title(), sldf.names=SLDF_names(), sldf.annual.names=SLDF_annual_names(), annual=input$include_annual, clrs=Colors(), main.title=Main_title(), ...)
	} else NULL
}

# Currently allowing download as PNG only
plotMap <- function(r, nr, nc, key.text, key.title, sldf.names, sldf.annual.names, annual=FALSE, clrs, main.title="Plot", PDF=FALSE, PNG=FALSE, filename=NULL, show.logo=F, logo.mat=NULL, verbose=TRUE){
	if(verbose){
		prog.max <- 2+2*nr+1+3+3
		progress <- Progress$new(session, min=1, max=prog.max)
		on.exit(progress$close())
		progress$set(message="Generating plot, please wait", detail="Initializing levelplot...", value=1)
	}
	keycex <- if(PDF | PNG) 0.6 else 1.0
	keycextitle <- if(PDF | PNG) 0.7 else 1.2
	if(PDF | PNG) { main.title2 <- main.title; main.title <- "" }
	if(PNG) { pad <- -8; maincex <- 0.7 } else {pad <- 0; maincex <- 1.5 }
	if(PNG) png(filename, width=2000, height=1800, res=300)
	p <- levelplot(r, maxpixels = ncell(r/10),
		main=list(label=main.title, cex=maincex),
		sub=list(label=expression(italic("Edges are estimated 15% contour lines for mean decadal sea ice concentration.")), cex=maincex),
		panel=panel.levelplot.raster,
		par.settings=modifyList(theme1, list( superpose.symbol=list(col=clrs, lty=1, lwd=1, fill="white"), layout.heights=list(top.padding=pad, bottom.padding=pad/1.25) )),
		key=list(
			x=1-0.05*(nrow(r)/ncol(r)), y=0.05, corner=c(1, 0), size=3,
			lines=list(lty=rep(c(1,2),each=nr)[1:(nr*nc)], lwd=2, col=clrs),
			text=key.text,
			fontfamily=font.fam,
			background="white", border="black", padding.text=2,
			cex=keycex, cex.title=keycextitle, lines.title=1.5, columns=nc, between=1, between.columns=0, fontface=2, adj=text.adjust, reverse.rows=F, title=key.title),
		scales=list(draw=F), margin=FALSE, colorkey=F,
	)
	if(verbose) progress$set(message="Generating plot, please wait", detail="Adding layers: ice edges...", value=2)
	if(annual){
		for(i in 1:nr){ # Add annual lines
			if(verbose)progress$set(message="Adding annual ice edges", detail=paste("decade(s)", i, "of", nr, "..."), value=2+i)
			#Sys.sleep(0.2)
			p <- p + layer(sp.lines(x, col=clrs[i], lwd=1, alpha=0.5), data=list(x=get(sldf.annual.names[i]), clrs=clrs, i=i))
			if(nc>1) p <- p + layer(sp.lines(x, col=clrs[i], lwd=1, lty=5, alpha=0.5), data=list(x=get(sldf.annual.names[i+nr]), clrs=clrs, i=i))
		}
	}
	if(verbose) progress$set(message="Generating plot, please wait", detail="Adding layers: ice edges...", value=2+nr+1)
	for(i in 1:nr){ # Add decadal lines
		if(verbose) progress$set(message="Adding decadal ice edges", detail=paste("decade(s)", i, "of", nr, "..."), value=2+nr+1+i)
		#Sys.sleep(0.2)
		p <- p + layer(sp.lines(x, col=clrs[i], lwd=2), data=list(x=get(sldf.names[i]), clrs=clrs, i=i))
		if(nc>1) p <- p + layer(sp.lines(x, col=clrs[i], lwd=2, lty=5), data=list(x=get(sldf.names[i+nr]), clrs=clrs, i=i))
	}
	# Overlay "background"
	for(i in 1:3){
		if(verbose) progress$set(message="Generating plot, please wait", detail="Adding geographic overlays...", value=2+2*nr+1+i)
		p <- p + layer(sp.polygons(x, col=col[i], fill=fill[i], lwd=lwd[i]), data=list(x=get(shape.names[i]), i=i, col=shape.col, fill=shape.fill, lwd=shape.lwd))
	}
	if(verbose) progress$set(message="Generating plot, please wait", detail="Adding geographic overlays...", value=2+2*nr+1+3+1)
	p <- p + layer(sp.lines(sldf.sic.box, col="black", lwd=2, lty=2)) # sea ice data extent
	
	if(show.logo){
		grid.bot <- arrangeGrob(textGrob(""), p, textGrob(""), ncol=3, widths=c(1/100,98/100,1/100))
		grid.top <- arrangeGrob(
			textGrob(""),
			textGrob(bquote(.(main.title2)), x=unit(0.075,"npc"), y=unit(0.5,"npc"), gp=gpar(fontsize=10), just=c("left")),
			rasterGrob(logo.mat, x=unit(0.85,"npc"), y=unit(0.5,"npc"), just=c("right")),
			textGrob(""),
			widths=c(1/100, 0.7, 0.3, 1/100), ncol=4)
		p <- grid.arrange(textGrob(""), grid.top, grid.bot, textGrob(""), heights=c(1/100,1/20,19/20,1/100), ncol=1)
	}
	if(verbose) progress$set(message="Generating plot, please wait", detail="Finalizing...", value=2+2*nr+1+3+2)
	print(p)
	if(verbose) progress$set(message="Generating plot, please wait", detail="Complete.", value=2+2*nr+1+3+3)
	if(PNG) dev.off()
}

output$PlotMap <- renderPlot({
	if(input$plot_button == 0) return(NULL)
	isolate({ doPlot_plotMap() })
	}, height=function(){ w <- session$clientData$output_PlotMap_width; if(length(w)) return(round(0.8*w)) else return("auto") }, width="auto")

#output$dlCurPlot1_PDF <- downloadHandler(
#	filename='Estimated_15pct_SIC_Edges_Map.pdf',
#	content=function(file){ pdf(file=file, width=1*10, height=1*8, pointsize=12, onefile=FALSE); doPlot_plotMap(PDF=T, show.logo=T, logo.mat=logo.mat, verbose=F); dev.off() }
#)

output$dlCurPlot1_PNG <- downloadHandler(
	filename = 'Estimated_15pct_SIC_Edges_Map.png',
	content = function(filename){ doPlot_plotMap(filename=filename, PNG=T, show.logo=T, logo.mat=logo.mat, verbose=F) },
	contentType = 'image/png'
)

})