library(shinythemes)
tabPanelAbout <- source("external/about.R", local=T)$value

shinyUI(fluidPage(theme=shinytheme("flatly"),
	navbarPage(
		title=div(a(img(src="./img/SNAP_acronym_100px.png", width="50%"), "", href="http://snap.uaf.edu", target="_blank")),
		#tabPanel("Home", h4("Random Forest"), value="home"),
		#navbarMenu("Classification Information", 
			tabPanel("Class Error", value="classError"),
			tabPanel("Class Margins", value="margins"),
			tabPanel("2-D MDS",value="mds"),
			tabPanel("Partial Dependence", value="pd"),
			tabPanel("Outliers", value="outliers"),
		#),
		#navbarMenu("Importance Measures", 
			tabPanel("Importance: OOB", value="impAcc"),
			tabPanel("Importance: Gini", value="impGini"),
			tabPanel("Importance: Table", value="impTable"),
		#),
		#navbarMenu("Error and Variable Selection", 
			tabPanel("Error Rate", value="errorRate"),
			tabPanel("Variable Use", value="varsUsed"),
			tabPanel("Number of Variables", value="numVar"),
		#),
		tabPanel("About the app", value="about"),
		windowTitle="Random Forest",
		collapsible=TRUE,
		#inverse=TRUE,
		id="tsp"
	),
	#tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),
	fluidRow(column(12, "I would use dropdown menus to condense the navbar above but 'tabsetPanel' cannot take an 'id' argument in the current version of Shiny.")),
	fluidRow(
		source("external/sidebar.R",local=T)$value,
		source("external/main.R",local=T)$value
	)
))
