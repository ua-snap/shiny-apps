output$colorpalettes <- renderUI({
	if(is.null(input$plotButton) || input$plotButton==0) return()
	if(!is.null(input$colorseq)){
		if(input$colorseq=="Nominal" & is.null(input$group)){
			pal <- c("Accent","Dark2","Pastel1","Pastel2","Paired","Set1","Set2","Set3")
		} else if(input$colorseq=="Nominal"){
			pal <- c("Accent","Dark2","Pastel1","Pastel2","Paired","Set1","Set2","Set3")
			if(n.groups()<=7) pal <- c("CB-friendly",pal)
			if(!is.null(input$altplot)) if(input$altplot & dat.sub()$Variable[1]=="Precipitation") pal <- paste(rep(pal,each=2),c("fill","border")) 
		} else if(input$colorseq=="Evenly spaced"){
			if(n.groups()>9) pal <- "HCL: 9+ levels"
			if(!is.null(input$altplot)) if(input$altplot & dat.sub()$Variable[1]=="Precipitation") pal <- paste(rep(pal,each=2),c("fill","border")) 
		} else if(input$colorseq=="Increasing"){
			pal <- c("Blues","BuGn","BuPu","GnBu","Greens","Greys","Oranges","OrRd","PuBu","PuBuGn","PuRd","Purples","RdPu","Reds","YlGn","YlGnBu","YlOrBr","YlOrRd")
		} else if(input$colorseq=="Centered"){
			pal <- c("BrBG","PiYG","PRGn","PuOr","RdBu","RdGy","RdYlBu","RdYlGn","Spectral")
		}
		if(input$colorseq=="Cyclic"){
			pal <- c("Yellow-Red","Blue-Orange","Brown-Orange","Blue-Red")
		}
		selectInput("colorpalettes","Color palette",pal,selected=pal[1])
	}
})

output$colorseq <- renderUI({
	if(is.null(input$plotButton) || input$plotButton==0) return()
	if(!is.null(dat.sub()) & !is.null(input$group)){
		if(n.groups()>9){
			selectInput("colorseq","Color levels",c("Evenly spaced"),selected="Evenly spaced")
		} else if(dat.sub()$Variable[1]=="Temperature" & input$group=="Month"){
			selectInput("colorseq","Color levels",c("Nominal","Increasing","Centered","Cyclic"),selected="Nominal")
		} else if(input$group!="Model"){
			selectInput("colorseq","Color levels",c("Nominal","Increasing","Centered"),selected="Nominal")
		} else selectInput("colorseq","Color levels",c("Nominal"),selected="Nominal")
	} else if(!is.null(dat.sub())) selectInput("colorseq","Color levels",c("Nominal"),selected="Nominal")
})

output$legendPos1 <- renderUI({
	if(is.null(input$plotButton) || input$plotButton==0) return()
	if(!is.null(dat.sub())) selectInput("legendPos1","Legend position",c("Top","Right","Bottom","Left"),selected="Top")
})

output$plotFontSize <- renderUI({
	if(is.null(input$plotButton) || input$plotButton==0) return()
	if(!is.null(dat.sub())) selectInput("plotFontSize","Font size",seq(12,24,by=2),selected=16)
})

output$bartype <- renderUI({
	if(is.null(input$plotButton) || input$plotButton==0) return()
	if(!is.null(dat.sub())){
		styles <- c("Dodge (Grouped)","Stack (Totals)","Fill (Proportions)")
		if(!is.null(input$altplot)) if(input$altplot & dat.sub()$Variable[1]=="Precipitation") selectInput("bartype","Barplot style",styles,selected=styles[1])
	}
})

output$bardirection <- renderUI({
	if(is.null(input$plotButton) || input$plotButton==0) return()
	if(!is.null(dat.sub())){
		directions <- c("Vertical bars","Horizontal bars")
		if(!is.null(input$altplot)) if(input$altplot & dat.sub()$Variable[1]=="Precipitation") selectInput("bardirection","Barplot orientation",directions,selected=directions[1])
	}
})

output$subset.table <- renderTable({
	if(is.null(input$plotButton) || input$plotButton==0) return()
	if(!is.null(dat.sub())) dat.sub()[1,1:6]
})
