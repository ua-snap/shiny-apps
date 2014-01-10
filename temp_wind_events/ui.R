library(shiny)
tabPanelAbout <- source("about.r")$value
headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}
shinyUI(pageWithSidebar(
	headerPanel_2(
		HTML(
			'<div id="stats_header">
			CMIP5 Quantile-mapped GCM Daily Data
			<a href="http://accap.uaf.edu" target="_blank">
			<img id="stats_logo" align="right" alt="ACCAP Logo" src="./img/ACCAP_acronym_100px.png" />
			</a>
			<a href="http://snap.uaf.edu" target="_blank">
			<img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" />
			</a>
			</div>'
		), h3, "CMIP5 Quantile-mapped GCM Daily Data"
	),
	sidebarPanel(
		tags$head(
			tags$style(type="text/css", "select { max-width: 500px; width: 100%; }"),
			tags$style(type="text/css", "textarea { max-width: 500px; width: 100%; }"),
			tags$style(type="text/css", ".jslider { max-width: 500px; width: 100%; }"),
			tags$style(type="text/css", ".well { max-width: 500px; }")
		  ),
		uiOutput("showMapPlot"),
		wellPanel(
			h5("Time"),
			sliderInput("yrs","",1958,2100,c(1981,2010),step=1,format="#"),
			div(class="row-fluid", div(class="span6", uiOutput("Mo")), div(class="span6", uiOutput("MoHi"))),
			tags$style(type="text/css", '#Mo {width: 150px}'),
			tags$style(type="text/css", '#MoHi {width: 150px}')
		),
		wellPanel(
			h5("Climate and Geography"),
			div(class="row-fluid", div(class="span6", uiOutput("Var")), div(class="span6", uiOutput("Loc"))),
			div(class="row-fluid", div(class="span6", uiOutput("Mod")),	div(class="span6", uiOutput("RCP"))),
			tags$style(type="text/css", '#Var {width: 150px}'),
			tags$style(type="text/css", '#Loc {width: 150px}'),
			tags$style(type="text/css", '#Mod {width: 150px}'),
			tags$style(type="text/css", '#RCP {width: 150px}')
		),
		wellPanel(
			h5("Thresholds and Conditionals"),
			div(class="row-fluid", div(class="span6", uiOutput("CutT")), div(class="span6", uiOutput("CutW"))),
			div(class="row-fluid", div(class="span6", uiOutput("Direction")), div(class="span6", uiOutput("Cond"))),
			tags$style(type="text/css", '#CutT {width: 150px}'),
			tags$style(type="text/css", '#CutW {width: 150px}'),
			tags$style(type="text/css", '#Direction {width: 150px}'),
			tags$style(type="text/css", '#Cond {width: 150px}'),
			p("Positve values for directional wind components indicate West to East and South to North, like an X-Y graph.")
		),
		wellPanel(div(class="row-fluid", div(class="span6", uiOutput("showMap")), div(class="span6", downloadButton("dlCurPlot", "Download Graphic"))),
		tags$style(type="text/css", '#showMap {width: 150px}'),
		tags$style(type="text/css", '#dlCurPlot {width: 120px}')),
		h5(textOutput("pageviews"))
	),
	mainPanel(
		tabsetPanel(
			tabPanel("Conditional Barplots",plotOutput("plot",height="auto"),value="barplots"),
			tabPanelAbout(),
			id="tsp"
		)
	)
))
