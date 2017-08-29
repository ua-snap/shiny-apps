# @knitr reactives
rv <- reactiveValues(json_lines="No JSON file loaded.")

all_email_addresses <- reactive({
	e <- input$useremail
	if(is.null(e) || !length(e)) return("")
	if(length(e)){
		e <- gsub(" ", "", strsplit(e, ",")[[1]]) # split email string on comma, remove any spaces
		keep <- which(is_email_address(e))
		if(length(keep)) e <- unique(c(e[keep], "mfleonawicz@alaska.edu")) else e <- ""
	} else { e <- "" }
	e
})

hist_run <- reactive({ substr(input$json_files, 1, 3) == "cru" })
domain_abb <- reactive({ if(substr(input$json_files, 4, 5) == "SW") "SW" else "Noatak" })
domain <- reactive({ if(domain_abb() == "SW") "Statewide" else "Noatak" })
gbm_set <- reactive({ substr(strsplit(input$json_files, domain_abb())[[1]][2], 1, 2) })
period <- reactive({ if(is.null(input$climPeriod)) "historical" else gsub("[ .]", "", tolower(input$climPeriod)) })
mapset <- reactive({
  x <- switch(domain(), "Noatak"=flam_map_sets[c(1, 3)], "Statewide"=flam_map_sets[c(2, 4)])
  x <- switch(gbm_set(), "3m"=x[1], "5m"=x[2])
  if(period() != "historical") x <- gsub("_loop", "", x)
  x
})

output$RCP_opts <- renderUI({
  r <- if(hist_run()) rcps[1] else rcps[2:4]
  selectInput("climPeriod", "RCP", r, width="100%")
})
output$Model_opts <- renderUI({
  m <- if(hist_run()) models[1] else models[2:6]
  selectInput("climMod", "CRU/GCM", m, width="100%")
})
output$Year_opts1 <- renderUI({
  yr <- if(hist_run()) 1 else 2014
  numericInput("year1", "Start year", yr, 1, 2014, 1, width="100%")
})

output$Year_opts2 <- renderUI({
  yr <- if(hist_run()) 2013 else 2099
  numericInput("year2", "End year", yr, 2013, 2099, 1, width="100%")
})

alf_yr1 <- reactive({ as.integer(input$year1) })
alf_yr2 <- reactive({ as.integer(input$year2) })
min_msy <- reactive({ max(alf_yr1(), 1949) })

output$msy_input_panel <- renderUI({
  x <- paste0("msy_", map_yr_start_ids)
  names(x) <- names(map_yr_start_ids)
  m <- min_msy()
  
  tagList(
    fluidRow(
      column(6,
        checkboxGroupInput("msy_flags", "Include output maps", map_yr_start_ids, 
                           map_yr_start_ids[c(1, 3, 5, 6)], inline=TRUE, width="100%"),
        bsTooltip("msy_flags", "Only checked map types will be output by ALFRESCO. Default starting years for map outputs are the first year of a run, no earlier than 1949, except for fire scar maps. Maps toggled off by default show the final run year as the default, but are not output.")
      ),
      column(6, numericInput(x[1], names(x[1]), m, m, alf_yr2(), 1,  width="100%"))
    ),
    fluidRow(
      column(6,
        numericInput(x[2], names(x[2]), alf_yr2(), m, alf_yr2(), 1,  width="100%"),
        numericInput(x[4], names(x[4]), alf_yr2(), m, alf_yr2(), 1,  width="100%"),
        numericInput(x[6], names(x[6]), alf_yr1(), alf_yr1(), alf_yr2(), 1,  width="100%"),
        bsTooltip(x[6], "Note that fire scar maps are required for post-processing of ALFRESCO runs. It is recommended to output these maps for all years and discard unneeded maps at a later time.")
      ),
      column(6,
        numericInput(x[3], names(x[3]), m, m, alf_yr2(), 1,  width="100%"),
        numericInput(x[5], names(x[5]), m, m, alf_yr2(), 1,  width="100%"),
        numericInput(x[7], names(x[7]), alf_yr2(), m, alf_yr2(), 1,  width="100%")
      )
    )
  )
})

output$PointLocs <- renderUI({
  files <- list.files("pts", pattern=".csv$")
  x <- substr(files, 1, 6)
  files <- if(domain() == "Noatak") files[x == "Noatak"] else files[x != "Noatak"]
  selectInput("frp_pts", "Fire Return Period locations", files, width="100%")
})

output$GroupName <- renderUI({
  v <- if(domain() == "Statewide") "SW" else "Noatak"
  #if((!is.null(input$FireSensFMO) && input$FireSensFMO != "None") ||
  #   (!is.null(input$IgnitFacFMO) && input$IgnitFacFMO != "None"))
    v <- paste0(v, "fmo")
  textInput("group_name", "Group name for multiple runs", value=v)
})

