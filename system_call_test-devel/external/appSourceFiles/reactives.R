# Datasets, variables
sysCall <- reactive({
	x <- "Did not attempt to run system call"
	if(!is.null(input$goButton)){
		if(input$goButton==0) return(x)
		isolate({
			server <- "atlas.snap.uaf.edu"
			exec <- "sbatch"
			file <- "~/shell.txt"
			args <- "~/script.R 2 n=100 mean=10 sd=2"
			system(paste("ssh",server,exec,file,args))
			#tmpDir <- if(dirname(getwd())=="/home/uafsnap/shinyApps") "../tmpAppFiles" else if(dirname(getwd())=="/var/www/shiny-server/shiny-apps") "../tmpAppFiles"
			#system(paste0(tmpDir,"/shell.txt ",tmpDir,"/script.R"))
		})
		x <- paste("Attempted to run system call. wd:",paste0(getwd(),"/shell.txt ",getwd(),"/script.R"))
	}
	return(x)
})

fif_mtime <- reactive({
	x <- NULL
	input$goButton_fif
	if(!is.null(input$fif_files)) x <- file.info(input$fif_files)$mtime
	x
})

fif_current <- reactive({
	fif_mtime()
	input$fif_files
})

fif_lines <- reactive({
	fif_mtime()
	x <- readLines(fif_current())
	x <- gsub( "\\s+;.*.", ";", x)
	x.title.lines <- which(substr(x,1,1)==";")
	x[-x.title.lines] <- gsub( ";.*.", ";", x[-x.title.lines])
	return(x)
})


