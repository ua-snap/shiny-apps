# @knitr reactives
fif_mtime <- reactive({ # testing
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

output$JSON_lines <- renderText({
	if(is.null(JSON_mtime()) | is.null(JSON_current())) return("No JSON file loaded yet.")
	readLines(JSON_current())
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
	if(is.null(input$goButton_JSON) || input$goButton_JSON == 0) return(NULL)
	isolate(
	if( !(is.null(user_email_address()) || is.null(all_email_addresses()) || user_email_address() == "" || all_email_addresses() == "" || 
		!length(input$frp_pts) || is.null(input$FireSensitivity) || is.null(input$IgnitionFactor) || is.na(as.numeric(input$n_sims))) ){
		
		rand_seed <- as.numeric(input$randseed)
		alf_fs <- as.numeric(input$FireSensitivity)
		alf_ig <- as.numeric(input$IgnitionFactor)
		alf_yr1 <- as.integer(input$year_start)
		alf_yr2 <- as.integer(input$year_end)
        n.sims <- as.integer(as.numeric(input$n_sims))
		c0 <- is.na(rand_seed)
		c1 <- is.na(alf_fs)
		c2 <- is.na(alf_ig)
		c3 <- is.na(alf_yr1)
		c4 <- is.na(alf_yr2)
		c5 <- is.na(as.numeric(unlist(strsplit(input$frp_buffers,","))))
		c6 <- !(input$climMod %in% c("CRU32", "CCSM4", "GFDL-CM3", "GISS-E2-R", "IPSL-CM5A-LR", "MRI-CGCM3") &
			input$climPeriod %in% c("historical", "RCP 4.5", "RCP 6.0", "RCP 8.5") &
			input$mapset %in% c("3m trunc + Lcoef", "3m trunc + Lmap", "5m trunc + Lcoef", "5m trunc + Lmap"))
		c7 <- is.na(n.sims) || n.sims < 32 || n.sims > 192
		if(!(any(c(c1, c2, c3, c4, c5, c6, c7)))){
			
			period <- gsub(" .", "", tolower(input$climPeriod))
            if(period=="historical") map_yr1 <- 1950 else map_yr1 <- alf_yr1
            if(period=="historical") map_yr2 <- alf_yr2 else map_yr2 <- alf_yr1
			mapset <- switch(input$mapset,
                "3m trunc + Lcoef"="3m100n_cavmDistTrunc_loop_L",
                "3m trunc + Lmap"="3m100n_cavmDistTrunc_loop_Lmap",
                "5m trunc + Lcoef"="5m100n_cavmDistTrunc_loop_L",
                "5m trunc + Lmap"="5m100n_cavmDistTrunc_loop_Lmap"
			)
            if(period!="historical") mapset <- gsub("_loop", "", mapset)
			flamFile <- file.path("/big_scratch/mfleonawicz/Alf_Files_20121129/gbmFlamMaps", period, input$climMod, mapset, "gbm.flamm.tif")
			
			for(i in JSON_current()){
				alfJSON <- fromJSON(i, simplify=F)
                alfJSON$Simulation$MaxReps <- n.sims
				alfJSON$Simulation$RandSeed <- rand_seed
				alfJSON$Simulation$FirstYear <- alf_yr1
				alfJSON$Simulation$LastYear <- alf_yr2
				alfJSON$Fire$Sensitivity[[1]] <- alf_fs
				alfJSON$Fire$IgnitionFactor[[1]] <- alf_ig
				
				alfJSON$Fire$TypeTransitionYears[[1]] <- alf_yr1
				alfJSON$Climate$TransitionYears[[1]] <- alf_yr1
                alfJSON$MapOutput$MapYearStart[[1]] <- map_yr2
                alfJSON$MapOutput$MapYearStart[[3]] <- map_yr1
                alfJSON$MapOutput$MapYearStart[[5]] <- map_yr1
				alfJSON$MapOutput$MapYearStart[[6]] <- alf_yr1
				
				alfJSON$Climate$Values$Flammability.File <- flamFile
				
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
			
			alf.domain <- substr(input$json_files, 4, 5)
            n.gbm <- substr(input$json_files, nchar(input$json_files)-6, nchar(input$json_files)-5)
            if(substr(alf.domain, 1, 2)=="No") alf.domain <- "Noatak" else if(alf.domain=="SW") alf.domain <- "Statewide" else stop("Unknown spatial domain.")
            alf.domain <- paste0(c(alf.domain, n.gbm), collapse="")
			domainDir <- paste0("Runs_", alf.domain)
			userDir <- gsub("@", "_at_", user_email_address())
			#outDir <- paste0(mainDir,"/",domainDir,"/",userDir,"/",format(Sys.time(), "%Y-%m-%d-%H-%M-%S"))
			outDir <- file.path(mainDir, domainDir, userDir, gsub("[ -]", "", input$run_name, period, input$climMod))
			relDir <- outDir # Still need this?
			
			for(i in JSON_current()){
				alfJSON <- fromJSON(i, simplify=F)
				alfJSON$Fire$Spatial.IgnitionFactor[[1]] <- file.path(outDir, "ignition.tif")
				alfJSON$Fire$Spatial.Sensitivity[[1]] <- file.path(outDir, "sensitivity.tif")
				alfJSON <- toJSON(alfJSON, pretty=T)
				cat(alfJSON, file=i, sep="\n")
			}
			
			# system calls begin here
			# Create Alfresco run-specific output directories and give shiny group write permissions
			if(!input$skipAlf){
				system(paste("ssh", server, "rm -rf", outDir))
				system(paste("ssh", server, "mkdir -p", outDir))
				system(paste("ssh", server, "chmod 2775", outDir))
				system(paste("ssh", server, "Rscript", "/big_scratch/mfleonawicz/Alf_Files_20121129/make_sensitivity_ignition_maps.R", alf_ig, alf_fs, outDir, alf.domain))
			}
			system(paste("ssh", server, "cp", file.path(mainDir,"RunAlfresco.slurm"), file.path(outDir,"RunAlfresco.slurm")))
			system(paste("ssh", server, "cp", file.path(mainDir,"CompileData.slurm"), file.path(outDir,"CompileData.slurm")))
			#system(paste("ssh", server, "cp", file.path(mainDir,"mailPNGs.sh"), file.path(outDir,"mailPNGs.sh")))
			if(!input$skipAlf){
				system(paste0("scp ", input$json_files, " ", server, ":", file.path(outDir,input$json_files)))
				system(paste0("scp ", file.path("pts",input$frp_pts), " ", server, ":", file.path(outDir,input$frp_pts)))
			}
			
			slurm_arguments <- paste("-D", outDir)
			buffers <- paste(1000*as.numeric(unlist(strsplit(input$frp_buffers,","))), collapse=",")
			buffers <- paste0("c\\(", buffers, "\\)", collapse="")
			if(input$group_runs & input$group_name!="" & input$run_name!=""){
				group.name <- input$group_name
				run.name <- input$run_name
			} else {
				group.name <- "none"
				run.name <- "run1"
			}
			frp_arguments <- paste0("pts=", input$frp_pts, " ", "'buffers=", buffers, "' group.name=", group.name, " run.name=", run.name, " emp.fire.cause=", input$fire_cause, collapse=" ")
			if(input$skipAlf) postprocOnly <- 0 else postprocOnly <- 1
			if(input$include_fseByVeg) includeFSE <- 1 else includeFSE <- 0
			if(input$include_frp) includeFRP <- 1 else includeFRP <- 0
			arguments <- paste(c(mainDir, outDir, relDir, paste(all_email_addresses(), collapse=","), alf.domain, input$json_files, postprocOnly, includeFSE, includeFRP, frp_arguments, alf_yr1, alf_yr2, n.sims, period), collapse=" ")
			sbatch_string <- paste("ssh", server, exec, slurm_arguments, file.path(outDir,slurmfile), arguments)
			system(sbatch_string)
			x <- paste("Alfresco job started on Atlas:\n", gsub(" ", " \n", sbatch_string))
		}
		if(substr(x,1,8)!="Alfresco") x <- "Alfresco job did not launch"
		
	}
	)
	return(x)
}
)

output$sbatch_call <- renderText({
	if(is.null(Obs_updateFiles())) return("Choose settings and run Alfresco simulations.")
	Obs_updateFiles()
})
