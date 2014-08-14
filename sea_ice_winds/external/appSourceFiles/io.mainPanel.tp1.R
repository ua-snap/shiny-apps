# TabPanel titles
output$tp.annstyle <- renderUI({ if(!is.null(w.prop.yrs())) selectInput("annstyle","Annual plot type",c("Lines","Bars"),"Lines") })
output$tp.decstyle <- renderUI({ if(!is.null(w.prop.dec())) selectInput("decstyle","Decadal plot type",c("Lines","Bars"),"Bars") })
