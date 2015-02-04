library(shinythemes)

tabPanelAbout <- source("external/about.R",local=T)$value

headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}

shinyUI(fluidPage(theme="cyborg_bootstrap.css",
	tags$head(
		tags$link(rel="stylesheet", type="text/css", href="mystyles.css")
	),
	headerPanel_2(
		HTML('Monty Hall Gone Wild
			<a href="http://snap.uaf.edu" target="_blank"><img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_for-dark-bkgrnd_100px.png" /></a>'
		), h4, "Monty Hall Gone Wild"
	),
	fluidRow(
		source("external/sidebar.R",local=T)$value,
		source("external/main.R",local=T)$value
	)
))
