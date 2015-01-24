column(4,
	wellPanel(
		fluidRow(
			column(12, sliderInput("yrs", "Decades:", min=decades[1], max=tail(decades, 1), value=range(decades), step=10, sep="", post="s", width="100%"))
		),
		fluidRow(
			column(6, selectInput("mo", "Month:", choices=month.abb, selected=month.abb[1], width="100%")),
			column(6, selectInput("var", "Variable:", choices=varlevels, selected=varlevels[3], width="100%"))
		),
		fluidRow(
			column(6, selectInput("rcp", "Winds RCP:", choices=c("RCP 6.0","RCP 8.5"), selected="RCP 6.0", width="100%")),
			column(6, selectInput("mod", "Winds model:", choices=models, selected=models[1], width="100%"))
		),
		fluidRow(
			column(6, selectInput("cut", "Threshold (m/s):", choices=cuts, selected=cuts[1], width="100%")),
			column(6, selectInput("direction", "Above/below threshold:", choices=c("Above","Below"), selected="Above", width="100%"))
		),
		fluidRow(
			column(6, selectInput("sea", "Sea:", choices=seas, selected=seas[1], width="100%")),
			column(6, radioButtons("coast", "Area:", choices=c("Coastal only","Full sea"), selected="Coastal only"))
		)
	),
	wellPanel(
		fluidRow(
			column(6, uiOutput("tp.annstyle")),
			column(6, uiOutput("tp.decstyle"))
		),
		fluidRow(
			column(6, downloadButton("dl_plotByYear","Annual graphic", class="btn-block btn-primary")),
			column(6, downloadButton("dl_plotByDecade","Decadal graphic", class="btn-block btn-primary"))
		)
	)
)
