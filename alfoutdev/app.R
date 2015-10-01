# @knitr app
source("plotFunctions.R",local=T) # source plotting functions

rv <- reactiveValues()

updateDataFun <- function(file){
	if(!is.null(file)){
		vars <- load(file=file, envir=.GlobalEnv)
		for(v in vars) rv[[v]] <- get(v, .GlobalEnv)
	}
}

updateData <- reactive({ updateDataFun(file=input$workspace) })

observe({ updateData() })

source("reactives.R",local=T) # Source reactive expressions and other code

# Primary plot outputs reactive expressions
# Plot RAB ~ time
doPlot_RABbyTime <- function(...){
	if(!(is.null(subjects()) || is.null(groups()) || is.null(input$buffersize) || is.null(input$facetcols))){
	plotRABbyTime(data=rv$rab.dat, buffersize=input$buffersize, subject=subjects(), grp=groups(),
        colpal=cbpalette, fontsize=16, leg.pos="top", facet.by=facetBy(), facet.cols=input$facetcols, facet.scales=facetScales(), ...)
	} else NULL
}

# Plot Regional TAB ~ time
doPlot_RegTABbyTime <- function(...){
	if(!(is.null(Reg_subjects()) || is.null(Reg_groups()) || is.null(input$reg_vegetation) || is.null(input$reg_aggveg) || is.null(input$reg_facetcols) ||
        (input$reg_aggveg && (Reg_groups()=="Vegetation" || (!is.null(Reg_facetBy()) && Reg_facetBy()=="Vegetation"))))){
	plotRegionalTABbyTime(data=rv$d.fs, vegetation=input$reg_vegetation, agg.veg=input$reg_aggveg, subject=Reg_subjects(), grp=Reg_groups(),
		colpal=cbpalette, fontsize=16, leg.pos="top", facet.by=Reg_facetBy(), facet.cols=input$reg_facetcols, facet.scales=Reg_facetScales(), ...)
	} else NULL
}

# Plot FRP ~ buffer radius
doPlot_FRPbyBuffer <- function(){
	if(!(is.null(subjects()) || is.null(groups()) || is.null(input$minbuffersize) || is.null(input$facetcols))){
		plotFRPbyBuffer(data=rv$frp.dat, min.buffer=input$minbuffersize, subject=subjects(), grp=groups(),
			colpal=cbpalette, fontsize=16, leg.pos="top", maintitle=main.frp, xlb=xlb.frp, ylb=ylb.frp,
			facet.by=facetBy(), facet.cols=input$facetcols, facet.scales=facetScales())
	} else NULL
}

# Plot FRI boxplots
doPlot_FRIboxplot <- function(){
	if(!(is.null(Boxplot_data()) || is.null(input$boxplot_X) || is.null(input$boxplot_points) || is.null(input$points_alpha) || is.null(Boxplot_groups()) || is.null(input$boxplot_log) || is.null(input$boxplot_facetcols))){
		plotFRIboxplot(d=Boxplot_data(), x=input$boxplot_X, y="FRI", grp=Boxplot_groups(),
			colpal=cbpalette, Log=input$boxplot_log, show.points=input$boxplot_points, pts.alpha=input$points_alpha, fontsize=16, leg.pos="top",
			facet.by=Boxplot_facetBy(), facet.cols=input$boxplot_facetcols, facet.scales=Boxplot_facetScales())
	} else NULL
}

# Primary plot reactive outputs
output$RAB_tsplot <- renderPlot({ doPlot_RABbyTime(year.range=input$yearsrab) }, height=function(){ 0.7*session$clientData$output_RAB_tsplot_width }, width="auto")

output$CRAB_tsplot <- renderPlot({ doPlot_RABbyTime(year.range=input$yearscrab, cumulative=TRUE) }, height=function(){ 0.7*session$clientData$output_CRAB_tsplot_width }, width="auto")

output$RegTAB_tsplot <- renderPlot({ doPlot_RegTABbyTime(year.range=input$yearsrab) }, height=function(){ 0.7*session$clientData$output_RegTAB_tsplot_width }, width="auto")

output$RegCTAB_tsplot <- renderPlot({ doPlot_RegTABbyTime(year.range=input$yearscrab, cumulative=TRUE) }, height=function(){ 0.7*session$clientData$output_RegCTAB_tsplot_width }, width="auto")

output$FRP_bufferplot <- renderPlot({ doPlot_FRPbyBuffer() }, height=function(){ 0.7*session$clientData$output_FRP_bufferplot_width }, width="auto")

output$FRI_boxplot <- renderPlot({ doPlot_FRIboxplot() }, height=function(){ 0.7*session$clientData$output_FRI_boxplot_width }, width="auto")

# PDF download buttons for each plot
output$dl_RAB_tsplotPDF <- downloadHandler(
	filename='RABvsTime.pdf',
	content=function(file){	pdf(file=file, width=10, height=8, pointsize=8); doPlot_RABbyTime(year.range=input$yearsrab); dev.off() }
)

output$dl_CRAB_tsplotPDF <- downloadHandler(
	filename='CRABvsTime.pdf',
	content=function(file){	pdf(file=file, width=10, height=8, pointsize=8); doPlot_RABbyTime(year.range=input$yearscrab, cumulative=TRUE); dev.off() }
)

output$dl_RegTAB_tsplotPDF <- downloadHandler(
	filename='RegionalTABvsTime.pdf',
	content=function(file){	pdf(file=file, width=10, height=8, pointsize=8); doPlot_RegTABbyTime(year.range=input$yearsrab); dev.off() }
)

output$dl_RegCTAB_tsplotPDF <- downloadHandler(
	filename='RegionalCTABvsTime.pdf',
	content=function(file){	pdf(file=file, width=10, height=8, pointsize=8); doPlot_RegTABbyTime(year.range=input$yearscrab, cumulative=TRUE); dev.off() }
)

output$dl_FRP_bufferplotPDF <- downloadHandler(
	filename='FRPvsBufferRadius.pdf',
	content=function(file){	pdf(file=file, width=10, height=8, pointsize=8); doPlot_FRPbyBuffer(); dev.off() }
)

output$dl_FRI_boxplotPDF <- downloadHandler(
	filename='FRIboxplots.pdf',
	content=function(file){	pdf(file=file, width=10, height=8, pointsize=8); doPlot_FRIboxplot(); dev.off() }
)
