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
		div(HTML('Alfresco Web GUI
			<a href="http://snap.uaf.edu" target="_blank"><img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" /></a>'
		), style="color:#ffffff;"), h3, "Alfresco Shiny App Prototype"
	),
	fluidRow(
		source("sidebar.R",local=T)$value,
		column(6,
			tabsetPanel(
				tabPanel("Home", 
					div(style="color:#ffffff;", h1("Welcome to the Alfresco web GUI"), h3("Powered by R and Shiny")), 
					div(verbatimTextOutput("sbatch_call"), style="height: 400px;"), value="home"),
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
