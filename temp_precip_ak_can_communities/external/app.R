output$dat.name <- renderUI({
	selectInput("dat.name","Data:",choices="Projected",selected="Projected")
})

dat <- reactive({
	if(!is.null(input$dat.name)){
		if(input$dat.name=="Projected"){
			dat <- d
		} else dat <- NULL
	} else dat <- NULL
	dat
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
	if(!is.null(dat()))	selectInput("scens","Emissions scenarios:",choices=scennames,selected=scennames[1],multiple=T)
})

output$mos <- renderUI({
	if(!is.null(dat()))	selectInput("mos","Months:",choices=mos,selected=mos[1],multiple=T)
})

output$decs <- renderUI({
	if(!is.null(dat()))	selectInput("decs","Decades:",choices=decades,selected=decades[1],multiple=T)
})

## Display options wellPanel inputs
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
		if(length(group.choices())>1) choices <- group.choices()[which(!(group.choices() %in% input$group))] else choices <- NULL
		choices
	} else return()
})

output$facet <- renderUI({
	if(!is.null(facet.choices())) selectInput("facet","Facet/panel by:",choices=facet.choices(),selected=facet.choices()[1])
})

facet.panels <- reactive({
	if(!is.null(input$facet)){
		x <- short[which(long==input$facet)]
		eval(parse(text=sprintf("n <- length(input$%s)",x)))
	} else n <- NULL
	n
})

output$vert.facet <- renderUI({
	if(!is.null(facet.panels())) if(facet.panels()>1) checkboxInput("vert.facet","Vertical facet",value=FALSE)
})

