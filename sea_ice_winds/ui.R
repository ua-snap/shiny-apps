library(shinythemes)

tabPanelAbout <- source("about.R", local  =  TRUE)$value

headerPanel_2 <- function(title, h, windowTitle  =  title) {    
  tagList(
    tags$head(tags$title(windowTitle)), 
    h(title)
  )
}

shinyUI(fluidPage(theme = shinytheme("spacelab"), 
	headerPanel_2(
		HTML('Sea Ice Concentrations and Wind Events
			<a href="http://accap.uaf.edu" target="_blank"><img id="stats_logo" align="right" style="margin-left: 15px;" alt="ACCAP Logo" src="./img/ACCAP_acronym_100px.png" /></a>
			<a href="http://snap.uaf.edu" target="_blank"><img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" /></a>'
		), h3, "Wind events and sea ice"
	), 
	fluidRow(
	  column(4, 
	         wellPanel(
	           fluidRow(
	             column(12, sliderInput("yrs", "Decades:", min = decades[1], max = tail(decades, 1), value = range(decades), 
	                                    step = 10, sep = "", post = "s", width = "100%"))
	           ), 
	           fluidRow(
	             column(6, selectInput("mo", "Month:", choices = month.abb, selected = month.abb[1], width = "100%")), 
	             column(6, selectInput("var", "Variable:", choices = varlevels, selected = varlevels[3], width = "100%"))
	           ), 
	           fluidRow(
	             column(6, selectInput("rcp", "Winds RCP:", choices = c("RCP 6.0", "RCP 8.5"), selected = "RCP 6.0", width = "100%")), 
	             column(6, selectInput("mod", "Winds model:", choices = models, selected = models[1], width = "100%"))
	           ), 
	           fluidRow(
	             column(6, selectInput("cut", "Threshold (m/s):", choices = cuts, selected = cuts[1], width = "100%")), 
	             column(6, selectInput("direction", "Above/below threshold:", choices = c("Above", "Below"), selected = "Above", width = "100%"))
	           ), 
	           fluidRow(
	             column(6, selectInput("sea", "Sea:", choices = seas, selected = seas[1], width = "100%")), 
	             column(6, radioButtons("coast", "Area:", choices = c("Coastal only", "Full sea"), selected = "Coastal only"))
	           )
	         ), 
	         plotOutput("SeaPlot", width = "100%", height = "auto"), 
	         br(), br()
	  ), 
	  column(8, 
      tabsetPanel(
        tabPanel("Time series plots", 
          plotOutput("plotByYear", width = "100%", height = "auto"), 
          plotOutput("plotByDecade", width = "100%", height = "auto"), br(), br(), 
          fluidRow(
            column(6, downloadButton("dl_plotByYear", "Annual graphic", class = "btn-block btn-primary"), br()), 
            column(6, downloadButton("dl_plotByDecade", "Decadal graphic", class = "btn-block btn-primary"))
          ), 
          value = "ts"), 
        tabPanelAbout(), 
        id = "tsp"
      )
	  )
	)
))
