# Source reactive expressions
source("reactives.R",local=T)

# Reactive expression (see reactives.R) for code tab in main panel
# Ideal, but cannot do this on the server side due to a bug in the shinyAce package.
#output$codeTab <- renderUI({ codeTab() })

#observe({
	#input$tsp
	#input$nlp
	#input$hltheme
	#for(i in 1:length(R_files)) eval(parse(text=sprintf("input$%s", gsub("\\.", "", basename(R_files[i])))))
#	for(i in 1:length(R_files)) updateAceEditor(session, gsub("\\.", "", basename(R_files[i])), theme=input$hltheme, fontSize=input$hlfontsize, readOnly=T)
#})

getStaticType <- function(type){
	switch(type,
		p2Dcontour="p2dCL",
		p2Dimage="p2dIM",
		p3Dpersp="p3dPP",
		p3Dribbon="p3dRI",
		p3Dhist="p3dHI")
}

plotStatic <- function(...){
	if(!is.null(d())){
		if(input$dataset!="Lorenz Attractor"){ #removes mainPanel error message when switching off of rgl type with this dataset selected
			if(input$bgcol=="Black") par(bg="black",col="white",col.lab="white",col.axis="white",col.main="white")
			doPlot()(...)
		} else {
			if(input$bgcol=="Black") par(bg="black",col="white",col.lab="white",col.axis="white",col.main="white")
			plot.new()
		}
	}
}

output$plot_2D_contour <- renderPlot({ plotStatic(type="p2dCL") },
	height=function(){
		w <- session$clientData$output_plot_2D_contour_width
		if(is.null(w)) return("auto") else return(w)
	}, width="auto")

output$plot_2D_image <- renderPlot({ plotStatic(type="p2dIM") },
	height=function(){
		w <- session$clientData$output_plot_2D_image_width
		if(is.null(w)) return("auto") else return(w)
	}, width="auto")

output$plot_3D_persp <- renderPlot({ plotStatic(type="p3dPP") },
	height=function(){
		w <- session$clientData$output_plot_3D_persp_width
		if(is.null(w)) return("auto") else return(w)
	}, width="auto")

output$plot_3D_ribbon <- renderPlot({ plotStatic(type="p3dRI") },
	height=function(){
		w <- session$clientData$output_plot_3D_ribbon_width
		if(is.null(w)) return("auto") else return(w)
	}, width="auto")

output$plot_3D_hist <- renderPlot({ plotStatic(type="p3dHI") },
	height=function(){
		w <- session$clientData$output_plot_3D_hist_width
		if(is.null(w)) return("auto") else return(w)
	}, width="auto")

output$plot_3D_rgl <- renderWebGL({
	if(!is.null(d()) & !is.null(rgladjustrelief()) & !is.null(input$bgcol) & !is.null(rglcolors())){
		d.new <- d()*rgladjustrelief()
		d.new <- d.new + min(d(),na.rm=T) - min(d.new,na.rm=T)
		bg3d(tolower(input$bgcol))
		rgl.viewpoint(theta=40, phi=15, fov=60, zoom=1)
		if(rgl.data.style()=="points/lines"){
			if(input$rglpointslines=="Points") rgl.points(x=d.dims()[[1]],z=d.dims()[[2]],y=d.new,color=rglcolors())
			if(input$rglpointslines=="Lines") rgl.lines(x=d.dims()[[1]],z=d.dims()[[2]],y=d.new,color=rglcolors())
		} else {
			rgl.surface(x=d.dims()[[1]],z=d.dims()[[2]],y=d.new,color=rglcolors())
		}
	} else { bg3d("black"); points3d(1,1,1) }
}, height=1000, width=1000)

output$dl_plotStaticPDF <- downloadHandler( # render plot to pdf for download
	filename = 'current_noninteractive_plot.pdf',
	content = function(file){
		pdf(file=file, width=12, height=12, pointsize=8)
		if(input$bgcol=="Black") par(bg="black",col="white",col.lab="white",col.axis="white",col.main="white")
		plotStatic(getStaticType(input$tsp))
		dev.off()
	}
)
