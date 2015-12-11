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
output$Boxplot_group_choices <- renderUI({
    x <- if(length(input$boxplot_replicates) < 7) fri_IDvars() else fri_IDvars()[fri_IDvars()!="Replicate"]
    selectInput("boxplot_grp", "Group by", choices=c("", x), selected="")
})
output$Boxplot_facetBy_choices <- renderUI({
    x <- if(length(input$boxplot_replicates) < 7) fri_IDvars() else fri_IDvars()[fri_IDvars()!="Replicate"]
    selectInput("boxplot_facetby", "Facet by", choices=x, selected="", multiple=TRUE)
})
output$Boxplot_buffer_choices <- renderUI({
    lev <- sort(unique(rv$fri.dat$Buffer_km))
    selectInput("boxplot_buffer", "Radial buffer (km)", choices=lev, selected=lev, multiple=TRUE)
})
output$Boxplot_locgroup_choices <- renderUI({
    if(!("LocGroup" %in% names(rv$fri.dat))) return()
    lev <- levels(rv$fri.dat$LocGroup)
    selectInput("boxplot_locgroup", "Location groups", choices=lev, selected=lev, multiple=TRUE)
})
output$Boxplot_replicates_choices <- renderUI({
    lev <- levels(rv$fri.dat$Replicate)
    lev <- gsub("Rep_", "", lev[lev!="Observed"])
    selectInput("boxplot_replicates", "Replicates", choices=lev, selected="", multiple=TRUE)
})
output$Boxplot_ylim <- renderUI({
    if(is.null(Boxplot_data()) || nrow(Boxplot_data())==0) return()
    x <- max(Boxplot_data()$FRI)
    if(is.null(x)) return()
    a <- input$boxplot_log
    if(!is.null(a) && a) { x <- ceiling(log(x)); b <- 1 } else { x <- x - x %% 10 + 10; b <- 10 }
    sliderInput("boxplot_ylim", "FRI axis range", 0, x, c(0, x), step=b, sep="")
})

output$TS_Site_RAB_GoButton <- renderUI({
	actionButton("ts_site_rab_goButton", "Draw Plot", icon=icon("check"), class="btn-primary btn-block")
})

output$TS_Site_CRAB_GoButton <- renderUI({
	actionButton("ts_site_crab_goButton", "Draw Plot", icon=icon("check"), class="btn-primary btn-block")
})

output$TS_Reg_TAB_GoButton <- renderUI({
	actionButton("ts_reg_tab_goButton", "Draw Plot", icon=icon("check"), class="btn-primary btn-block")
})

output$TS_Reg_CTAB_GoButton <- renderUI({
	actionButton("ts_reg_ctab_goButton", "Draw Plot", icon=icon("check"), class="btn-primary btn-block")
})

output$Boxplot_GoButton <- renderUI({
	actionButton("boxplot_goButton", "Draw Plot", icon=icon("check"), class="btn-primary btn-block")
})

# server-side reactives
fs_IDvars <- reactive({ sort(names(rv$d.fs)[!(names(rv$d.fs) %in% c("Domain", "FS", "Year"))]) })
rab_IDvars <- reactive({ sort(names(rv$rab.dat)[!(names(rv$rab.dat) %in% c("Buffer_km", "Value", "Year"))]) })
fri_IDvars <- reactive({ sort(names(rv$fri.dat)[!(names(rv$fri.dat) %in% c("Value", "FRI"))]) })

facetBy <- reactive({ if(!is.null(input$facetby) && input$facetby!="") input$facetby else NULL })

facetScales <- reactive({ if(!is.null(input$facetScalesFree) && input$facetScalesFree) "free" else NULL })

Reg_facetBy <- reactive({ if(!is.null(input$reg_facetby) && input$reg_facetby!="") input$reg_facetby else NULL })

Reg_facetScales <- reactive({ if(!is.null(input$reg_facetScalesFree) && input$reg_facetScalesFree) "free" else NULL })

subjects <- reactive({ sprintf("interaction(%s)", paste0(c("Replicate", "Location"), collapse = ", ")) })

Reg_subjects <- reactive({
    if(!is.null(input$reg_aggveg)){
        if(input$reg_aggveg) x <- sprintf("interaction(%s)", paste0(c("Domain", "Replicate"), collapse = ", "))
        if(!input$reg_aggveg) x <- sprintf("interaction(%s)", paste0(c("Domain", "Replicate", "Vegetation"), collapse = ", "))
    } else x <- NULL
	x
})

Reg_domain <- reactive({
    x <- input$reg_domain
    if(is.null(x) || x=="") c("Masked", "Full") else x
})

groups <- reactive({ if(length(input$grp)) input$grp else NULL })

Reg_groups <- reactive({ if(length(input$reg_grp)) input$reg_grp else NULL })

Boxplot_facetBy <- reactive({ if(!is.null(input$boxplot_facetby) && input$boxplot_facetby!="") input$boxplot_facetby else NULL })

Boxplot_facetScales <- reactive({ if(!is.null(input$boxplot_facetScalesFree) && input$boxplot_facetScalesFree) "free" else NULL })

Boxplot_subjects <- reactive({ if(length(input$boxplot_interact)) sprintf("interaction(%s)", paste0(input$boxplot_interact, collapse = ", ")) else NULL })

Boxplot_groups <- reactive({ if(length(input$boxplot_grp)) input$boxplot_grp else NULL })

Boxplot_data <- reactive({
    if(is.null(rv$fri.dat)) return()
    x <- !is.null(input$boxplot_observed) && input$boxplot_observed
    d <- if(x) data.table(rv$fri.dat) else filter(data.table(rv$fri.dat), Replicate!="Observed")
    if(!(is.null(input$boxplot_locgroup) || input$boxplot_locgroup=="")) d <- filter(d, LocGroup %in% input$boxplot_locgroup)
    if(!(is.null(input$boxplot_replicates) || input$boxplot_replicates=="")){
        y <- paste0("Rep_", input$boxplot_replicates)
        z <- if(x) c("Observed", y) else y
        d <- filter(d, Replicate %in% z)
    }
    filter(d, Buffer_km %in% input$boxplot_buffer)
})
