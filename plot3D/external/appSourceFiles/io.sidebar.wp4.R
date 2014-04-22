# Perspective plot properties
output$perspcol <- renderUI({ selectInput("persp.col","Perspective colors:",c("R:Topo","R:Terrain","R:Heat","R:Cyan-Magenta","black-white","purple-yellow"),"R:Topo") })

output$curtain <- renderUI({ checkboxInput("curtain","Drape edges") })

output$along <- renderUI({ selectInput("along", "Ribbons along:", c("x-axis","y-axis","both axes"),"x-axis") })

output$bty <- renderUI({ selectInput("bty", "Box and background grid:", c("Full box","Back panels only","Panels w/ grid lines","Gray w/ white lines","Black","Black w/ gray lines"),"Black w/ gray lines") })

#output$yslice <- renderUI({ checkboxInput("yslice","Add slice at fixed y") })

#output$xslice <- renderUI({ checkboxInput("xslice","Add slice at fixed x") })

#output$perspcontour <- renderUI({ checkboxInput("persp.contour","Add contour lines") })

#output$perspimage <- renderUI({ checkboxInput("persp.image","Add 2D image") })

output$perspcontourside <- renderUI({ selectInput("persp.contourside","2D contour level(s):",c("","Below","Layered","Above"),"",multiple=T) })

output$perspimageside <- renderUI({ selectInput("persp.imageside","2D image level:",c("","Below","Above"),"",multiple=T) })

output$perspzlim1 <- renderUI({ sliderInput("persp.zlim1","Decrease lower Z-limit:",0,5,0,0.5) })

output$perspzlim2 <- renderUI({ sliderInput("persp.zlim2","Increase upper Z-limit:",0,5,0,0.5) })

output$theta <- renderUI({ sliderInput("theta","Azimuthal viewing angle:",-180,180,40,10) })

output$phi <- renderUI({ sliderInput("phi","Colatitudinal viewing angle:",-90,90,40,10) })

output$imgadjustrelief <- renderUI({ sliderInput("adjustrelief","Scale relief:",-10,10,0,2) })
