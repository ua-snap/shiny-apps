# Include/exclude marginal panels from graphic
output$meanHistorical <- renderUI({
	checkboxInput("meanHistorical","Daily historical means:",TRUE)
})

output$bars6mo <- renderUI({
	checkboxInput("bars6mo","6-month totals:",TRUE)
})

output$mean6mo <- renderUI({
	checkboxInput("mean6mo","Historical 6-month totals:",TRUE)
})
