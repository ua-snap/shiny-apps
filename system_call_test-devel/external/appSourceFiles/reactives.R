#test
fif_mtime <- reactive({
	x <- NULL
	input$goButton_fif
	if(!is.null(input$fif_files)) x <- file.info(input$fif_files)$mtime
	x
})

JSON_mtime <- reactive({
	x <- NULL
	input$goButton_JSON
	if(!is.null(input$json_files)) x <- file.info(input$json_files)$mtime
	x
})

fif_current <- reactive({
	fif_mtime()
	input$fif_files
})

JSON_current <- reactive({
	JSON_mtime()
	input$json_files
})

fif_lines <- reactive({
	fif_mtime()
	x <- readLines(fif_current())
	x <- gsub( "\\s+;.*.", ";", x)
	x.title.lines <- which(substr(x,1,1)==";")
	x[-x.title.lines] <- gsub( ";.*.", ";", x[-x.title.lines])
	x
})

JSON_lines <- reactive({
	JSON_mtime()
	x <- readLines(JSON_current())
	x
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

# Reactive expression for code tab in main panel
# Ideal, but cannot do this on the server side due to a bug in the shinyAce package.
#codeTab <- reactive({
#	if(is.null(input$nlp)) return()
#	id <- gsub("nlp_", "show_", input$nlp)
#	show_list <- ls(pattern="^show_.*.R$", envir=.GlobalEnv)
#	if(id %in% show_list) x <- tabPanel(paste0("tp_",id), get(id)) else x <- NULL
#	x
#})

Obs_updateFiles <- reactive({
	x <- "No Alfresco job started yet"
	if(is.null(input$goButton_JSON) || input$goButton_JSON == 0) return(NULL)
	isolate(
	if( !(is.null(user_email_address()) || is.null(all_email_addresses()) || user_email_address() == "" || all_email_addresses() == "" || 
		!length(input$frp_pts)) || is.null(input$FireSensitivity) || is.null(input$IgnitionFactor) ){
		
		#fire.sensitivity.sub <- as.character(as.numeric(input$FireSensitivity))
		#ignition.factor.sub <- as.character(as.numeric(input$IgnitionFactor))
		alf_fs <- as.numeric(input$FireSensitivity)
		alf_ig <- as.numeric(input$IgnitionFactor)
		alf_yr1 <- as.integer(input$year_start)
		alf_yr2 <- as.integer(input$year_end)
		c1 <- is.na(alf_fs)
		c2 <- is.na(alf_ig)
		c3 <- is.na(alf_yr1)
		c4 <- is.na(alf_yr2)
		c5 <- is.na(as.numeric(unlist(strsplit(input$frp_buffers,","))))
		if(!(any(c(c1, c2, c3, c4, c5)))){
			
			for(i in JSON_current()){
				alfJSON <- fromJSON(i, simplify=F)
				alfJSON$Simulation$FirstYear <- alf_yr1
				alfJSON$Simulation$LastYear <- alf_yr2
				alfJSON$Fire$Sensitivity[[1]] <- alf_fs
				alfJSON$Fire$IgnitionFactor[[1]] <- alf_ig
				
				alfJSON$Fire$TypeTransitionYears[[1]] <- alf_yr1
				alfJSON$Climate$TransitionYears[[1]] <- alf_yr1
				alfJSON$MapOutput$MapYearStart[[6]] <- alf_yr1
				
				alfJSON <- toJSON(alfJSON, pretty=T)
				cat(alfJSON, file=i, sep="\n")
			}
			if(input$update_json_defaults){
				for(i in defaults_file){
					y <- readLines(i)
					y <- gsub( "^default_Fire\\.Sensitivity=\\d*\\.?\\d*", paste0("default_Fire.Sensitivity=", alf_fs), y)
					y <- gsub( "^default_Fire\\.IgnitionFactor=\\d*\\.?\\d*", paste0("default_Fire.IgnitionFactor=", alf_ig), y)
					cat(y, file=i, sep="\n")
				}
			}
			
			alf.domain <- substr(input$json_files, 1, nchar(input$json_files)-5)
			domainDir <- paste0("Runs_", alf.domain)
			userDir <- gsub("@", "_at_", user_email_address())
			
			#outDir <- paste0(mainDir,"/",domainDir,"/",userDir,"/Ignit_",ignition.factor.sub,"_Sens",fire.sensitivity.sub,"_complexGBMs")
			outDir <- paste0(mainDir,"/",domainDir,"/",userDir,"/",format(Sys.time(), "%Y-%m-%d-%H-%M-%S"))
			relDir <- outDir #paste0(domainDir,"/",userDir,"/Ignit_",ignition.factor.sub,"_Sens",fire.sensitivity.sub,"_complexGBMs")
			#resultsDir <- paste0("/big_scratch/shiny/Ignit_",ignition.factor.sub,"_Sens",fire.sensitivity.sub,"_complexGBMs")
			
			# system calls begin here
			# Create Alfresco run-specific output directories and give shiny group write permissions
			system(paste("ssh", server, "mkdir -p", outDir))
			system(paste("ssh", server, "chmod 2775", outDir))
			
			system(paste("ssh", server, "Rscript", "/big_scratch/mfleonawicz/Alf_Files_20121129/make_sensitivity_ignition_maps.R", alf_ig, alf_fs))
			system(paste("ssh", server, "cp", file.path(mainDir,"RunAlfresco.slurm"), file.path(outDir,"RunAlfresco.slurm")))
			system(paste("ssh", server, "cp", file.path(mainDir,"CompileData.slurm"), file.path(outDir,"CompileData.slurm")))
			#system(paste("ssh", server, "cp", file.path(mainDir,"mailPNGs.sh"), file.path(outDir,"mailPNGs.sh")))
			system(paste0("scp ", input$json_files, " ", server, ":", file.path(outDir,input$json_files)))
			system(paste0("scp ", file.path("pts",input$frp_pts), " ", server, ":", file.path(outDir,input$frp_pts)))
			
			slurm_arguments <- paste("-D", outDir)
			buffers <- paste(1000*as.numeric(unlist(strsplit(input$frp_buffers,","))), collapse=",")
			buffers <- paste0("c\\(", buffers, "\\)", collapse="")
			frp_arguments <- paste0("pts=", input$frp_pts, " ", "'buffers=", buffers, "'", collapse=" ")
			if(input$skipAlf) postprocOnly <- 0 else postprocOnly <- 1
			arguments <- paste(c(mainDir, outDir, relDir, paste(all_email_addresses(), collapse=","), alf.domain, input$json_files, postprocOnly, frp_arguments), collapse=" ")
			sbatch_string <- paste("ssh",server,exec, slurm_arguments, file.path(outDir,slurmfile), arguments)
			system(sbatch_string)
			x <- paste("Alfresco job started on Atlas:\n",gsub(" ", " \n", sbatch_string))
		}
		if(substr(x,1,8)!="Alfresco") x <- "Alfresco job did not launch"
		
	}
	)
	return(x)
}
)
