# @knitr ui
tabPanelAbout <- source("about.R",local=T)$value
headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}

shinyUI(fluidPage(
	headerPanel_2(
		HTML('Alfresco Web GUI
			<a href="http://snap.uaf.edu" target="_blank"><img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" /></a>'
		), h3, "Alfresco Shiny App Prototype"
	),
	fluidRow(
		source("sidebar.R",local=T)$value,
		column(8,
			tabsetPanel(
				tabPanel("Home", 
					h1("Welcome to the Alfresco web GUI"), h3("Powered by R and Shiny"), div(verbatimTextOutput("sbatch_call"), style="height: 400px;"), value="home"),
				tabPanel("View JSON", 
					div(verbatimTextOutput("JSON_lines"), style="height: 800px;"), value="viewjson"),
				tabPanelAbout(),
				id="tsp",
				type="pills",
				selected="home"
			)
		)
	)
))
