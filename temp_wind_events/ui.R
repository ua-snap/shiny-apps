library(shiny)
library(shinythemes)

tabPanelAbout <- source("about.R")$value
headerPanel_2 <- function(title, h, windowTitle = title) {    
  tagList(
    tags$head(tags$title(windowTitle)), 
      h(title)
    )
}

shinyUI(fluidPage(theme = shinytheme("spacelab"), 
	headerPanel_2(
		HTML('CMIP5 Quantile-mapped GCM Daily Data
			<a href = "http://accap.uaf.edu" target = "_blank"><img id = "stats_logo" align = "right" style = "margin-left: 15px;" alt = "ACCAP Logo" src = "./img/ACCAP_acronym_100px.png" /></a>
			<a href = "http://snap.uaf.edu" target = "_blank"><img id = "stats_logo" align = "right" alt = "SNAP Logo" src = "./img/SNAP_acronym_100px.png" /></a>'
		), h3, "CMIP5 Quantile-mapped GCM Daily Data"
	), 
	wellPanel(
		fluidRow(
			column(2, selectInput("mo", "Show months:", choices = c("All", mos), selected = "Jan", multiple = T, width = "100%")), 
			column(2, uiOutput("MoHi")), 
			column(8, sliderInput("yrs", "", 1958, 2100, c(1981, 2010), step = 1, sep = "", width = "100%"))
		)
	), 
	fluidRow(column(4, 
		uiOutput("showMapPlot"), 
		wellPanel(
			h5("Climate and Geography"), 
			fluidRow(
				column(6, selectInput("var", "Climate variable:", choices = var.nam, selected = var.nam[1], multiple = T, width = "100%")), 
				column(6, selectInput("loc", "Geographic location:", choices = sort(loc.nam), selected = sort(loc.nam)[3], multiple = T, width = "100%"))), 
			fluidRow(
				column(6, selectInput("mod", "Climate model:", choices = mod.nam, selected = mod.nam[1], width = "100%")), 
				column(6, selectInput("rcp", "RCP:", choices = rcp.nam, selected = rcp.nam[1], width = "100%")))
		), 
		wellPanel(
			h5("Thresholds and Conditionals"), 
			fluidRow(
				column(6, selectInput("cut.t", "Temp. threshold (C):", choices = temp.cut, selected = temp.cut[6], multiple = T, width = "100%")), 
				column(6, uiOutput("CutW"))), 
			fluidRow(
				column(6, selectInput("direct", "Days per month:", choices = c("Above threshold", "Below threshold"), selected = "Above threshold", width = "100%")), 
				column(6, selectInput("cond", "Conditional variable:", choices = c("Model", "RCP", "Location", "Threshold", "Variable"), selected = "Model", width = "100%"))), 
			p("Positive values for directional wind components indicate West to East and South to North, like an X-Y graph.")
		), 
		wellPanel(fluidRow(column(6, checkboxInput("showmap", "Show location grid", F)), column(6, downloadButton("dlCurPlot", "Download Graphic", class = "btn-block btn-primary"))))
	), 
	column(8, 
		tabsetPanel(
			tabPanel("Conditional Barplots", plotOutput("plot", width = "100%", height = "auto"), value = "barplots"), 
			tabPanelAbout(), 
			id = "tsp"
		)
	))
))
