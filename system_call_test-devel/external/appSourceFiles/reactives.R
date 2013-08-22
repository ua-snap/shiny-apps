# Datasets, variables
sysCall <- reactive({
	x <- "Did not attempt to run system call"
	#if(!is.null(input$goButton)){
		#if(input$goButton==0) return(x)
		#isolate(
			#observe({
				system(paste0(getwd(),"/external/shell.txt ",getwd(),"/external/script.R"))
			#})
		#)
		x <- paste("Attempted to run system call. wd:",getwd())
	#}
	return(x)
})
