library(shiny)
shinyUI(pageWithSidebar(
	headerPanel(uiOutput("header")),
	#headerPanel(h4(textOutput("datname"))), # for debugging
	sidebarPanel(
		uiOutput("showMap"),
		uiOutput("showMapPlot"),
		sliderInput("yrs","Year range:",1958,2100,c(1981,2010),step=1,format="#"),
		uiOutput("yearSlider"),
		uiOutput("Mo"),
		uiOutput("MoHi"),
		uiOutput("Mod"),
		uiOutput("RCP"),
		uiOutput("Var"),
		uiOutput("Loc"),
		uiOutput("CutT"),
		uiOutput("CutW"),
		uiOutput("Direction"),
		uiOutput("Cond"),
		uiOutput("CondVals")
	),
	mainPanel(
		tabsetPanel(
			tabPanel("Conditional Barplots",plotOutput("plot",height="auto"),value="barplots"),
			id="tsp"
		)
	)
))
