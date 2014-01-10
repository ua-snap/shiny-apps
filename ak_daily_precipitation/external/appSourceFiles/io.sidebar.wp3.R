# Include/exclude marginal panels from graphic
output$MeanHistorical <- renderUI({
	checkboxInput("meanHistorical","Daily historical means:",TRUE)
})

output$Bars6mo <- renderUI({
	checkboxInput("bars6mo","6-month totals:",TRUE)
})

output$Mean6mo <- renderUI({
	checkboxInput("mean6mo","Historical 6-month totals:",TRUE)
})
