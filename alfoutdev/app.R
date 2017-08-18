# @knitr app
source("plotFunctions.R", local=TRUE) # source plotting functions

rv <- reactiveValues(buffer.size=NULL, mod.years.range=NULL, obs.years.range=NULL,
                     d.fs=NULL, rab.dat=NULL, frp.dat=NULL, fri.dat=NULL)

observeEvent(input$workspace, {
  files <- input$workspace
  objs <- c("buffersize", "mod.years.range", "obs.years.range", "d.fs", "rab.dat", "frp.dat", "fri.dat")
  tbls <- objs[4:7]
  if(is.null(files)){
    for(i in seq_along(objs)) rv[[objs[i]]] <- NULL
  } else {
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    if(length(files) == 1){
      progress$inc(message="Loading data...", amount=1)
      filename_parts <- strsplit(basename(files), "_")[[1]]
      runid <- filename_parts[1]
      rcp <- filename_parts[2]
      model <- filename_parts[3]
      if(substr(runid, 1, 3) == "fmo"){
        fmo_fs <- substr(runid, 4, 5)
        fmo_ig <- substr(runid, 7, 8)
        if(all(as.numeric(c(fmo_fs, fmo_ig)) == 0)) runid <- "SQ" else runid <- "FM1"
      } else runid <- paste(rcp, model, sep="_")
      load(file=files, envir=environment())
      for(v in objs){
        if(v %in% tbls){
          x <- mutate(get(v, environment()), Run=ifelse(Source=="Observed", "Observed", runid))
          runlev <- unique(x$Run)
          runlev2 <- unique(c("Observed", "SQ", "FM1", runlev))
          runlev <- runlev2[runlev2 %in% runlev]
          rv[[v]] <- mutate(x, Run=factor(Run, levels=runlev))
        } else rv[[v]] <- get(v, environment())
      }
    } else {
      for(j in seq_along(files)){
        progress$inc(message="Loading data...", amount=j/length(files))
        filename_parts <- strsplit(basename(files[j]), "_")[[1]]
        runid <- filename_parts[1]
        rcp <- filename_parts[2]
        model <- filename_parts[3]
        if(substr(runid, 1, 3) == "fmo"){
          fmo_fs <- substr(runid, 4, 5)
          fmo_ig <- substr(runid, 7, 8)
          if(all(as.numeric(c(fmo_fs, fmo_ig)) == 0)) runid <- "SQ"
        } else runid <- paste(rcp, model, sep="_")
        load(file=files[j], envir=environment())
        for(v in objs){
          if(v %in% tbls){
            x <- mutate(get(v, environment()), Run=ifelse(Source=="Observed", "Observed", runid)) %>%
              distinct(.keep_all = TRUE)
            if(j > 1) x <- bind_rows(rv[[v]], x)
            if(j == length(files)){
              runlev <- unique(x$Run)
              runlev2 <- unique(c("Observed", "SQ", runlev))
              runlev <- runlev2[runlev2 %in% runlev]
              x <- mutate(x, Run=factor(Run, levels=runlev))
            }
            rv[[v]] <- x
          } else rv[[v]] <- get(v, environment())
        }
      }
    }
  }
})

source("reactives.R",local=T) # Source reactive expressions and other code

# Primary plot outputs reactive expressions
# Plot RAB ~ time
doPlot_RABbyTime <- function(...){
	if(!(is.null(subjects()) || is.null(groups()) || is.null(input$buffersize))){
	plotRABbyTime(data=rv$rab.dat, buffersize=input$buffersize, subject=subjects(), grp=groups(),
        colpal=cbpalette, fontsize=16, leg.pos="top", facet.by=facetBy(), facet.scales=facetScales(), ...)
	} else NULL
}

# Plot Regional TAB ~ time
doPlot_RegTABbyTimeOrFS <- function(...){
	if(!(is.null(Reg_domain()) || is.null(Reg_subjects()) || is.null(Reg_groups()) || 
	     is.null(input$reg_vegetation) || is.null(input$reg_aggveg) || is.null(input$reg_facetcols) ||
	     (input$reg_aggveg && (Reg_groups()=="Vegetation" || (!is.null(Reg_facetBy()) && Reg_facetBy()=="Vegetation"))))){
	  plotRegTABbyTimeOrFS(data=rv$d.fs, domain=Reg_domain(), vegetation=input$reg_vegetation, agg.veg=input$reg_aggveg, 
	                       subject=Reg_subjects(), grp=Reg_groups(), colpal=cbpalette, fontsize=16, leg.pos="top", 
	                       facet.by=Reg_facetBy(), facet.cols=input$reg_facetcols, facet.scales=Reg_facetScales(), ...)
	} else NULL
}

# Plot FRP ~ buffer radius
doPlot_FRPbyBuffer <- function(){
	if(!(is.null(subjects()) || is.null(groups()) || is.null(input$minbuffersize))){
		plotFRPbyBuffer(data=rv$frp.dat, min.buffer=input$minbuffersize, subject=subjects(), grp=groups(),
			colpal=cbpalette, fontsize=16, leg.pos="top", maintitle=main.frp, xlb=xlb.frp, ylb=ylb.frp,
			facet.by=facetBy(), facet.scales=facetScales())
	} else NULL
}

