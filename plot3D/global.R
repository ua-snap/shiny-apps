library(shinyAce)

showCode <- function(file, ht="600px", theme="clouds_midnight"){
	list(
		h4(HTML(basename(file))),
		aceEditor(basename(file), value = paste(readLines(file), collapse="\\n"), mode="r", theme=theme, height=ht, readOnly=TRUE)
	)
}

show_global <- showCode("global.R")
show_ui <- showCode("ui.R")
show_server <- showCode("server.R")
show_app <- showCode("external/app.R")
show_header <- showCode("external/header.R")
show_sidebar <- showCode("external/sidebar.R")
show_main <- showCode("external/main.R")
show_about <- showCode("external/about.R")
for(i in 1:6) assign(paste0("show_wp",i), showCode(paste0("external/appSourceFiles/io.sidebar.wp",i,".R")))
show_reactives <- showCode("external/appSourceFiles/reactives.R")
