# Maximum allowable missing values per month and per year
output$MaxNAperMo <- renderUI({
	sliderInput("maxNAperMo", "Max. NA/month:", min=0, max=10, value=5)
})

output$MaxNAperYr <- renderUI({
	sliderInput("maxNAperYr","Max. NA/year:", min=0, max=60, value=30)
})
