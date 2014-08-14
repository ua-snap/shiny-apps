# Datasets, variables
totaldoors <- reactive({ n.doors })

d <- reactive({	if(!is.null(input$totaldoors)) data.list[[as.numeric(input$totaldoors)-2]] else NULL })
