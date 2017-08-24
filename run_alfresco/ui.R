# @knitr ui
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
	use_apputils(),
	tags$head(tags$style(HTML("#JSON_lines { font-size: 10px; }"))),
	fluidRow(
		source("sidebar.R",local=T)$value,
		column(6,
			tabsetPanel(
				tabPanel("Home", 
					div(style="color:#ffffff;", h1("Welcome to the Alfresco web GUI"), h3("Powered by R and Shiny")), 
					div(verbatimTextOutput("sbatch_call"), style="height: 400px;"), value="home"),
				tabPanel("View JSON", br(),
					div(verbatimTextOutput("JSON_lines"), style="overflow-y:scroll; max-height: 788px"), value="viewjson"),
				tabPanel("Information", value="info"),
				id="tsp",
				type="pills",
				selected="home"
			)
		)
	),
	conditionalPanel("input.tsp == 'info'",
	  fluidRow(
	    column(12,
  	    br(),
    	  wellPanel(
    	    h2("About this application"),
    	    HTML(read_md_paragraphs("text_about.txt", ptag=TRUE, collapse=TRUE)),
    	    app_citation("Matthew Leonawicz", 2017,
    	                 title="ALFRESCO Launcher web application",
    	                 publisher="Scenarios Network for Alaska and Arctic Planning, University of Alaska Fairbanks",
    	                 url="http://eris.snap.uaf.edu/run_alfresco"), br(), br(),
    	    contactinfo(list(uaf="UAFLogo_A_286.png", iarc="iarc_375.jpg", snap="snap_fullcolor_400h.png")), br(),
    	    style="background-color:#ffffff;")
        )
	    )
    )
))
