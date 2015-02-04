library(shinythemes)

tabPanelAbout <- source("external/about.R",local=T)$value

headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}

shinyUI(fluidPage(theme=shinytheme("cosmo"),
	headerPanel_2(
		HTML('Estimated Mean Decadal 15% Sea Ice Concentration Edges
			<a href="http://snap.uaf.edu" target="_blank"><img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" /></a>'
		), h3, "Sea Ice Edge"
	),
	fluidRow(
		source("external/sidebar.R",local=T)$value,
		source("external/main.R",local=T)$value
	)
))
