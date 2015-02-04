library(shinythemes)
tabPanelAbout <- source("about.r")$value
mos <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}

shinyUI(fluidPage(theme=shinytheme("united"),
	headerPanel_2(uiOutput("header"), h3, "CRU/Weather Station EDA"),
	column(4,
	wellPanel(
		selectInput("dataset", "Choose a dataset:", choices=c("Weather stations (w/ missing data)", "Weather stations (CRU-substituted NAs)", "2-km downscaled CRU 3.1"), selected="2-km downscaled CRU 3.1"),
		uiOutput("cityNames"),
		conditionalPanel( # Main tabs part 1
			condition="input.tsp=='notmap'",
			uiOutput("multCity"),
			uiOutput("Var")
		),
		conditionalPanel( # Regression tab part 1
			condition="input.tsp=='reg'",
			uiOutput("regInputY"),
			uiOutput("regInputX")
		),
		uiOutput("yearSlider"), # Same slider occurs on main and regression tabs
		conditionalPanel( # Main tabs part 2
			condition="input.tsp=='notmap'",
			uiOutput("Mo"),
			uiOutput("multMo"),
			uiOutput("multMo2"),
			uiOutput("histBin"),
			uiOutput("histBinNum"),
			uiOutput("histIndObs"),
			uiOutput("histDensCurve"),
			uiOutput("histDensCurveBW"),
			downloadButton("dldat", "Get Data", class="btn-block btn-primary")
		),
		conditionalPanel( # Regression tabs part 2
			condition="input.tsp=='reg'",
			uiOutput("regCondMo"),
			uiOutput("regpoints"),
			uiOutput("reglines"),
			uiOutput("regablines"),
			uiOutput("regGGPLOTse"),
			uiOutput("regGGPLOT")
		)
	)
	),
	column(8,
		tabsetPanel(
			tabPanel("Distributions", plotOutput("plot", width="100%", height="auto"), value="notmap"),
			tabPanel("Summary Statistics", verbatimTextOutput("summary"), value="notmap"),
			tabPanel("Data", tableOutput("table"), value="notmap"),
			tabPanel("Regression", plotOutput("regplot", width="100%", height="auto"), verbatimTextOutput("regsum"), value="reg"),
			tabPanelAbout(),
			id="tsp"
		)
	)
))
