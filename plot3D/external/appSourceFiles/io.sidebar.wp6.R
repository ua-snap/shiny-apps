# Additional general plot formatting properties
output$colkey <- renderUI({	selectInput("colkey","Color key:",c("None","Default","Manual"),"None") })

output$colkeyside <- renderUI({ selectInput("colkey.side","Color key position:",c("Bottom","Left","Top","Right"),"Right") })

output$colkeyaddlines <- renderUI({ checkboxInput("colkey.addlines","Add lines to key:") })

output$clab <- renderUI({ checkboxInput("clab","Show key label:") })

output$NAcol <- renderUI({ selectInput("NAcol","NA color:",choices=c("white","black"),selected="white") })

output$bgcol <- renderUI({ selectInput("bgcol","Background color:",c("Black","White"),"Black") })
