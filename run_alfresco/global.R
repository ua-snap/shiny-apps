#library(shinyAce)
defaults_file <- "external/appSourceFiles/alfresco_json_defaults.txt"
source(defaults_file, local=T)
JSON_files <- list.files(pattern=".JSON$")

#R_files <- paste0(c(
#	"global", "ui", "server",
#	file.path("external", c("app", "header", "sidebar", "main", "about")), # cannot include "header" if it contains Google Analytics tracking code
#	file.path("external/appSourceFiles", c(paste0("iosidebarwp", 1:2), "reactives"))
#	), ".R")

#showCode <- function(file, ht="600px"){
#	list(
#		h4(HTML(basename(file))),
#		aceEditor(gsub('\\.', '', basename(file)), value=paste(readLines(file), collapse='\n'), mode='r', theme="clouds_midnight", height=ht, readOnly=TRUE)
#	)
#}

#for(i in 1:length(R_files)) assign(paste0("show_", gsub("\\.R", "R", basename(R_files[i]))), showCode(R_files[i]))
