about <- "This web application displays plots of bootstrapped, 50-year moving average correlations between tree growth and both temperature and precipitation at various sites."
title <- "Tree growth and climate"
link <- '<a href="http://snap.uaf.edu" target="_blank"><img align="right" src="snap_acronym_color.svg" height="35px"/></a>'
header <- HTML(paste0('<h2>', title, link, '</h2>'))

shinyUI(fluidPage(title = title, 
  header,
	fluidRow(
	  column(3,
      wellPanel(
        selectInput("dataset", "Dataset:", data.names, width="100%"),
        p(about, style = "text-align: justify;"),
        fluidRow(
          column(6, downloadButton("dl_macorplotPDF","Get PDF", class = "btn-block")),
          column(6, downloadButton("dl_macorplotPNG","Get PNG", class = "btn-block"))
        )
      )
	  ),
	  column(9, plotOutput("macorplot", width="100%", height="auto"))
	)
))
