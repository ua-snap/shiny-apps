sidebarPanel(
	wellPanel(
		fluidRow(column(11, uiOutput("yrs")), column(1, helpPopup('Choose years','Years are chosen in groups by decade.'))),
		fluidRow(
			column(5, uiOutput("mo")),
			column(5, offset=1, uiOutput("var")),
			column(1,
				helpPopup('Choose a wind variable','You may select wind magnitude (directionless) or direction wind components.
					WE winds blow west to east and NS winds blow south to north, like axes on an X-Y graph.'),
			)
		),
		fluidRow(
			column(5, uiOutput("rcp")),
			column(5, offset=1, uiOutput("mod")),
			column(1,
				helpPopup('Choose an RCP and model','You may select a single GCM for wind outputs.
					Unlike sea ice, composite models are not used for extreme wind events because averaging the models masks extreme events unless they happen to occur on the same day in all three models.
					You may select a single RCP. Only two RCPs are available for the wind data. Sea ice data are strictly RCP 8.5.'),
			)
		),
		fluidRow(
			column(5, uiOutput("cut")),
			column(5, offset=1, uiOutput("direction")),
			column(1,
				helpPopup('Set threshold','You may select from among 6 different thresholds when viewing directional wind compoents. For wind magnitude, the negative sign is ignored.
					When looking for extreme events using one of the direction wind compoents, it is pertinent to select above and below for positively and negatively valued threshold velocities, respectively.'),
			)
		),
		fluidRow(
			column(5, uiOutput("sea")),
			column(5, offset=1, uiOutput("coast")),
			column(1,
				helpPopup('Choose a sea','You may select from among three different arctic seas.
					For any sea, you may focus on wind events and sea ice concentrations averaed over the entire sea or over a coastal segment of the sea only.')
			)
		)
	),
	h5(textOutput("pageviews"))
)
