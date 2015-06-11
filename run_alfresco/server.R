# @knitr server
library(shiny)
library(RJSONIO); library(assertive)
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

shinyServer(function(input, output, session){
	output$JSON_Files <- renderUI({
		selectInput("json_files", "Select JSON:", c("", JSON_files), "")
	})
	
	source("reactives.R", local=T)

	output$JSON_Lines <- renderUI({ JSON_lines() })

	output$Obs_UpdateFiles <- renderUI({ Obs_updateFiles() })
})
