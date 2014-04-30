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
	browser()
	return(x)
})

user_email_address <- reactive({
	e <- input$useremail
	if(is.null(e) || !length(e)) return("")
	if(length(e)){
		e <- gsub(" ", "", strsplit(e, ",")[[1]]) # split email string on comma, remove any spaces
		keep <- which(is_email_address(e))
		if(length(keep)) e <- e[keep[1]] else e <- "" # only accept the first [1] email address to identify user if multiple given
	} else { e <- "" }
	e
})

add_emails <- reactive({
	e <- input$addemail
	if(is.null(e) || !length(e)) return("")
	if(length(e)){
		e <- gsub(" ", "", strsplit(e, ",")[[1]]) # split email string on comma, remove any spaces
		keep <- which(is_email_address(e))
		if(length(keep)) e <- e[keep] else e <- ""
	} else { e <- "" }
	e
})

all_email_addresses <- reactive({
	e <- unique(c(user_email_address(), add_emails()))
	if(is.null(e) || !length(e)) return("")
	if(length(e)){
		keep <- which(is_email_address(e))
		if(length(keep)) e <- e[keep] else e <- ""
	} else { e <- "" }
	e
})

Obs_updateFiles <- reactive({
	x <- "No Alfresco job started yet"
	if(is.null(input$goButton_fif) || input$goButton_fif == 0) return(NULL)
	isolate(
	if( !(is.null(user_email_address()) || is.null(all_email_addresses()) || user_email_address() == "" || all_email_addresses() == "" || !length(input$frp_pts)) ){
		if(!is.null(input$FireSensitivity) & !is.null(input$IgnitionFactor)){
			fire.sensitivity.sub <- as.character(as.numeric(input$FireSensitivity))
			ignition.factor.sub <- as.character(as.numeric(input$IgnitionFactor))
			if(!is.na(fire.sensitivity.sub) & !is.na(ignition.factor.sub) & !any(is.na(as.numeric(unlist(strsplit(input$frp_buffers,",")))))){
				if(length(strsplit(fire.sensitivity.sub,"\\.")[[1]])==1) fire.sensitivity.sub <- gsub("\\.\\.", "\\.", paste0(fire.sensitivity.sub,"."))
				if(length(strsplit(ignition.factor.sub,"\\.")[[1]])==1) ignition.factor.sub <- gsub("\\.\\.", "\\.", paste0(ignition.factor.sub,"."))
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
				
				alf.domain <- substr(input$fif_files, 1, nchar(input$fif_files)-4)
				domainDir <- paste0("Runs_", alf.domain)
				userDir <- gsub("@", "_at_", user_email_address())
				
				outDir <- paste0(mainDir,"/",domainDir,"/",userDir,"/Ignit_",ignition.factor.sub,"_Sens",fire.sensitivity.sub,"_complexGBMs")
				relDir <- outDir #paste0(domainDir,"/",userDir,"/Ignit_",ignition.factor.sub,"_Sens",fire.sensitivity.sub,"_complexGBMs")
				#resultsDir <- paste0("/big_scratch/shiny/Ignit_",ignition.factor.sub,"_Sens",fire.sensitivity.sub,"_complexGBMs")
				
				# system calls begin here
				# Create Alfresco run-specific output directories and give shiny group write permissions
				system(paste(user, "ssh", server, "mkdir -p", outDir))
				system(paste(user, "ssh", server, "chmod 2775", outDir))
				
				system(paste("ssh", server, "Rscript", "/big_scratch/mfleonawicz/Alf_Files_20121129/make_sensitivity_ignition_maps.R", input$IgnitionFactor, input$FireSensitivity))
				system(paste("ssh", server, "cp", file.path(mainDir,"RunAlfresco.slurm"), file.path(outDir,"RunAlfresco.slurm")))
				system(paste("ssh", server, "cp", file.path(mainDir,"CompileData.slurm"), file.path(outDir,"CompileData.slurm")))
				#system(paste("ssh", server, "cp", file.path(mainDir,"mailPNGs.sh"), file.path(outDir,"mailPNGs.sh")))
				system(paste0("scp ", input$fif_files, " ", server, ":", file.path(outDir,input$fif_files)))
				system(paste0("scp ", file.path("pts",input$frp_pts), " ", server, ":", file.path(outDir,input$frp_pts)))
				
				slurm_arguments <- paste("-D", outDir)
				buffers <- paste(1000*as.numeric(unlist(strsplit(input$frp_buffers,","))), collapse=",")
				buffers <- paste0("c\\(", buffers, "\\)", collapse="")
				frp_arguments <- paste0("pts=", input$frp_pts, " ", "'buffers=", buffers, "'", collapse=" ")
				if(input$skipAlf) postprocOnly <- 0 else postprocOnly <- 1
				arguments <- paste(c(mainDir, outDir, relDir, paste(all_email_addresses(), collapse=","), alf.domain, input$fif_files, postprocOnly, frp_arguments), collapse=" ")
				sbatch_string <- paste(user,"ssh",server,exec, slurm_arguments, file.path(outDir,slurmfile), arguments)
				system(sbatch_string)
				x <- paste("Alfresco job started on Atlas:\n",gsub(" ", " \n", sbatch_string))
			}
			if(substr(x,1,8)!="Alfresco") x <- "Alfresco job did not launch"
		}
	}
	)
	return(x)
}
)
	