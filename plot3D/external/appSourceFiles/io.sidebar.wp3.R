# Image plot properties
output$contour <- renderUI({ checkboxInput("contour","Add contour lines:") })

output$rasterImage <- renderUI({ checkboxInput("rasterImage","rasterImage() smoothing") })

output$resfac <- renderUI({ selectInput("resfac", "Increase resolution by factor:", 1:4,1) })

output$imagecol <- renderUI({ selectInput("image.col","Image colors:",c("R:Topo","R:Terrain","R:Heat","R:Cyan-Magenta","black-white","purple-yellow"),"R:Topo") })

output$imagenlevels <- renderUI({ sliderInput("image.nlevels","Number of breaks:",6,30,16,2) })

output$lighting <- renderUI({  selectInput("lighting", "Lighting:", c("None","Default"),"None") })

output$shade <- renderUI({ sliderInput("shade","Shading:",0,1,0.5,0.05) })

output$facets <- renderUI({ selectInput("facets","Color cells or borders:",choices=c("Grid cells","Borders"),selected="Grid cells") })

output$border <- renderUI({ selectInput("border", "Cell border color:", c("","White","Black"),"") })

output$imagetheta <- renderUI({ sliderInput("image.theta","Rotate (Uncheck smoothing):",-180,180,0,10) })

output$imageasp <- renderUI({ selectInput("image.asp", "Aspect ratio:", c("Original scale","Rescale to square"),"Original scale") })
