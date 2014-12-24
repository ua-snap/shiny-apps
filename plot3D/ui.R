tabPanelAbout <- source("about.R",local=T)$value
headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}

shinyUI(fluidPage(
	source("header.R",local=T)$value,
	fluidRow(
		source("sidebar.R",local=T)$value,
		source("main.R",local=T)$value
	)
))
