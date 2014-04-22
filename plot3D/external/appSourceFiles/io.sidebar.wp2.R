# Contour lines properties
output$contourcol <- renderUI({ selectInput("contour.col","Contour line color:",c("Black","White","Gray","Orange","Blue","Red","green","R:Topo","R:Terrain","R:Heat","R:Cyan-Magenta","purple-yellow"),"R:Topo") })

output$contournlevels <- renderUI({ selectInput("contour.nlevels","Approx. levels:",c(5,10,20,40),10) })

output$contourlwd <- renderUI({ sliderInput("contour.lwd","Line width:",1,5,1,1) })

output$contourdrawlabels <- renderUI({ checkboxInput("contour.drawlabels","Draw labels",TRUE) })

output$labelSize <- renderUI({ sliderInput("contour.labcex","Contour label size:",0.5,2,1,0.1) })

output$contourasp <- renderUI({ selectInput("contour.asp", "Aspect ratio:", c("Original scale","Rescale to square"),"Original scale") })
