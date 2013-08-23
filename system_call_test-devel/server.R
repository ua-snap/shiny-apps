source("external/serverHead.R", local = TRUE)
shinyServer(function(input, output){
	source("external/app.R", local = TRUE)
	observe({ system(paste0("./shell.txt ./script.R"), wait=FALSE, show.output.on.console=FALSE) }) #sysCall() })
})
