tsPlot <- function(x, w, i, yrs, decadal = FALSE, v1name, v2name, cex1, mn, xlb, ylb, ...){
  clrs <- c("orange", "dodgerblue")
  seq.dec <- yrs
  seq.yrs <- yrs[1]:(tail(yrs, 1) + 9)
  par(mar = c(4, 5, 4, 1))
  if(!decadal){ # annual plot
    plot(x, w, type = "l", ylim = c(0, 1.15), yaxs = "i", lwd = 4, col = clrs[1], cex.main = cex1, 
         cex.lab = cex1, cex.axis = cex1, main = mn, xlab = xlb, ylab = ylb)
    lines(x, i, lwd = 4, col = clrs[2])
    legend("topright", c(v1name, v2name), lwd = 4, col = clrs, bty = "n", horiz = T, seg.len = 3, 
           cex = cex1*0.75, pt.lwd = 4)
  } else { # decadal plot
    xlabels <- paste0(seq.dec, "s")
    barplot(rbind(w, i), ylim = c(0, 1.15), yaxs = "i", beside = T, col = clrs, legend = c(v1name, v2name), 
            cex.main = cex1, cex.lab = cex1, cex.names = cex1, cex.axis = cex1, main = mn, xlab = xlb, 
            ylab = ylb, axis.lty = 1, args.legend = list(x = "topright", bty = "n", horiz = T, cex = cex1*0.75), ...)
    axis(1, at = seq(2, 3*length(xlabels), by = 3), labels = xlabels, cex.axis = cex1, cex.lab = cex1)
    box()
  }
}

