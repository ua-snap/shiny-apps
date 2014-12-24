column(4,
	wellPanel(
		fluidRow(
			column(11, selectInput("yrs", "Decades:", choices=dec.lab, selected=dec.lab, multiple=T, selectize=F)),
			column(1, helpPopup('Choose years','Years are chosen in groups by decade.'))),
		fluidRow(
			column(5, selectInput("mo", "Month:", choices=month.abb, selected=month.abb[1], width="100%")),
			column(5, offset=1, selectInput("var", "Variable:", choices=varlevels, selected=varlevels[3], width="100%")),
			column(1,
				helpPopup('Choose a wind variable','You may select wind magnitude (directionless) or direction wind components.
					WE winds blow west to east and NS winds blow south to north, like axes on an X-Y graph.')
			)
		),
		fluidRow(
			column(5, selectInput("rcp", "Winds RCP:", choices=c("RCP 6.0","RCP 8.5"), selected="RCP 6.0", width="100%")),
			column(5, offset=1, selectInput("mod", "Winds model:", choices=models, selected=models[1], width="100%")),
			column(1,
				helpPopup('Choose an RCP and model','You may select a single GCM for wind outputs.
					Unlike sea ice, composite models are not used for extreme wind events because averaging the models masks extreme events unless they happen to occur on the same day in all three models.
					You may select a single RCP. Only two RCPs are available for the wind data. Sea ice data are strictly RCP 8.5.')
			)
		),
		fluidRow(
			column(5, selectInput("cut", "Threshold (m/s):", choices=cuts, selected=cuts[1], width="100%")),
			column(5, offset=1, selectInput("direction", "Above/below threshold:", choices=c("Above","Below"), selected="Above", width="100%")),
			column(1,
				helpPopup('Set threshold','You may select from among 6 different thresholds when viewing directional wind compoents. For wind magnitude, the negative sign is ignored.
					When looking for extreme events using one of the direction wind compoents, it is pertinent to select above and below for positively and negatively valued threshold velocities, respectively.')
			)
		),
		fluidRow(
			column(5, selectInput("sea", "Sea:", choices=seas, selected=seas[1], width="100%")),
			column(5, offset=1, radioButtons("coast", "Area:", choices=c("Coastal only","Full sea"), selected="Coastal only")),
			column(1,
				helpPopup('Choose a sea','You may select from among three different arctic seas.
					For any sea, you may focus on wind events and sea ice concentrations averaed over the entire sea or over a coastal segment of the sea only.')
			)
		)
	),
	conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
)
