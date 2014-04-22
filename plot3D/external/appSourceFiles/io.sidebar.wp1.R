# Datasets, etc.
output$dataset <- renderUI({ selectInput("dataset","Select data:",choices=datasets(),selected=datasets()[1]) })

output$plottype <- renderUI({ if(!is.null(input$dataset)) selectInput("plottype","Type of plot:",choices=plottypes(),selected=plottypes()[1]) })