pooled.var <- reactive({
	if(!is.null(input$group) & !is.null(input$facet)){
		if(length(group.choices())==3){
			choices <- c("Model","Scenario","Decade","Month")
			pooled.var <- choices[!(choices %in% c(input$xtime,input$group,input$facet))]
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

#output$locationSelect <- renderUI({
#	if(!is.null(dat())) selectInput(inputId = "locationSelect", label = "Select a community:", choices = communities, selected = NULL)
#})

#mo.ind <- reactive({ monums[match(input$mos,mos)] })

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
		if(!is.null(pooled.var())) d[pooled.var()] <- rep("Average",nrow(dat.sub()))
		d
	} else return()
})

output$altplot <- renderUI({
	if(input$goButton==0) return()
	isolate(
		if(!is.null(input$vars)) if(input$vars=="Temperature") checkboxInput("altplot","Line plot",FALSE) else checkboxInput("altplot","Barplot",FALSE)
	)
})

output$bartype <- renderUI({
	if(!is.null(dat.sub())){
		styles <- c("Dodge (Grouped)","Stack (Totals)","Fill (Proportions)")
		if(!is.null(input$altplot)) if(input$altplot & input$vars=="Precipitation") selectInput("bartype","Barplot style",styles,selected=styles[1])
	}
})

output$bardirection <- renderUI({
	if(!is.null(dat.sub())){
		directions <- c("Vertical bars","Horizontal bars")
		if(!is.null(input$altplot)) if(input$altplot & input$vars=="Precipitation") selectInput("bardirection","Barplot orientation",directions,selected=directions[1])
	}
})

#output$colorpalettes <- renderUI({
#	if(!is.null(input$colorseq)){
#		if(input$colorseq=="Nominal"){
#			pal <- c("CB-friendly","ggplot2")
#			if(!is.null(input$altplot)) if(input$altplot & input$vars=="Precipitation") pal <- c("CB-friendly fill","CB-friendly border","ggplot2 fill","ggplot2 border")
#		} else if(input$colorseq=="Ordinal"){
#			if(input$vars=="Precipitation") pal <- c("Lightblue-Darkblue","Brown-Green","Gray-Blue","Orange-Blue") else pal <- c("Yellow-Red","Blue-Orange","Brown-Orange","Blue-Red")
#		}
#		selectInput("colorpalettes","Color palette",pal,selected=pal[1])
#	}
#})

n.groups <- reactive({
	eval(parse(text=sprintf("length(input$%s)",short[which(long==input$group)])))
})

output$colorpalettes <- renderUI({
	if(!is.null(input$colorseq)){
		if(input$colorseq=="Nominal"){
			pal <- c("Accent","Dark2","Pastel1","Pastel2","Paired","Set1","Set2","Set3")
			if(n.groups()<=7) pal <- c("CB-friendly",pal)
			if(!is.null(input$altplot)) if(input$altplot & input$vars=="Precipitation") pal <- paste(rep(pal,each=2),c("fill","border")) 
		} else if(input$colorseq=="Evenly spaced"){
			if(n.groups()>9) pal <- "HCL: 9+ levels"
			if(!is.null(input$altplot)) if(input$altplot & input$vars=="Precipitation") pal <- paste(rep(pal,each=2),c("fill","border")) 
		} else if(input$colorseq=="Increasing"){
			#if(input$vars=="Precipitation") pal <- c("Lightblue-Darkblue","Brown-Green","Gray-Blue","Orange-Blue") else pal <- c("Yellow-Red","Blue-Orange","Brown-Orange","Blue-Red")
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

#output$cyclical <- renderUI({
#	if(!is.null(dat.sub()) & !is.null(input$group)) if(input$vars=="Temperature" & input$group=="Month") checkboxInput("cyclical","Cyclical/seasonal colors",FALSE)
#})

output$colorseq <- renderUI({
	if(!is.null(dat.sub()) & !is.null(input$group)){
		if(n.groups()>9){
			selectInput("colorseq","Color levels",c("Evenly spaced"),selected="Evenly spaced")
		} else if(input$vars=="Temperature" & input$group=="Month"){
			selectInput("colorseq","Color levels",c("Nominal","Increasing","Centered","Cyclic"),selected="Nominal")
		} else if(input$group!="Model"){
			selectInput("colorseq","Color levels",c("Nominal","Increasing","Centered"),selected="Nominal")
		} else selectInput("colorseq","Color levels",c("Nominal"),selected="Nominal")
	}
})

colorsHCL <- function(n) hcl(h=seq(0,(n-1)/(n),length=n)*360,c=100,l=65,fixup=TRUE)

doPlot.lp <- function(dat,x,y,facet.cols=min(facet.panels(),3)){
	scm <- sfm <- FALSE
	bar.pos <- "dodge"
	if(!is.null(dat.sub()) & !is.null(input$colorpalettes)){
		if(input$jitterXY) point.pos <- "jitter" else point.pos <- "identity"
		if(!is.null(input$bartype) & !is.null(input$altplot)) if(input$altplot) bar.pos <- tolower(strsplit(input$bartype," ")[[1]])
		color <- fill <- input$group
		x1 <- !length(grep("friendly",input$colorpalettes))
		if(x1){
			x1 <- length(grep("border",input$colorpalettes))
			if(x1) fill <- NULL	
		} else {
			scm <- sfm <- TRUE
			x1 <- length(grep("border",input$colorpalettes))
			if(x1) fill <- NULL
		}
		if(length(input$vert.facet)) if(input$vert.facet) facet.cols <- 1
		g <- ggplot(dat, aes_string(x=x,y=y,group=input$group,colour=color,fill=fill))
		if(input$colorseq=="Nominal"){
			if(scm) g <- g + scale_colour_manual(values=cbpalette)
			if(sfm) g <- g + scale_fill_manual(values=cbpalette)
		}
		if(!scm & !sfm){
			if(input$colorseq=="Cyclic"){
				if(input$colorpalettes %in% c("Yellow-Red","Blue-Orange","Brown-Orange","Blue-Red")){
					colorcycle <- rep(strsplit(tolower(input$colorpalettes),"-")[[1]],2)[-4]
					g <- g + scale_colour_manual( values=colorRampPalette(colorcycle)(length(input$mos)) )
					g <- g + scale_fill_manual( values=colorRampPalette(colorcycle)(length(input$mos)) )
				}
			}
			if(substr(input$colorpalettes,1,3)=="HCL"){
				g <- g + scale_color_manual(values=colorsHCL(n.groups())) + scale_fill_manual(values=colorsHCL(n.groups()))
				} else {
					g <- g + scale_color_brewer(palette=strsplit(input$colorpalettes," ")[[1]][1]) + scale_fill_brewer(palette=strsplit(input$colorpalettes," ")[[1]][1])
			}
		}
		if(!is.null(input$facet)) g <- g + facet_wrap(as.formula(paste("~",input$facet)), ncol=facet.cols)
		if(!is.null(input$altplot)){
			if(input$altplot){
				if(input$vars=="Temperature"){
					g <- g +  geom_point(position=point.pos) + stat_summary(aes_string(group=input$group),fun.y=mean, geom="line")
				} else if(input$vars=="Precipitation"){
					if(is.null(fill)){
						g <- g + stat_summary(data=dat.sub.collapsePooled(),aes_string(group=input$group),fun.y=mean, geom="bar", position=bar.pos)
					} else {
						g <- g + stat_summary(data=dat.sub.collapsePooled(),aes_string(group=input$group),fun.y=mean, geom="bar", position=bar.pos,colour="black")
					}
					if(!is.null(input$bardirection)) if(input$bardirection=="Horizontal bars") g <- g + coord_flip()
				}
			} else g <- g + geom_point(position=point.pos)
		} else g <- g + geom_point(position=point.pos)
		if(!is.null(input$yrange)) if(input$yrange) g <- g + stat_summary(aes_string(group=input$xtime), fun.y=mean, fun.ymin=min, fun.ymax=max, geom="errorbar", colour="black")
		if(!is.null(input$clbootbar)) if(input$clbootbar) g <- g + stat_summary(aes_string(group=input$xtime), fun.data="mean_cl_boot", geom="crossbar", colour="black")
		if(!is.null(input$clbootsmooth)){
			if(input$clbootsmooth){
				#if(scm){
				#	g <- g + scale_colour_manual(values=c("#000000",cbpalette), guide=FALSE) + scale_fill_manual(values=c("#999999",cbpalette))
				#} else {
				#	g <- g + scale_colour_discrete(guide=FALSE) + scale_fill_discrete()
				#}
				if(!is.null(pooled.var())){
					g <- g + stat_summary(data=dat.sub.collapsePooled(), fun.data="mean_cl_boot", geom="smooth")
				}
				g <- g + stat_summary(data=dat.sub.collapseGroups(), fun.data="mean_cl_boot", geom="smooth", colour="black", fill="black")
			}
		}
		print(g)
	} else plot(0,0,type="n",axes=F,xlab="",ylab="")
}

output$subset.table <- renderTable({ if(!is.null(dat.sub())) dat.sub() })

output$no.vars.selected <- renderUI({
	HTML(paste('<div>','Select at least one explanatory variable to use gradient boosting to estimate the response.','</div>',sep="",collapse=""))
})

output$plot.lp <- renderPlot({
		input$goButton
		input$updateButton
		input$colorpalettes
		input$altplot
		input$bartype
		input$bardirection
		isolate( doPlot.lp(dat=dat.sub(), x=input$xtime, y="value") )
}, height=600, width=1000)

output$show.gbm1.object.names.if.created.successfully <- renderPrint({ input$colorpalettes }) #eval(parse(text=sprintf("length(input$%s)",input$facet))) })# %in% dat()$Community }) #names(dat.sub()) })