shinyServer(function(input, output, session){
  # Datasets, variables
  yrs <- reactive({
    seq(input$yrs[1], input$yrs[2], by = 10)
  })
  
  suffix <- reactive({
    if(!is.null(input$coast)){
      if(input$coast == "Full sea") {
        x <- "" 
      } else {
        if(input$coast == "Coastal only") x <- ".c"
      }
    } else {
      x <- NULL
    }
    x
  })
  
  ice.dat <- reactive({
    if(!is.null(suffix())){
      x <- subset(get(paste0("i.", tolower(input$sea), suffix())), 
                  Year >=  yrs()[1] & Year < as.numeric(tail(yrs(), 1)) + 10, c("Year", input$mo))
    } else x <- NULL
    x
  })
  
  wind.dat <- reactive({
    if(!is.null(suffix())){
      if(input$var!= "Wind") v <- as.numeric(input$cut) else v <- abs(as.numeric(input$cut))
      x <- subset(get(paste0("w.", tolower(input$sea), ".", input$mod, suffix())), 
                  Year >= yrs()[1] & Year < as.numeric(tail(yrs(), 1)) + 10 & 
                    Month == input$mo & RCP == input$rcp & Var == input$var & Cut == v, c("Year", "Freq"))
    } else x <- NULL
    x
  })
  
  dpm.tmp <- reactive({
    if(!is.null(wind.dat())){
      x <- rep(dpm[which(month.abb == input$mo)], nrow(wind.dat()))
      if(input$mo == "Feb") x[wind.dat()$Year %in% seq(1960, 2099, 4)] <- 29
    } else x <- NULL
    x
  })
  
  i.prop.yrs <- reactive({
    x <- NULL
    if(!is.null(ice.dat())){
      x <- ice.dat()
      names(x)[2] <- "Con"
      x$Con <- x$Con / 100
    }
    x
  })
  
  i.prop.dec <- reactive({
    y <- NULL
    if(!is.null(i.prop.yrs())){
      x <- i.prop.yrs()
      y <- tapply(x$Con, substr(x$Year, 1, 3), mean)
      y <- data.frame(Year = 10 * as.numeric(names(y)), Con = as.numeric(y))
    }
    y
  })
  
  w.prop.yrs <- reactive({
    x <- NULL
    if(!is.null(wind.dat())){
      x <- wind.dat()
      x$Freq <- if(input$direction == "Above") x$Freq / dpm.tmp() else if(input$direction == "Below") 1 - x$Freq / dpm.tmp()
    }
    x
  })
  
  w.prop.dec <- reactive({
    y <- NULL
    if(!is.null(w.prop.yrs())){
      x <- w.prop.yrs()
      y <- tapply(x$Freq, substr(x$Year, 1, 3), mean)
      y <- data.frame(Year = 10 * as.numeric(names(y)), Freq = as.numeric(y))
    }
    y
  })
  
  # Additional setup
  wind.cut <- reactive({ if(input$var != "Wind") input$cut else abs(as.numeric(input$cut)) })
  varname <- reactive({ if(input$var != "Wind") input$var else tolower(input$var) })
  main.prefix <- reactive({ if(input$coast == "Coastal only") "Coastal " else "" })
  ylab.ann <- "Annual concentration / fraction"
  main.ann <- reactive({paste0(main.prefix(), input$sea, " annual ", input$mo, 
                               ". sea ice concentration and fraction of days with ", varname(), "s > ", wind.cut(), " m/s") })
  ylab.dec <- "Decadal mean concentration / fraction"
  main.dec <- reactive({ paste0(main.prefix(), input$sea, " decadal mean ", input$mo, 
                                ". sea ice concentration and fraction of days with ", varname(), "s > ", wind.cut(), " m/s") })
  cex <- 1.3
  
  # Primary outputs
  # Plot class error and confusion matrix
  output$plotByYear <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
    if(!is.null(w.prop.dec()) & !is.null(i.prop.dec())){
      tsPlot(w.prop.yrs()$Year, w.prop.yrs()$Freq, i.prop.yrs()$Con, yrs(), 
             v1name = paste(input$mod, input$rcp, input$var), v2name = "Composite RCP 8.5 Sea ice", cex1 = cex, 
             xlb = "Year", ylb = ylab.ann, mn = main.ann())
    }
  }, height = function(){ w <- session$clientData$output_plotByYear_width; round((1/3)*w)	}, width = "auto")
  
  output$dl_plotByYear <- downloadHandler( # render plot to pdf for download
    filename = 'plotByYear.pdf', 
    content = function(file){
      pdf(file = file, width = 12, height = 4)
      tsPlot(w.prop.yrs()$Year, w.prop.yrs()$Freq, i.prop.yrs()$Con, yrs(), 
             v1name = paste(input$mod, input$rcp, input$var), v2name = "Composite RCP 8.5 Sea ice", cex1 = cex-0.4, 
             xlb = "Year", ylb = ylab.ann, mn = main.ann())
      dev.off()
    }
  )
  
  output$plotByDecade <- renderPlot({ # render plot for mainPanel tabsetPanel tabPanel
    if(!is.null(w.prop.dec()) & !is.null(i.prop.dec())){
      if(nrow(i.prop.dec())>1){
        tsPlot(w.prop.dec()$Year, w.prop.dec()$Freq, i.prop.dec()$Con, decadal = T, yrs(), 
               v1name = paste(input$mod, input$rcp, input$var), v2name = "Composite RCP 8.5 Sea ice", xaxt = "n", cex1 = cex, 
               xlb = "Decade", ylb = ylab.dec, mn = main.dec())
      }
    }
  }, height = function(){ w <- session$clientData$output_plotByDecade_width; round((1/3)*w)	}, width = "auto")
  
  output$dl_plotByDecade <- downloadHandler( # render plot to pdf for download
    filename = 'plotByDecade.pdf', 
    content = function(file){
      pdf(file = file, width = 12, height = 4)
      tsPlot(w.prop.dec()$Year, w.prop.dec()$Freq, i.prop.dec()$Con, decadal = T, yrs(), 
             v1name = paste(input$mod, input$rcp, input$var), v2name = "Composite RCP 8.5 Sea ice", xaxt = "n", cex1 = cex-0.4, 
             ylim = c(0, 2), xlb = "Decade", ylb = ylab.dec, mn = main.dec())
      dev.off()
    }
  )
  
  output$SeaPlot <- renderPlot({ # render plot in sidebar to show selected sea region
    if(!is.null(input$sea) & !is.null(input$coast)){
      id <- match(input$sea, seas)
      if(input$coast != "Coastal only") id <- id + 3
      f(sea.images[[id]], x = 0, y = 0, size = 1)
    }
  }, height = function(){ w <- session$clientData$output_SeaPlot_width; round((7.5/10.5)*w)	}, width = "auto")
  
})