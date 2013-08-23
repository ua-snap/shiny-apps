source("external/serverHead.R", local = TRUE)
shinyServer(function(input, output){
	source("external/app.R", local = TRUE)
	#observe({ system("/tmp/shell.txt /tmp/script.R"), wait=FALSE, show.output.on.console=FALSE) }) #sysCall() })
	#observe({ system("touch /tmp/app-test-file") })
})
