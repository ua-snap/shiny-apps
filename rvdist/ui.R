about_app <- HTML("<p style='align-justify'>This app is a 2017 revision and simplicification of the early 2013 random variables versions 1 - 4 apps series. It plots probability density and mass functions for various continuous and discrete random variables based on your specified distribution parameters.</p>")
vx <- c("", "V2", "V3", "V4")
old_apps_url <- paste0("https://uasnap.shinyapps.io/RV_distributions", vx)
old_app_img <- paste0("https://github.com/ua-snap/shiny-apps/raw/master/_images/small/RV_distributions", vx, ".jpg")
old_titles <- paste0("Random variables v", 1:4)
old_subs <- rep("Probability distributions", 4)
old_labs <- lapply(paste("RVs version", 1:4), h4)
app_title <- "Distributions of random variables"

library(apputils)
library(snaputils)
shinyUI(fluidPage(title = app_title,
  use_apputils(),
	fluidRow(column(12,
		HTML('<h1>Distributions of Random Variables
			<a href="http://snap.uaf.edu" target="_blank"><img align="right" src="snap_acronym_color.svg" height="35px"/></a></h1>'
		)
	)),
  conditionalPanel("input.tsp === 'Plot'",
    fluidRow(
     column(2, selectInput("dist", "Distribution", list(continuous = continuous, discrete = discrete))),
     column(2, numericInput("n","Sample size", 10000)),
     column(2, uiOutput("dist1")),
     column(2, uiOutput("dist2")),
     column(2, uiOutput("dist3")),
     column(2, div(style="margin-top: 26px;", downloadButton("dlCurPlot", "Download plot", class = "btn-block btn-primary")))
    )
  ),
  fluidRow(
		column(12,
			tabsetPanel(
				tabPanel("Plot", plotOutput("plot", height = "700px")),
				tabPanel("Information",
          h2("About this application"),
          about_app,
          h3("Recommended citation"),
          app_citation("Matthew Leonawicz", 2017,
                      title = "Web application for exploring the parameter space of distributions of common random variables",
                      publisher = "Scenarios Network for Alaska and Arctic Planning, University of Alaska Fairbanks",
                      url = "http://shiny.snap.uaf.edu/rvdist", heading = "The application", heading_size = "h4"),
          app_citation("Matthew Leonawicz", 2017,
                      title = "snapapps: A Shiny apps collection R package",
                      publisher = "Scenarios Network for Alaska and Arctic Planning, University of Alaska Fairbanks",
                      url = "https://leonawicz.github.io/snapapps", heading = "Encapsulating R package", heading_size = "h4"),
          hr(),
          h2("Original series"),
          p("The apps below are the 2013 versions, which were part of a series showing sucessive additions to the app as it was originally developed. These were made when the Shiny package was in alpha and are maintained only as legacy examples."),
          app_showcase(old_apps_url, old_app_img, old_titles, old_subs, old_labs),
          hr(),
          contactinfo(snap = "snap_color.svg", iarc = "iarc.jpg", uaf = "uaf.png"),
          br(), br()
				), id = "tsp"
			)
		)
	)
))
