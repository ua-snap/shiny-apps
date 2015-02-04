library(shinythemes)

tabPanelAbout <- source("external/about.R",local=T)$value
headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}

shinyUI(fluidPage(theme=shinytheme("cerulean"),
	headerPanel_2(
		HTML('Alaska / Western Canada Historical and Projected Climate
			<a href="http://snap.uaf.edu" target="_blank"><img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" /></a>'
		), h3, "Alaska / Western Canada Historical and Projected Climate"
	),
	fluidRow(
		source("external/sidebar.R",local=T)$value,
		source("external/main.R",local=T)$value
	)
))
