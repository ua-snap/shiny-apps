sidebarPanel_2(
	span="span3",
	tags$head(
		tags$style(type="text/css", "select { max-width: 120px; }"),
		tags$style(type="text/css", "textarea { max-width: 300px; }"),
		tags$style(type="text/css", ".jslider { max-width: 400px; }"),
		tags$style(type='text/css', ".well { max-width: 400px; }")
	),
	wellPanel(
		checkboxInput("showWP1",h5("Data selection"),FALSE),
		conditionalPanel(condition="input.showWP1",
			div(class="row-fluid",
				div(class="span11",uiOutput("yrs")),
				div(class="span1",helpPopup('Choose years','Years are chosen in groups by decade.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("mo")),
				div(class="span1",helpPopup('Choose a month','You may select a single month. Multi-month selections are not available.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("rcp")),
				div(class="span1",helpPopup('Choose an RCP','You may select a single RCP. Only two RCPs are available for the wind data. Sea ice data are strictly RCP 8.5.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("var")),
				div(class="span1",helpPopup('Choose a wind variable','You may select wind magnitude (directionless) or direction wind components. WE winds blow west to east and NS winds blow south to north, like axes on an X-Y graph.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("cut")),
				div(class="span1",helpPopup('Choose an threshold','You may select from among 6 different thresholds when viewing directional wind compoents. For wind magnitude, the negative sign is ignored.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("sea")),
				div(class="span1",helpPopup('Choose a sea','You may select from among three different arctic seas.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("coast")),
				div(class="span1",helpPopup('Choose an area','For any sea, you may focus on wind events and sea ice concentrations averaed over the entire sea or over a coastal segment of the sea only.'))
			)
		)
	)
)
