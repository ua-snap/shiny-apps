# Datasets, scenarios, decades
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

# ggplot2 grouping, faceting, pooling
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

n.groups <- reactive({
	eval(parse(text=sprintf("length(input$%s)",short[which(long==input$group)])))
})

facet.choices <- reactive({
	if(!is.null(input$group)){
		if(length(group.choices())>1) choices <- c(group.choices()[which(!(group.choices() %in% input$group))],"None/Force Pool") else choices <- NULL
		choices
	} else return()
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

# Data subsetting
dat.sub <- reactive({
	if(input$goButton==0) return()
	isolate(
		if(!is.null(dat())){
			d <- subset(dat(), Community==strsplit(input$locationSelect,", ")[[1]][1] & Model %in% input$models & Scenario %in% input$scens & Variable %in% input$vars & Month %in% input$mos & Decade %in% substr(input$decs,1,4))
			if(input$vars=="Temperature" & input$units=="F") d$value <- round((5/9)*d$value + 32,1)
			if(input$vars=="Precipitation" & input$units=="in") d$value <- round(25.4*d$value,3)
			rownames(d) <- NULL
			d
		} else return()
	)
})

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
