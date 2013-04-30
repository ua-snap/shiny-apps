library(shiny)
tabPanelAbout <- source("about.R")$value
headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}
shinyUI(pageWithSidebar(
	#headerPanel(uiOutput("header")),
	headerPanel_2(
		HTML(
			'<div id="stats_header">
			CMIP5 Quantile-mapped GCM Daily Data
			<a href="http://snap.uaf.edu" target="_blank">
			<img id="stats_logo" align="right" alt="SNAP Logo" src="http://www.snap.uaf.edu/images/snap_acronym_rgb.gif" />
			</a>
			</div>'
		), h3, "CMIP5 Quantile-mapped GCM Daily Data"
	),
	#headerPanel(h4(textOutput("datname"))), # for debugging
	sidebarPanel(
		tags$head(
			tags$style(type="text/css", "label.radio { display: inline-block; }", ".radio input[type=\"radio\"] { float: none; }"),
			tags$style(type="text/css", "select { max-width: 150px; }"),
			tags$style(type="text/css", "textarea { max-width: 150px; }"),
			tags$style(type="text/css", ".jslider { max-width: 500px; }"),
			tags$style(type='text/css', ".well { max-width: 500px; }"),
			tags$style(type='text/css', ".span4 { max-width: 500px; }"),
			tags$style(type='text/css', ".span2 { max-width: 100px; }")
		  ),
		uiOutput("showMapPlot"),
		wellPanel(
			h5("Time"),
			sliderInput("yrs","",1958,2100,c(1981,2010),step=1,format="#"),
			div(class="row-fluid", div(class="span2", uiOutput("Mo")), div(class="span2", uiOutput("MoHi"))),
			tags$style(type="text/css", '#Mo {width: 150px; margin-left:0px;}'),
			tags$style(type="text/css", '#MoHi {width: 150px; margin-left:100px;}')
		),
		wellPanel(
			h5("Climate and Geography"),
			div(class="row-fluid", div(class="span2", uiOutput("Var")), div(class="span2", uiOutput("Loc"))),
			div(class="row-fluid", div(class="span2", uiOutput("Mod")),	div(class="span2", uiOutput("RCP"))),
			tags$style(type="text/css", '#Var {width: 150px; margin-left:0px;}'),
			tags$style(type="text/css", '#Loc {width: 150px; margin-left:100px;}'),
			tags$style(type="text/css", '#Mod {width: 150px; margin-left:0px;}'),
			tags$style(type="text/css", '#RCP {width: 150px; margin-left:100px;}')
		),
		wellPanel(
			h5("Thresholds and Conditionals"),
			div(class="row-fluid", div(class="span2", uiOutput("CutT")), div(class="span2", uiOutput("CutW"))),
			div(class="row-fluid", div(class="span2", uiOutput("Direction")), div(class="span2", uiOutput("Cond"))),
			tags$style(type="text/css", '#CutT {width: 150px; margin-left:0px;}'),
			tags$style(type="text/css", '#CutW {width: 150px; margin-left:100px;}'),
			tags$style(type="text/css", '#Direction {width: 150px; margin-left:0px;}'),
			tags$style(type="text/css", '#Cond {width: 150px; margin-left:100px;}')
		),
		wellPanel(div(class="row-fluid", div(class="span2", uiOutput("showMap")), div(class="span2", downloadButton("dlCurPlot", "Download Graphic"))),
		tags$style(type="text/css", '#showMap {width: 150px; margin-left:0px;}'),
		tags$style(type="text/css", '#dlCurPlot {width: 120px; margin-left:100px;}'))
	),
	mainPanel(
		tabsetPanel(
			tabPanel("Conditional Barplots",plotOutput("plot",height="auto"),value="barplots"),
			tabPanelAbout(),
			id="tsp"
		)
	)
))
