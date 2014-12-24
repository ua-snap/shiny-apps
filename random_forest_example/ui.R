source("external/uiHead.R",local=T)
shinyUI(pageWithSidebar(
	source("external/header.R",local=T)$value,
	source("external/sidebar.R",local=T)$value,
	source("external/main.R",local=T)$value
))
