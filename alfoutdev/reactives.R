# @knitr reactives
# outputs
output$Group_choices <- renderUI({selectInput("grp", "Group by", choices=c("", rab_IDvars()[rab_IDvars()!="Replicate"]), selected="") })
output$FacetBy_choices <- renderUI({ selectInput("facetby", "Facet by", choices=rab_IDvars()[rab_IDvars()!="Replicate"], selected="", multiple=TRUE) })

output$Reg_group_choices <- renderUI({
    x <- if(!is.null(input$reg_aggveg) && input$reg_aggveg) fs_IDvars()[fs_IDvars()!="Vegetation"] else fs_IDvars()
    selectInput("reg_grp", "Group by", choices=c("", x[x!="Replicate"]), selected="")
})
output$Reg_facetBy_choices <- renderUI({
    x <- if(!is.null(input$reg_aggveg) && input$reg_aggveg) fs_IDvars()[fs_IDvars()!="Vegetation"] else fs_IDvars()
    selectInput("reg_facetby", "Facet by", choices=x[x!="Replicate"], selected="", multiple=TRUE)
})

output$Boxplot_X_choices <- renderUI({ selectInput("boxplot_X", "X-axis", choices=fri_IDvars(), selected="Source") })
output$Boxplot_group_choices <- renderUI({ selectInput("boxplot_grp", "Group by", choices=c("", fri_IDvars()[fri_IDvars()!="Replicate"]), selected="") })
output$Boxplot_facetBy_choices <- renderUI({ selectInput("boxplot_facetby", "Facet by", choices=fri_IDvars()[fri_IDvars()!="Replicate"], selected="", multiple=TRUE) })
output$Boxplot_buffer_choices <- renderUI({
    lev <- sort(unique(rv$fri.dat$Buffer_km))
    selectInput("boxplot_buffer", "Radial buffer (km)", choices=lev, selected=lev, multiple=TRUE)
})
output$Boxplot_locgroup_choices <- renderUI({
    if(!("LocGroup" %in% names(rv$fri.dat))) return()
    lev <- levels(rv$fri.dat$LocGroup)
    selectInput("boxplot_locgroup", "Location groups", choices=lev, selected=lev, multiple=TRUE)
})
output$Boxplot_ylim <- renderUI({
    x <- max(Boxplot_data()$FRI)
    x <- x - x %% 10 + 10
    sliderInput("boxplot_ylim", "FRI axis range", 0, x, c(0, x), step=10, sep="")
})

# server-side reactives
fs_IDvars <- reactive({ sort(names(rv$d.fs)[!(names(rv$d.fs) %in% c("FS", "Year"))]) })
rab_IDvars <- reactive({ sort(names(rv$rab.dat)[!(names(rv$rab.dat) %in% c("Buffer_km", "Value", "Year"))]) })
fri_IDvars <- reactive({ sort(names(rv$fri.dat)[!(names(rv$fri.dat) %in% c("Value", "FRI"))]) })

facetBy <- reactive({ if(!is.null(input$facetby) && input$facetby!="") input$facetby else NULL })

facetScales <- reactive({ if(!is.null(input$facetScalesFree) && input$facetScalesFree) "free" else NULL })

Reg_facetBy <- reactive({ if(!is.null(input$reg_facetby) && input$reg_facetby!="") input$reg_facetby else NULL })

Reg_facetScales <- reactive({ if(!is.null(input$reg_facetScalesFree) && input$reg_facetScalesFree) "free" else NULL })

subjects <- reactive({ sprintf("interaction(%s)", paste0(c("Replicate", "Location"), collapse = ", ")) })

Reg_subjects <- reactive({
    if(!is.null(input$reg_aggveg)){
        if(input$reg_aggveg) x <- sprintf("interaction(%s)", paste0(c("Replicate"), collapse = ", "))
        if(!input$reg_aggveg) x <- sprintf("interaction(%s)", paste0(c("Replicate", "Vegetation"), collapse = ", "))
    } else x <- NULL
	x
})

groups <- reactive({ if(length(input$grp)) input$grp else NULL })

Reg_groups <- reactive({ if(length(input$reg_grp)) input$reg_grp else NULL })

Boxplot_facetBy <- reactive({ if(!is.null(input$boxplot_facetby) && input$boxplot_facetby!="") input$boxplot_facetby else NULL })

Boxplot_facetScales <- reactive({ if(!is.null(input$boxplot_facetScalesFree) && input$boxplot_facetScalesFree) "free" else NULL })

Boxplot_subjects <- reactive({ if(length(input$boxplot_interact)) sprintf("interaction(%s)", paste0(input$boxplot_interact, collapse = ", ")) else NULL })

Boxplot_groups <- reactive({ if(length(input$boxplot_grp)) input$boxplot_grp else NULL })

Boxplot_data <- reactive({
    if(is.null(input$boxplot_locgroup) || input$boxplot_locgroup=="") return(filter(data.table(rv$fri.dat), Buffer_km %in% input$boxplot_buffer))
    filter(data.table(rv$fri.dat), LocGroup %in% input$boxplot_locgroup & Buffer_km %in% input$boxplot_buffer)
})