output$RunName <- renderUI({
  sfmo <- 100*input$FireSensFMOMax
  ifmo <- 100*input$IgnitFacFMOMax
  if(sfmo == 100) sfmo <- 99
  if(ifmo == 100) ifmo <- 99
  if(sfmo < 10) sfmo <- paste0(0, sfmo)
  if(ifmo < 10) ifmo <- paste0(0, ifmo)
  v <- paste0("fmo", sfmo, "s", ifmo, "i_", period(), "_", input$climMod)
  textInput("run_name", "Unique run name", value=v)
})

default_map_starts <- reactive({
  x <- list(alf_yr2(), alf_yr2(), min_msy(), alf_yr2(), min_msy(), alf_yr1(), alf_yr2())
  names(x) <- map_yr_start_ids
  x
})

map_yr_start <- reactive({
  x <- lapply(paste0("msy_", map_yr_start_ids), function(x, i) as.integer(i[[x]]), i=input)
  if(any(sapply(x, length) == 0)) return(default_map_starts())
  names(x) <- map_yr_start_ids
  x
})

map_yr_flags <- reactive({
  x <- input$msy_flags
  if(!length(x)) return(default_map_flags)
  idx <- match(x, map_yr_start_ids)
  x <- rep(0L, length(default_map_flags))
  x[idx] <- 1L
  x
})

n.sims <- reactive({ as.integer(as.numeric(input$n_sims)) })
rand_seed <- reactive({ as.numeric(input$randseed) })
alf_fs <- reactive({ as.numeric(input$FireSensitivity) })
alf_ig <- reactive({ as.numeric(input$IgnitionFactor) })

flamFile <- reactive({
  file.path("/atlas_scratch/mfleonawicz/projects/Flammability/data/gbmFlammability/samples_based", 
            period(), input$climMod, mapset(), "gbm.flamm.tif")
})

domainDir <- reactive({ paste0("Runs_", domain()) })
userDir <- reactive({ gsub("@", "_at_", all_email_addresses()[1]) })
outDir <- reactive({ 
  file.path(mainDir, domainDir(), userDir(), gsub("[ ]", "", input$run_name, period(), input$climMod)) 
})
relDir <- reactive({ outDir() }) # Still need this?

observe({
  if(is.null(input$json_files) || input$json_files == ""){
    rv$json_lines <- "No JSON file loaded."
    return()
  }
  alfJSON <- fromJSON(input$json_files, simplify=FALSE)
  alfJSON$Simulation$MaxReps <- n.sims()
  alfJSON$Simulation$RandSeed <- rand_seed()
  alfJSON$Simulation$FirstYear <- alf_yr1()
  alfJSON$Simulation$LastYear <- alf_yr2()
  alfJSON$Fire$Sensitivity[[1]] <- alf_fs()
  alfJSON$Fire$IgnitionFactor[[1]] <- alf_ig()
  
  alfJSON$Fire$TypeTransitionYears[[1]] <- alf_yr1()
  alfJSON$Climate$TransitionYears[[1]] <- alf_yr1()
  
  alfJSON$MapOutput$MapYearStart[1:7] <- map_yr_start()
  alfJSON$MapOutput$MapRepFreq[1:7] <- alfJSON$MapOutput$MapYearFreq[1:7] <- map_yr_flags()
  
  alfJSON$Climate$Values$Flammability.File <- flamFile()
  alfJSON$Fire$Spatial.IgnitionFactor[[1]] <- file.path(outDir(), "ignition.tif")
  alfJSON$Fire$Spatial.Sensitivity[[1]] <- file.path(outDir(), "sensitivity.tif")
  
  alfJSON <- toJSON(alfJSON, pretty=TRUE)
  rv$json_lines <- alfJSON
  cat(alfJSON, file=input$json_files, sep="\n")
})

