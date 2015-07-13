# @knitr reactives
facetBy <- reactive({
	x <- NULL
	if(!is.null(input$facetby)){
		x <- input$facetby
		if(x=="") x <- NULL
	}
	x
})

reg_facetBy <- reactive({
	x <- NULL
	if(!is.null(input$reg_facetby)){
		x <- input$reg_facetby
		if(x=="") x <- NULL
	}
	x
})

subjects <- reactive({
	#if(!length(input$interact)) x <- NULL else x <- sprintf("interaction(%s)", paste0(input$interact, collapse = ", "))
    x <- sprintf("interaction(%s)", paste0(c("Replicate", "Location"), collapse = ", "))
	x
})

reg_subjects <- reactive({
	#if(!length(input$reg_interact)) x <- NULL else x <- sprintf("interaction(%s)", paste0(input$reg_interact, collapse = ", "))
    if(!is.null(input$reg_aggveg)){
        if(input$reg_aggveg) x <- sprintf("interaction(%s)", paste0(c("Replicate"), collapse = ", "))
        if(!input$reg_aggveg) x <- sprintf("interaction(%s)", paste0(c("Replicate", "Vegetation"), collapse = ", "))
    } else x <- NULL
	x
})

groups <- reactive({
	if(!length(input$grp)) x <- NULL else x <- input$grp
	x
})

reg_groups <- reactive({
	if(!length(input$reg_grp)) x <- NULL else x <- input$reg_grp
	x
})

Boxplot_facetBy <- reactive({
	x <- NULL
	if(!is.null(input$boxplot_facetby)){
		x <- input$boxplot_facetby
		if(x=="") x <- NULL
	}
	x
})

Boxplot_subjects <- reactive({
	if(!length(input$boxplot_interact)) x <- NULL else x <- sprintf("interaction(%s)", paste0(input$boxplot_interact, collapse = ", "))
	x
})

Boxplot_groups <- reactive({
	if(!length(input$boxplot_grp)) x <- NULL else x <- input$boxplot_grp
	x
})
