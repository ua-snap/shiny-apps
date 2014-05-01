# Source reactive expressions and other code
source("external/appSourceFiles/reactives.R",local=T)
source("external/appSourceFiles/io.sidebar.wp1.R",local=T)
source("external/appSourceFiles/io.sidebar.wp2.R",local=T)
source("external/appSourceFiles/io.sidebar.wp3.R",local=T)
source("external/appSourceFiles/io.sidebar.wp4.R",local=T)
source("external/appSourceFiles/io.sidebar.wp5.R",local=T)
source("external/appSourceFiles/io.sidebar.wp6.R",local=T)

# Reactive expression (see reactives.R) for code tab in main panel
# Ideal, but cannot do this on the server side due to a bug in the shinyAce package.
#output$codeTab <- renderUI({ codeTab() })

output$HLTheme <- renderUI({	selectInput("hltheme", "Code highlighting theme:", getAceThemes(), selected="clouds_midnight") })
output$HLFontSize <- renderUI({ selectInput("hlfontsize", "Font size:", seq(8,24,by=2), selected=12) })

observe({
	input$tsp
	input$nlp
	input$hltheme
	for(i in 1:length(R_files)) eval(parse(text=sprintf("input$%s", gsub("\\.", "", basename(R_files[i])))))
	for(i in 1:length(R_files)) updateAceEditor(session, gsub("\\.", "", basename(R_files[i])), theme=input$hltheme, fontSize=input$hlfontsize)
})

output$CodeDescription <- renderUI({
	h6(HTML(
		'<p style="text-align:justify;">I use code externalization for more complex apps to keep the
		<strong><span style="color:#3366ff;">R</span></strong> code organized.
		The <em>Header</em>, <em>Sidebar</em>, <em>Main</em>, and <em>About</em>
		<strong><span style="color:#3366ff;">R</span></strong> scripts are sourced at the top level on the <em>UI</em> side
		while <em>app.R</em> is sourced in <em>server.R</em>.
		In turn, the <em>app.R</em> sources all of the reactive inputs/outputs/expressions
		in the remaining <strong><span style="color:#3366ff;">R</span></strong> scripts.</p>'
	))
})

output$plot1 <- renderPlot({
	if(!is.null(d()) & !is.null(input$plottype)){
		if(input$dataset!="Lorenz Attractor"){ #removes mainPanel error message when switching off of rgl type with this dataset selected
			if(plottypes_abb()[match(input$plottype,plottypes())]!="p3dGL"){
				if(input$bgcol=="Black") par(bg="black",col="white",col.lab="white",col.axis="white",col.main="white")
				doPlot()(type=plottypes_abb()[match(input$plottype,plottypes())])
			}
		}
	}
}, height=1000, width=1000)

output$plot2 <- renderWebGL({
	if(!is.null(d()) & !is.null(rgladjustrelief()) & !is.null(input$plottype) & !is.null(input$bgcol) & !is.null(rglcolors())){
		if(plottypes_abb()[match(input$plottype,plottypes())]=="p3dGL"){
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
		} else { bg3d(tolower(input$bgcol)); points3d(1,1,1) }
	} else { bg3d("black"); points3d(1,1,1) }
}, height=1000, width=1000)

output$dl_plot1PDF <- downloadHandler( # render plot to pdf for download
	filename = 'current_noninteractive_plot.pdf',
	content = function(file){
		pdf(file=file, width=12, height=12, pointsize=8)
		if(input$bgcol=="Black") par(bg="black",col="white",col.lab="white",col.axis="white",col.main="white")
		doPlot()(type=plottypes_abb()[match(input$plottype,plottypes())])
		dev.off()
	}
)

output$pageviews <-	renderText({
	if (!file.exists("pageviews.Rdata")) pageviews <- 0 else load(file="pageviews.Rdata")
	pageviews <- pageviews + 1
	save(pageviews,file="pageviews.Rdata")
	paste("Visits:",pageviews)
})
