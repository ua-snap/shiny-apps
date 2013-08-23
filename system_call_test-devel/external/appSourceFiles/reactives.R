# Datasets, variables
sysCall <- reactive({
	x <- "Did not attempt to run system call"
	#if(!is.null(input$goButton)){
		#if(input$goButton==0) return(x)
		#isolate(
			#observe({
				system("/tmp/shell.txt /tmp/script.R"), wait=FALSE, show.output.on.console=FALSE) })
			#})
		#)
		x <- paste("Attempted to run system call. wd:",paste0(getwd(),"/shell.txt ",getwd(),"/script.R"))
	#}
	return(x)
})
