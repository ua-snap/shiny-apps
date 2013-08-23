# Datasets, variables
sysCall <- reactive({
	x <- "Did not attempt to run system call"
	if(!is.null(input$goButton)){
		if(input$goButton==0) return(x)
		isolate({
			tmpDir <- if(dirname(getwd())=="/home/uafsnap/shiny-apps") "/home/uafsnap/tmp" else if(dirname(getwd())=="/var/www/shiny-server/shiny-apps") "/tmp"
			system(paste0(tmpDir,"/shell.txt ",tmpDir,"/script.R"))
		})
		x <- paste("Attempted to run system call. wd:",paste0(getwd(),"/shell.txt ",getwd(),"/script.R"))
	}
	return(x)
})
