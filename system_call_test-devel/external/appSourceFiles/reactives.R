# Datasets, variables
sysCall <- reactive({
	x <- "Did not attempt to run system call"
	if(!is.null(input$goButton)){
		if(input$goButton==0) return(x)
		#isolate(
			observe({
				system("external/shell.txt external/script.R")
				#system("Y:/Users/mfleonawicz/github/shiny-apps/system_call_test-devel/external/shell.txt Y:/Users/mfleonawicz/github/shiny-apps/system_call_test-devel/external/script.R")
			})
		#)
		x <- paste("Attempted to run system call. wd:",getwd())
	}
	return(x)
})
