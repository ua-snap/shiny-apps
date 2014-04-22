# RGL plot formatting properties
output$rglcol <- renderUI({ selectInput("rglcol","RGL colors:",c("R:Topo","R:Terrain","R:Heat","R:Cyan-Magenta","black-white","purple-yellow"),"R:Topo") })

output$rgladjustrelief <- renderUI({ sliderInput("rgladjustrelief","Scale relief (percent):",-100,100,0,step=10) })

output$RglPointsLines <- renderUI({ selectInput("rglpointslines","Points/lines (if applicable):",c("Points","Lines"),"Points") })
