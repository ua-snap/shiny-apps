output$dat.name <- renderUI({
	selectInput("dat.name","Data:",choices=c("CMIP3 Historical","CMIP3 Projected"),selected="CMIP3 Projected")
})

dat <- reactive({
	if(!is.null(input$dat.name)){
		if(input$dat.name=="CMIP3 Projected") dat <- AR4_CMIP3_projected_data else if(input$dat.name=="CMIP3 Historical") dat <- AR4_CMIP3_historical_data
	} else dat <- NULL
	dat
})

scennames <- reactive({
	if(!is.null(input$dat.name)){
		if(input$dat.name=="CMIP3 Projected") scennames <- scennames.list[[2]] else if(input$dat.name=="CMIP3 Historical") scennames <- scennames.list[[1]]
	} else scennames <- NULL
	scennames
})

decades <- reactive({
	if(!is.null(input$dat.name)){
		if(input$dat.name=="CMIP3 Projected") decades <- decades.list[[2]] else if(input$dat.name=="CMIP3 Historical") decades <- decades.list[[1]]
	} else decades <- NULL
	decades
})

output$vars <- renderUI({
	if(!is.null(dat()))	selectInput("vars","Climate variable:",varnames,selected=NULL)
})

output$units <- renderUI({
	if(!is.null(dat())){
		if(length(input$vars)){
			if(input$vars=="Temperature") selectInput("units","Units:",c("C","F"),selected="C") else selectInput("units","Units:",c("mm","in"),selected="mm")
		}
	}
})

output$models <- renderUI({
	if(!is.null(dat()))	selectInput("models","Climate models:",choices=modnames,selected=modnames[1],multiple=T)
})

output$scens <- renderUI({
	if(!is.null(dat()))	selectInput("scens","Emissions scenarios:",choices=scennames(),selected=scennames()[1],multiple=T)
})

output$mos <- renderUI({
	if(!is.null(dat()))	selectInput("mos","Months:",choices=mos,selected=mos[1],multiple=T)
})

output$decs <- renderUI({
	if(!is.null(dat()))	selectInput("decs","Decades:",choices=decades(),selected=decades()[1],multiple=T)
})

output$xtime <- renderUI({
	selectInput("xtime",paste(input$vars,"by:"),choices=c("Month","Decade"),selected="Month")
})

group.choices <- reactive({
	if(!is.null(input$xtime)){
		if(input$xtime=="Month") {
			ind <- which(unlist(lapply(list(input$models,input$scens,input$decs), length))>1)
			if(length(ind)) choices <- c("Model","Scenario","Decade")[ind] else choices <- NULL
		} else if(input$xtime=="Decade") {
			ind <- which(unlist(lapply(list(input$models,input$scens,input$mos), length))>1)
			if(length(ind)) choices <- c("Model","Scenario","Month")[ind] else choices <- NULL
		}
		choices
	} else return()
})

output$group <- renderUI({
	if(!is.null(group.choices())) selectInput("group","Group/color by:",choices=group.choices(),selected=group.choices()[1])
})

facet.choices <- reactive({
	if(!is.null(input$group)){
		if(length(group.choices())>1) choices <- c(group.choices()[which(!(group.choices() %in% input$group))],"None/Force Pool") else choices <- NULL
		choices
	} else return()
})

output$facet <- renderUI({
	if(!is.null(facet.choices())) selectInput("facet","Facet/panel by:",choices=facet.choices(),selected=facet.choices()[1])
})

facet.panels <- reactive({
	if(!is.null(input$facet)){
		if(input$facet!="None/Force Pool"){
			x <- short[which(long==input$facet)]
			eval(parse(text=sprintf("n <- length(input$%s)",x)))
		} else n <- NULL
	} else n <- NULL
	n
})

output$vert.facet <- renderUI({
	if(!is.null(facet.panels())) if(facet.panels()>1) checkboxInput("vert.facet","Vertical facet",value=FALSE)
})

pooled.var <- reactive({
	if(!is.null(input$group) & !is.null(input$facet)){
		if(length(group.choices())==3 | (length(group.choices())==2 & input$facet=="None/Force Pool")){
			choices <- c("Model","Scenario","Decade","Month")
			pooled.var <- choices[!(choices %in% c(input$xtime,input$group,input$facet))]
			if(length(group.choices())==2 & input$facet=="None/Force Pool") pooled.var <- pooled.var[which(pooled.var==facet.choices()[1])]
			pooled.var
		} else return()
	} else return()
})

output$pooled.var <- renderUI({
	if(!is.null(pooled.var())) HTML(paste('<div>Pooled variable: ',pooled.var(),'</div>',sep="",collapse=""))
})

output$jitterXY <- renderUI({
	checkboxInput("jitterXY","Jitter points",FALSE)
})