# Plot FRI boxplots
doPlot_FRIboxplot <- function(){
	if(!(is.null(Boxplot_data()) || is.null(input$boxplot_X) || is.null(input$boxplot_ylim) || 
	     is.null(input$boxplot_outliers) || is.null(input$boxplot_points) ||
        is.null(input$points_alpha) || is.null(Boxplot_groups()) || 
	     is.null(input$boxplot_log) || is.null(input$boxplot_facetcols))){
		plotFRIboxplot(d=Boxplot_data(), x=input$boxplot_X, y="FRI", grp=Boxplot_groups(),
			colpal=cbpalette, Log=input$boxplot_log, ylim=input$boxplot_ylim, show.outliers=input$boxplot_outliers, 
			show.points=input$boxplot_points, pts.alpha=input$points_alpha, fontsize=16, leg.pos="top",
			facet.by=Boxplot_facetBy(), facet.cols=input$boxplot_facetcols, facet.scales=Boxplot_facetScales())
	} else NULL
}

# Primary plot reactive outputs
output$RAB_tsplot <- renderPlot({
  if(is.null(input$ts_site_rab_goButton) || input$ts_site_rab_goButton==0) return()
  isolate({ doPlot_RABbyTime(year.range=input$yearsrab) })
})

output$CRAB_tsplot <- renderPlot({
  if(is.null(input$ts_site_crab_goButton) || input$ts_site_crab_goButton==0) return()
  isolate({ doPlot_RABbyTime(year.range=input$yearscrab, cumulative=TRUE) })
})

output$RegTAB_tsplot <- renderPlot({
  if(is.null(input$ts_reg_tab_goButton) || input$ts_reg_tab_goButton==0) return()
  isolate({ doPlot_RegTABbyTimeOrFS(year.range=input$yearsrab, x="Year") })
})

output$RegCTAB_tsplot <- renderPlot({
  if(is.null(input$ts_reg_ctab_goButton) || input$ts_reg_ctab_goButton==0) return()
  isolate({ doPlot_RegTABbyTimeOrFS(year.range=input$yearscrab, x="Year", cumulative=TRUE) })
})

output$RegTAB_fsplot <- renderPlot({
  if(is.null(input$fs_reg_tab_goButton) || input$fs_reg_tab_goButton==0) return()
  isolate({ doPlot_RegTABbyTimeOrFS(year.range=input$yearsrab, x="FS") })
})

output$RegCTAB_fsplot <- renderPlot({
  if(is.null(input$fs_reg_ctab_goButton) || input$fs_reg_ctab_goButton==0) return()
  isolate({ doPlot_RegTABbyTimeOrFS(year.range=input$yearscrab, x="FS", cumulative=TRUE) })
})

output$FRP_bufferplot <- renderPlot({ doPlot_FRPbyBuffer() })

output$FRI_boxplot <- renderPlot({
  if(is.null(input$boxplot_goButton) || input$boxplot_goButton==0) return()
  isolate({ doPlot_FRIboxplot() })
})

# PDF download buttons for each plot
output$dl_RAB_tsplotPDF <- downloadHandler(
	filename='RABvsTime.pdf',
	content=function(file){	
	  pdf(file=file, width=10, height=8, pointsize=8)
	  doPlot_RABbyTime(year.range=input$yearsrab)
	  dev.off()
})

output$dl_CRAB_tsplotPDF <- downloadHandler(
	filename='CRABvsTime.pdf',
	content=function(file){	
	  pdf(file=file, width=10, height=8, pointsize=8)
	  doPlot_RABbyTime(year.range=input$yearscrab, cumulative=TRUE)
	  dev.off()
})

output$dl_RegTAB_tsplotPDF <- downloadHandler(
	filename='RegionalTABvsTime.pdf',
	content=function(file){	
	  pdf(file=file, width=10, height=8, pointsize=8)
	  doPlot_RegTABbyTimeOrFS(year.range=input$yearsrab, x="Year")
	  dev.off()
	 }
)

output$dl_RegCTAB_tsplotPDF <- downloadHandler(
	filename='RegionalCTABvsTime.pdf',
	content=function(file){	
	  pdf(file=file, width=10, height=8, pointsize=8) 
	  doPlot_RegTABbyTimeOrFS(year.range=input$yearscrab, x="Year", cumulative=TRUE)
	  dev.off()
	 }
)

output$dl_RegTAB_fsplotPDF <- downloadHandler(
  filename='RegionalTABvsFS.pdf',
  content=function(file){
    pdf(file=file, width=10, height=8, pointsize=8)
    doPlot_RegTABbyTimeOrFS(year.range=input$yearsrab, x="FS")
    dev.off()
  }
)

output$dl_RegCTAB_fsplotPDF <- downloadHandler(
  filename='RegionalCTABvsFS.pdf',
  content=function(file){
    pdf(file=file, width=10, height=8, pointsize=8)
    doPlot_RegTABbyTimeOrFS(year.range=input$yearscrab, x="FS", cumulative=TRUE)
    dev.off()
  }
)

output$dl_FRP_bufferplotPDF <- downloadHandler(
	filename='FRPvsBufferRadius.pdf',
	content=function(file){
	  pdf(file=file, width=10, height=8, pointsize=8)
	  doPlot_FRPbyBuffer()
	  dev.off()
})

output$dl_FRI_boxplotPDF <- downloadHandler(
	filename='FRIboxplots.pdf',
	content=function(file){
	  pdf(file=file, width=10, height=8, pointsize=8)
	  doPlot_FRIboxplot()
	  dev.off()
})
