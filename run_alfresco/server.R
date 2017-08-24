# @knitr server
library(shiny)
library(assertive)
options(scipen=999)

server <- "atlas.snap.uaf.edu"
mainDir <- "/big_scratch/shiny"
exec <- "sbatch"
slurmfile <- "RunAlfresco.slurm"

setMethod("toJSON", "numeric",
   function(x, container = isContainer(x, asIs, .level), collapse = "\n", digits = 10, ...,
	.level = 1L, .withNames = length(x) > 0 && length(names(x)) > 0,
	.na = "null", .escapeEscapes = TRUE, pretty = FALSE, asIs = NA, .inf = " Infinity"){

	if(any(is.infinite(x))) warning("non-finite values in numeric vector may not be appropriately represented in JSON")
	tmp = formatC(x, digits = digits)
	if(any(nas <- is.na(x))) tmp[nas] = .na
	if(container) {
		if(.withNames){
			paste(sprintf("{%s", collapse), paste(dQuote(names(x)), tmp, sep = ": ", collapse = sprintf(",%s", collapse)), sprintf("%s}", collapse))
		} else {
			paste("[", paste(tmp, collapse = ", "), "]")
		}
	} else tmp
})

models <- c("CRU32", "CCSM4", "GFDL-CM3", "GISS-E2-R", "IPSL-CM5A-LR", "MRI-CGCM3")
rcps <- c("historical", "RCP 4.5", "RCP 6.0", "RCP 8.5")
map_yr_start_ids <- c("Burn severity history"="bsh", "Burn severity"="bs", "Vegetation"="veg",
                      "Fire"="fire", "Age"="age", "Fire scar"="fs", "Basal area"="ba")
default_map_flags <- as.integer(c(1, 0, 1, 0, 1, 1, 0))
flam_map_sets <- c(
  "3m trunc + Lcoef"="3m100n_cavmDistTrunc_loop_L",
  "3m trunc + Lmap"="3m100n_cavmDistTrunc_loop_Lmap",
  "5m trunc + Lcoef"="5m100n_cavmDistTrunc_loop_L",
  "5m trunc + Lmap"="5m100n_cavmDistTrunc_loop_Lmap"
)

shinyServer(function(input, output, session){
	source("reactives.R", local=TRUE)
	output$JSON_lines <- renderText({ rv$json_lines })
	output$Obs_UpdateFiles <- renderUI({ Obs_updateFiles() })
})
