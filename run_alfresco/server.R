library(shiny)
pkgs <- c("RJSONIO","assertive")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(RJSONIO); library(assertive)
defaults_file <- "external/appSourceFiles/alfresco_json_defaults.txt"
source(defaults_file, local=T)
JSON_files <- list.files(pattern=".JSON$")

server <- "atlas.snap.uaf.edu"
mainDir <- "/big_scratch/shiny"
exec <- "sbatch"
slurmfile <- "RunAlfresco.slurm"

setMethod("toJSON", "numeric",
   function(x, container = isContainer(x, asIs, .level), collapse = "\n", digits = 10, ...,
	.level = 1L, .withNames = length(x) > 0 && length(names(x)) > 0,
	.na = "null", .escapeEscapes = TRUE, pretty = FALSE, asIs = NA){

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

shinyServer(function(input, output, session) source("external/app.R", local = TRUE))