Obs_updateFiles <- reactive({
	x <- "No Alfresco job started yet"
	if(is.null(input$goButton_JSON) || input$goButton_JSON == 0) return(NULL)
	isolate(
	if( !(is.null(all_email_addresses()) || all_email_addresses() == "" || 
		!length(input$frp_pts) || is.null(input$FireSensitivity) || 
		is.null(input$IgnitionFactor) || is.na(as.numeric(input$n_sims)) )){
		
		alf_fs <- as.numeric(input$FireSensitivity)
		alf_ig <- as.numeric(input$IgnitionFactor)
		alf_fsfmo <- gsub(" ", "_", input$FireSensFMO)
		alf_igfmo <- gsub(" ", "_", input$IgnitFacFMO)
		alf_fsfmomax <- input$FireSensFMOMax
		alf_igfmomax <- input$IgnitFacFMOMax
    n.sims <- as.integer(as.numeric(input$n_sims))
		c1 <- is.na(rand_seed()) || is.na(alf_fs()) || is.na(alf_ig()) || is.na(alf_yr1()) || is.na(alf_yr2())
		c2 <- is.na(as.numeric(unlist(strsplit(input$frp_buffers,","))))
		c3 <- !(input$climMod %in% c("CRU32", "CCSM4", "GFDL-CM3", "GISS-E2-R", "IPSL-CM5A-LR", "MRI-CGCM3") &
			input$climPeriod %in% c("historical", "RCP 4.5", "RCP 6.0", "RCP 8.5"))
		c4 <- is.na(n.sims()) || n.sims() < 32 || n.sims() > 192
		if(!(any(c(c1, c2, c3, c4)))){
			if(input$update_json_defaults){
				for(i in defaults_file){
					y <- readLines(i)
					y <- gsub( "^default_Fire\\.Sensitivity=\\d*\\.?\\d*", paste0("default_Fire.Sensitivity=", alf_fs()), y)
					y <- gsub( "^default_Fire\\.IgnitionFactor=\\d*\\.?\\d*", paste0("default_Fire.IgnitionFactor=", alf_ig()), y)
					cat(y, file=i, sep="\n")
				}
			}
			
			# system calls begin here
			# Create Alfresco run-specific output directories and give shiny group write permissions
			if(!input$skipAlf){
				system(paste("ssh", server, "rm -rf", outDir()))
				system(paste("ssh", server, "mkdir -p", outDir()))
				system(paste("ssh", server, "chmod 2775", outDir()))
        system(paste("ssh", server, "cp", 
                     file.path(mainDir, "make_sensitivity_ignition_maps.R"), 
                     file.path(outDir(),"make_sensitivity_ignition_maps.R")))
				system(paste("ssh", server, "Rscript", 
				             file.path(outDir(),"make_sensitivity_ignition_maps.R"), 
				             alf_ig(), alf_fs(), paste0("'", alf_igfmo, "'"), paste0("'", alf_fsfmo, "'"), 
				             alf_igfmomax, alf_fsfmomax, outDir(), domain()))
			}
			system(paste("ssh", server, "cp", file.path(mainDir, "RunAlfresco.slurm"), file.path(outDir(), "RunAlfresco.slurm")))
			system(paste("ssh", server, "cp", file.path(mainDir, "CompileData.slurm"), file.path(outDir(), "CompileData.slurm")))
			#system(paste("ssh", server, "cp", file.path(mainDir,"mailPNGs.sh"), file.path(outDir(),"mailPNGs.sh")))
			if(!input$skipAlf){
				system(paste0("scp ", input$json_files, " ", server, ":", file.path(outDir(), input$json_files)))
				system(paste0("scp ", file.path("pts",input$frp_pts), " ", server, ":", file.path(outDir(), input$frp_pts)))
			}
			
			slurm_arguments <- paste("-D", outDir())
			buffers <- paste(1000*as.numeric(unlist(strsplit(input$frp_buffers,","))), collapse=",")
			buffers <- paste0("c\\(", buffers, "\\)", collapse="")
			if(input$group_runs & input$group_name!="" & input$run_name!=""){
				group.name <- input$group_name
				run.name <- input$run_name
			} else {
				group.name <- "none"
				run.name <- "run1"
			}
			frp_arguments <- paste0("pts=", input$frp_pts, " ", "'buffers=", buffers, "' group.name=", group.name, 
			                        " run.name=", run.name, " emp.fire.cause=", input$fire_cause, collapse=" ")
			if(input$skipAlf) postprocOnly <- 0 else postprocOnly <- 1
			if(input$include_fseByVeg) includeFSE <- 1 else includeFSE <- 0
			if(input$include_frp) includeFRP <- 1 else includeFRP <- 0
			arguments <- paste(c(mainDir, outDir(), relDir(), 
			                     paste(all_email_addresses(), collapse=","), 
			                     domain(), input$json_files, postprocOnly, includeFSE, includeFRP, frp_arguments, 
			                     alf_yr1(), alf_yr2(), n.sims(), period()), collapse=" ")
			sbatch_string <- paste("ssh", server, exec, slurm_arguments, file.path(outDir(), slurmfile), arguments)
			system(sbatch_string)
			sbatch_string2 <- strsplit(sbatch_string, " ")[[1]]
			x <- paste("Alfresco job started on Atlas. Full system call to sbatch:\n", 
			           paste(sbatch_string2[1:4], collapse=" "), "\n  ",
			           paste(sbatch_string2[5:8], collapse="\n   "), "\n  ",
			           paste(sbatch_string2[9:10], collapse="\n   "), "\n  ",
			           paste(sbatch_string2[11:17], collapse=" "), "\n  ",
			           paste(sbatch_string2[18:20], collapse=" "), "\n")
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
