source("external/uiHead.R",local=T)
shinyUI(fluidPage(theme=shinytheme("spacelab"),
	source("external/header.R",local=T)$value,
	fluidRow(
		source("external/sidebar.R",local=T)$value,
		source("external/main.R",local=T)$value
	)
))
