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

Obs_updateFiles <- observe({
	fire.sensitivity.sub <- as.character(as.numeric(input$FireSensitivity))
	ignition.factor.sub <- as.character(as.numeric(input$IgnitionFactor))
	if(!is.na(fire.sensitivity.sub) & !is.na(ignition.factor.sub)){
		#white spaces below are just to make the file prettier on visual inspection in an editor
		fire.sensitivity.sub.fif <- paste0("Fire.Sensitivity                         = {", fire.sensitivity.sub, "}                                         ;")
		ignition.factor.sub.fif <- paste0("Fire.IgnitionFactor                      = {",ignition.factor.sub,"}                                          ;")
		for(i in fif_current()){
			x <- readLines(i)
			x <- gsub( "^Fire\\.Sensitivity\\s+=\\s+\\{\\d*\\.?\\d*\\}\\s+;", fire.sensitivity.sub.fif, x)
			x <- gsub( "^Fire\\.IgnitionFactor\\s+=\\s+\\{\\d*\\.?\\d*\\}\\s+;", ignition.factor.sub.fif, x)
			cat(x, file=i, sep="\n")
		}
		if(input$update_fif_defaults){
			for(i in defaults_file){
				x <- readLines(i)
				x <- gsub( "^default_Fire\\.Sensitivity=\\d*\\.?\\d*", paste0("default_Fire.Sensitivity=",as.numeric(input$FireSensitivity)), x)
				x <- gsub( "^default_Fire\\.IgnitionFactor=\\d*\\.?\\d*", paste0("default_Fire.IgnitionFactor=",as.numeric(input$IgnitionFactor)), x)
				cat(x, file=i, sep="\n")
			}
		}
		
		# system calls begin here
		# setup
		user <- "sudo -u shiny"
		server <- "atlas.snap.uaf.edu"
		mainDir <- "~/shiny/mfleonawicz"
		outDir <- paste0(mainDir,"/Runs_Noatak/Ignit_",ignition.factor.sub,"_Sens",fire.sensitivity.sub,"_complexGBMs")
		
		# Create Alfresco run-specific output directory and give my user read/write permissions
		system(paste(user, "ssh", server, "mkdir", outDir))
		system(paste(user, "ssh", server, "chmod 2775", outDir))
		
		system(paste("ssh", server, "cp", file.path(mainDir,"RunAlfresco_Noatak.slurm"), file.path(outDir,"RunAlfresco_Noatak.slurm"),"/"))
		system(paste("ssh", server, "cp", file.path(mainDir,"CompileData_Noatak.slurm"), file.path(outDir,"CompileData_Noatak.slurm"),"/"))
		system(paste0("sudo -u shiny scp ", input$fif_files, " ", server, ":", file.path(outDir,input$fif_files),"/"))
		
		exec <- "sbatch"
		file <- "RunAlfresco_Noatak.slurm"
		#args <- "~/script.R 2 n=100 mean=10 sd=2"
		system(paste(user,"ssh",server,exec,file.path(outDir,file)))#,args))
	}
},
suspended=T)

Obs_updateFiles_resume <- observe({ if(!is.null(input$goButton_fif)) if(input$goButton_fif == 0) Obs_updateFiles$resume() })
