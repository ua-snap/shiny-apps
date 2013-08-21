# TabPanel titles
output$tp.dailyTitle <- renderUI({ if(!is.null(d())) h4("Fairbanks, Alaska daily precipitation") })
#output$tp.decadalts <- renderUI({ if(!is.null(w.prop.dec())) h4("Decadal time series") })
#output$tp.decstyle <- renderUI({ if(!is.null(w.prop.dec())) selectInput("decstyle","Plot style",c("Lines","Bars"),"Bars") })
