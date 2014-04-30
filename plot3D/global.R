library(shinyAce)

R_files <- paste0(c(
	"global", "ui", "server",
	file.path("external", c("app", "header", "sidebar", "main", "about")),
	file.path("external/appSourceFiles", c(paste0("io.sidebar.wp", 1:6), "reactives"))
	), ".R")

showCode <- function(file, ht="600px"){
	list(
		h4(HTML(basename(file))),
		aceEditor(gsub("\\.", "", basename(file)), value=paste(readLines(file), collapse="\n\n"), mode="r", height=ht, readOnly=TRUE)
	)
}

for(i in 1:length(R_files)) assign(paste0("show_", gsub("\\.R", "R", basename(R_files[i]))), showCode(R_files[i]))
