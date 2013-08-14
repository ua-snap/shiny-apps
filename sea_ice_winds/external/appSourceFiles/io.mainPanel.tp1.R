# TabPanel titles
output$tp.annualts <- renderUI({ if(!is.null(w.prop.yrs())) h4("Annual time series") })
output$tp.annstyle <- renderUI({ if(!is.null(w.prop.yrs())) selectInput("annstyle","Plot style",c("Lines","Bars"),"Lines") })
output$tp.decadalts <- renderUI({ if(!is.null(w.prop.dec())) h4("Decadal time series") })
output$tp.decstyle <- renderUI({ if(!is.null(w.prop.dec())) selectInput("decstyle","Plot style",c("Lines","Bars"),"Bars") })