dat.sub <- reactive({
	if(input$goButton==0) return()
	isolate(
		if(!is.null(dat())){
			d <- subset(dat(), Community==input$locationSelect & Model %in% input$models & Scenario %in% input$scens & Variable %in% input$vars & Month %in% input$mos & Decade %in% substr(input$decs,1,4))
			if(input$vars=="Temperature" & input$units=="F") d$value <- round((5/9)*d$value + 32,1)
			if(input$vars=="Precipitation" & input$units=="in") d$value <- round(25.4*d$value,3)
			rownames(d) <- NULL
			d
		} else return()
	)
})

output$summarizeByXtitle <- renderUI({ if(!is.null(input$group)) HTML(paste('<div>Summarize by ',input$xtime,'</div>',sep="",collapse="")) })

output$yrange <- renderUI({ if(!is.null(input$group)) checkboxInput("yrange","Group range",FALSE) })

output$clbootbar <- renderUI({ if(!is.null(input$group)) checkboxInput("clbootbar","Group mean CI",FALSE) })

output$clbootsmooth <- renderUI({ if(!is.null(input$group)) checkboxInput("clbootsmooth","Confidence band",FALSE) })

dat.sub.collapseGroups <- reactive({
	if(!is.null(dat.sub()) & !is.null(input$group)){
		d <- dat.sub()
		d[input$group] <- rep("Average",nrow(dat.sub()))
		d
	} else return()
})

dat.sub.collapsePooled <- reactive({
	if(!is.null(dat.sub())){
		d <- dat.sub()
		if(!is.null(pooled.var())) for(k in 1:length(pooled.var())) d[pooled.var()[k]] <- rep("Average",nrow(dat.sub()))
		d
	} else return()
})

output$legendPos1 <- renderUI({
		if(!is.null(dat.sub())) selectInput("legendPos1","Legend position",c("Top","Right","Bottom","Left"),selected="Top")
})

output$plotFontSize <- renderUI({
		if(!is.null(dat.sub())) selectInput("plotFontSize","Font size",10:20,selected=16)
})

output$altplot <- renderUI({
	if(input$goButton==0) return()
	isolate(
		if(!is.null(dat.sub())) if(dat.sub()$Variable[1]=="Temperature") checkboxInput("altplot","Line plot",FALSE) else checkboxInput("altplot","Barplot",FALSE)
	)
})

output$bartype <- renderUI({
	if(!is.null(dat.sub())){
		styles <- c("Dodge (Grouped)","Stack (Totals)","Fill (Proportions)")
		if(!is.null(input$altplot)) if(input$altplot & dat.sub()$Variable[1]=="Precipitation") selectInput("bartype","Barplot style",styles,selected=styles[1])
	}
})

output$bardirection <- renderUI({
	if(!is.null(dat.sub())){
		directions <- c("Vertical bars","Horizontal bars")
		if(!is.null(input$altplot)) if(input$altplot & dat.sub()$Variable[1]=="Precipitation") selectInput("bardirection","Barplot orientation",directions,selected=directions[1])
	}
})

n.groups <- reactive({
	eval(parse(text=sprintf("length(input$%s)",short[which(long==input$group)])))
})

output$colorpalettes <- renderUI({
	if(!is.null(input$colorseq)){
		if(input$colorseq=="Nominal"){
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
	if(!is.null(dat.sub()) & !is.null(input$group)){
		if(n.groups()>9){
			selectInput("colorseq","Color levels",c("Evenly spaced"),selected="Evenly spaced")
		} else if(dat.sub()$Variable[1]=="Temperature" & input$group=="Month"){
			selectInput("colorseq","Color levels",c("Nominal","Increasing","Centered","Cyclic"),selected="Nominal")
		} else if(input$group!="Model"){
			selectInput("colorseq","Color levels",c("Nominal","Increasing","Centered"),selected="Nominal")
		} else selectInput("colorseq","Color levels",c("Nominal"),selected="Nominal")
	}
})

output$subset.table <- renderTable({ if(!is.null(dat.sub())) dat.sub()[1,1:6] })

doPlot1 <- source("external/doPlot1.R",local=T)$value # this plotting function is not reactive but depends on reactive elements

output$plot1 <- renderPlot({
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

output$dlCurPlot1 <- downloadHandler(
	filename = 'curPlot1.pdf',
	content = function(file){
		pdf(file = file, width=11, height=8.5)
		doPlot1(dat=dat.sub(), x=input$xtime, y="value")#(margins=c(6,6,10,2))
		dev.off()
	}
)

output$dlCurTable1 <- downloadHandler(
	filename = function() { 'curTable1.csv' },
	content = function(file) {
		write.csv(dat.sub(), file)
	}
)

output$show.gbm1.object.names.if.created.successfully <- renderPrint({ pooled.var() })
