# Source reactive expressions and other code
source("external/appSourceFiles/reactives.R",local=T) # source reactive expressions
source("external/appSourceFiles/iosidebarwp1.R",local=T) # source input/output objects associated with sidebar wellPanel 1
source("external/appSourceFiles/iosidebarwp2.R",local=T) # source input/output objects associated with sidebar wellPanel 2

#### The is doesn't really do anything but issue system calls to another server,
#### Hence the lack of central code typically found here.

# Reactive expression (see reactives.R) for code tab in main panel
# Ideal, but cannot do this on the server side due to a bug in the shinyAce package.
#output$codeTab <- renderUI({ codeTab() })

output$HLTheme <- renderUI({ selectInput("hltheme", "Code highlighting theme:", getAceThemes(), selected="clouds_midnight") })
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

output$pageviews <-	renderText({
	if (!file.exists("pageviews.Rdata")) pageviews <- 0 else load(file="pageviews.Rdata")
	pageviews <- pageviews + 1
	save(pageviews,file="pageviews.Rdata")
	paste("Visits:",pageviews)
})
