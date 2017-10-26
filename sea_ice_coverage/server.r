library(maps)
library(mapproj)
library(grid)
library(rgdal)
library(raster)
library(rasterVis)

mm <- map("world", proj = "stereographic", xlim = c(-180, 180), ylim = c(47, 90), interior = FALSE, lwd = 1, plot = F)
clrs <- c("#8B2500", "#000080", "#FF8C00", "#1E90FF", "#FF1493", "#000000") #"#CD9B1D"
pch <- c(0:3, 6:7)

shinyServer(function(input, output, session){
  
  output$semiTrans <- renderUI({
    if(length(transparency()) && transparency()) sliderInput("semi.trans", "Samples transparency", 10, 90, 40, step = 10, sep = "")
  })
  
  transparency <- reactive({
    trans <- FALSE
    if(length(input$reglnslm1) && input$reglnslm1) trans <- TRUE
    if(length(input$reglnslm2) && input$reglnslm2) trans <- TRUE
    if(length(input$reglnslo) && input$reglnslo) trans <- TRUE
    trans
  })
  
  # Reactive month/season variable, years, and rows for subsetting data.frame and numeric data objects
  mo.vec <- reactive({
    if(length(input$mo)){
      if(input$mo == "Annual Avg") {
        x <- mos
      } else if(input$mo == "Jun-Sep Avg") {
        x <- mos[6:9]
      } else if(input$mo == "Dec-Mar Avg") {
        x <- mos[c(1:3, 12)]
      } else {
        x <- input$mo
      }
    } else {
      x <- NULL
    }
    x
  })
  
  mo2.vec <- reactive({
    if(length(input$mo2)){
      if(input$mo2 == "Annual Avg") {
        x <- mos
      } else if(input$mo2 == "Jun-Sep Avg") {
        x <- mos[6:9]
      } else if(input$mo2 == "Dec-Mar Avg") {
        x <- mos[c(1:3, 12)]
      } else {
        x <- input$mo2
      }
    } else {
      x <- NULL
    }
    x
  })
  
  yrs <- reactive({
    if(length(input$yrs)){
      x <- c(input$yrs[1], input$yrs[2])
      if(length(input$mo)) if(input$mo == "Dec-Mar Avg") x[1] <- max(1861, x[1])
      x
    } else NULL
  })
  
  rows <- reactive({
    x <- (yrs()[1]-1860+1):(yrs()[2]-1860+1)
    if(input$mo == "Dec-Mar Avg") x <- x - 1
    x
  })
  
  # Plot color specific to model
  clr <- reactive({
    if(length(input$dataset)) clrs[match(input$dataset, modnames)]
  })
  
  pch.vals <- reactive({
    if(length(input$dataset)) pch[match(input$dataset, modnames)]
  })
  
  # List of numeric vectors of values, one per each model, by month or seasonal average
  dat <- reactive({
    if(length(input$dataset)){
      x <- list()
      mos.sub <- match(mo.vec(), mos)
      for(i in 1:length(input$dataset)){
        x[[i]] <- get(paste(tolower(substr(input$dataset[i], 1, 2)), "t", sep = "."))[, mos.sub]
        if(class(x[[i]]) == "data.frame"){
          if(input$mo == "Dec-Mar Avg"){
            x[[i]] <- rowMeans(cbind(x[[i]][-1, 1:3], x[[i]][-nrow(x[[i]]), 4]))
          } else {
            x[[i]] <- rowMeans(x[[i]])
          }
        }
      }
    } else x <- NULL
    x
  })
  
  # List of subsetted data
  dat2 <- reactive({
    req(dat())
    x <- list()
    for(i in 1:length(dat())) x[[i]] <- dat()[[i]][rows()]
    x
  })
  
  # Observed data, by month or seasonal average
  datObs <- reactive({
    x <- list()
    mos.sub <- match(mo.vec(), mos)
    x[[1]] <- ob.t[, mos.sub]
    if(class(x[[1]]) == "data.frame"){
      if(input$mo == "Dec-Mar Avg"){
        x[[1]] <- rowMeans(cbind(x[[1]][-1, 1:3], x[[1]][-nrow(x[[1]]), 4]))
      } else {
        x[[1]] <- rowMeans(x[[1]])
      }
    }
    x
  })
  
  # Observed, subsetted data
  dat2Obs <- reactive({
    x <- list()
    x[[1]] <- na.omit(datObs()[[1]])
    x
  })
  
  # Regression models
  lm1 <- reactive({
    if(!is.null(yrs())){
      x <- list()
      time <- yrs()[1]:yrs()[2]
      for(i in 1:length(dat2())){
        extent.total <- dat2()[[i]]
        x[[i]] <- lm(extent.total ~ time)
      }
      names(x) <- input$dataset
      x
    }
  })
  
  lm2 <- reactive({
    if(!is.null(yrs())){
      x <- list()
      time <- yrs()[1]:yrs()[2]
      for(i in 1:length(dat2())){
        extent.total <- dat2()[[i]]
        x[[i]] <- lm(extent.total ~ time + I(time^2))
      }
      names(x) <- input$dataset
      x
    }
  })
  
  lo <- reactive({
    if(length(input$smoothing.fraction)){
      x <- list()
      time <- yrs()[1]:yrs()[2]
      for(i in 1:length(dat2())){
        extent.total <- dat2()[[i]]
        x[[i]] <- loess(extent.total ~ time, span = input$smoothing.fraction)
      }
      names(x) <- input$dataset
      x
    }
  })
  
  output$lm1_summary <- renderPrint({
    lapply(lm1(), summary)
  })
  
  output$lm2_summary <- renderPrint({
    lapply(lm2(), summary)
  })
  
  output$lo_summary <- renderPrint({
    lapply(lo(), summary)
  })
  
  output$loSpan <- renderUI({
    if(input$reglnslo) sliderInput("smoothing.fraction", "Smoothing fraction:", 0.15, 1, 0.75, 0.05, sep = "")
  })
  
  # Time series plot and fitted trend lines
  doPlotTS <- function(margins = c(5, 5, 2, 0)+0.1, main = "", cex.lb = 1.3, cex.ax = 1.1, cex.leg = 1.2){
    if(length(input$dataset)){
      rng <- range(dat()); rng2 <- range(dat2())
      if(input$showObs) { rng <- range(c(rng, dat2Obs())); rng2 <- range(c(rng2, dat2Obs())) }
      par(mar = margins)
      xlb <- "Year"
      ylb <- bquote(.(input$mo)~" Arctic Sea Ice Extent "~(km^2)~"")
      if(input$fix.xy){
        plot(0, 0, type = "n", xlim = c(1860, 2099), xlab = xlb, ylab = ylb, ylim = rng + c(0, diff(rng)*0.1),
             cex.lab = cex.lb, cex.axis = cex.ax)
        legend("topleft", input$dataset, col = clr(), pch = pch.vals(), cex = cex.leg, bty = "n", horiz = T, xpd = T)
        if(input$showObs) legend("bottomleft", "Observed Sea Ice Extent", col = 1, lwd = 3, cex = cex.leg, bty = "n",
                                 horiz = T, xpd = T)
      } else {
        plot(yrs()[1]:yrs()[2], type = "n", xlim = yrs(), xlab = xlb, ylab = ylb, ylim = rng2 + c(0, diff(rng2)*0.1),
             cex.lab = cex.lb, cex.axis = cex.ax)
        legend("topleft", input$dataset, col = clr(), pch = pch.vals(), cex = cex.leg, bty = "n", horiz = T, xpd = T)
        if(input$showObs) legend("bottomleft", "Observed Sea Ice Extent", col = 1, lwd = 3, cex = cex.leg, bty = "n",
                                 horiz = T, xpd = T)
      }
      for(i in 1:length(dat())){
        d <- dat2()[[i]]
        if(length(input$reglns)){
          if(input$reglns){
            if(transparency()){
              lines(yrs()[1]:yrs()[2], d, lty = 1, lwd = 2,
                    col = paste(clr()[i], 100 - input$semi.trans, sep = "", collapse = ""))
            } else {
              lines(yrs()[1]:yrs()[2], d, lty = 1, lwd = 2, col = clr()[i])
            }
          }
        }
        if(length(input$regpts)){
          if(input$regpts){
            if(transparency()){
              points(yrs()[1]:yrs()[2], d, pch = pch.vals()[i],
                     col = paste(clr()[i], 100 - input$semi.trans, sep = "", collapse = ""), cex = cex.leg)
            } else {
              points(yrs()[1]:yrs()[2], d, pch = pch.vals()[i], col = clr()[i], cex = cex.leg)
            }
          }
        }
        if(length(input$reglnslm1)) if(input$reglnslm1) lines(yrs()[1]:yrs()[2], fitted(lm1()[[i]]), lty = 2, lwd = 2, col = clr()[i])
        if(length(input$reglnslm2)) if(input$reglnslm2) lines(yrs()[1]:yrs()[2], fitted(lm2()[[i]]), lty = 3, lwd = 2, col = clr()[i])
        if(length(input$reglnslo)) if(input$reglnslo) lines(yrs()[1]:yrs()[2], fitted(lo()[[i]]), lty = 4, lwd = 2, col = clr()[i])
      }
      if(input$showObs){
        if(input$mo == "Dec-Mar Avg"){
          lines(1980:2011, dat2Obs()[[1]], lwd = 3, col = 1)
        } else {
          lines(1979:2011, dat2Obs()[[1]], lwd = 3, col = 1)
        }
      }
      mtext(text = main, side = 3, adj = 0, line = 2, cex = 1.3)
    }
  }
  
  output$plot <- renderPlot({doPlotTS()},
    height = function(){ w <- session$clientData$output_plot_width; round(0.75*w)	}, width = "auto"
  )
  
  # Reactive variables for map plot
  decade <- reactive({
    if(length(input$dataset)) (as.numeric(substr(input$decade, 1, 4))-1850)/10 else NULL
  })
  
  season <- reactive({
    if(length(input$dataset)) match(mo2.vec(), mos) else NULL
  })
  
  laynum <- reactive({
    if(length(input$dataset)) 12*(decade()-1) + season() else NULL
  })
  
  dat.map <- reactive({
    if(length(input$dataset)){
      dat <- list()
      for(i in 1:length(modnames)){
        if(length(laynum()) == 1) {
          dat[[i]] <- subset(get(paste("b", tolower(substr(modnames[i], 1, 2)), sep = ".")), laynum())
        } else if(length(laynum())>1) {
          dat[[i]] <- calc(subset(get(paste("b", tolower(substr(modnames[i], 1, 2)), sep = ".")), laynum()), mean)
        }
      }
    } else dat <- NULL
    dat
  })
  
  # Map plot
  doPlotMap <- function(){
    if(length(input$mo2)){
      req(dat.map())
      yrs <- c(input$yrs[1], input$yrs[2])
      b <- stack(dat.map())
      dx1 <- diff(mm$range[1:2])
      dx2 <- diff(c(xmin(b), xmax(b)))
      dy1 <- diff(mm$range[3:4])
      dy2 <- diff(c(ymin(b), ymax(b)))
      mm$x <- 0.86*( (mm$x-min(mm$x, na.rm = T))*dx2/dx1 + 1.06*xmin(b) ) # extra coefficients chosen by eye for display purposes only
      mm$y <- 0.87*( (mm$y-min(mm$y, na.rm = T))*dy2/dy1 + 1.08*ymin(b) )
      mm$range <- extent(b)
      brk <- c(-5.001, -0.001, seq(5, 95, by = 5), 100.001)
      p <- levelplot(b, par.settings = list(strip.background = list(col = c("tan"))), at = brk,
                     col.regions = c("tan", colorRampPalette(c("blue", "white"))(20)),
                     colorkey = list(at = brk, c("tan", colorRampPalette(c("blue", "white"))(20))), scales = list(draw = F),
                     main = paste("RCP 8.5", input$decade, mo2.vec(), "Decadal Average Percent Sea Ice Concentration by Model"),
                     par.strip.text = list(cex = 1, lines = 2),
                     panel = function(...){
                       grid.rect(gp = gpar(col = NA, fill = "black"))
                       panel.levelplot(...)
                       panel.lines(mm, col = "black", lwd = 1, alpha = 0.5)
                     }
      )
      print(update(p, strip = strip.custom(factor.levels = modnames)))
    }
  }
  
  output$plot2 <- renderPlot({doPlotMap()},
                             height = function(){ w <- session$clientData$output_plot2_width; round(0.75*w)	}, width = "auto"
  )
  
  output$dlCurPlotTS <- downloadHandler(
    filename = 'curPlotTS.pdf',
    content = function(file){
      pdf(file = file, width = 11, height = 8.5)
      doPlotTS(margins = c(6, 6, 5, 2), main = "RCP 8.5 Sea Ice Extent Totals", cex.lb = 0.9, cex.ax = 0.8, cex.leg = 0.9)
      dev.off()
    }
  )
  
  output$dlCurPlotMap <- downloadHandler(
    filename = 'curPlotMap.pdf',
    content = function(file){
      pdf(file = file, width = 11, height = 8.5)
      doPlotMap()
      dev.off()
    }
  )
  
})
