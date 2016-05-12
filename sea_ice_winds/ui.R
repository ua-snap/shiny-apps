source("external/uiHead.R",local=T)
shinyUI(fluidPage(theme=shinytheme("spacelab"),
	headerPanel_2(
		HTML('Sea Ice Concentrations and Wind Events
			<a href="http://accap.uaf.edu" target="_blank"><img id="stats_logo" align="right" style="margin-left: 15px;" alt="ACCAP Logo" src="./img/ACCAP_acronym_100px.png" /></a>
			<a href="http://snap.uaf.edu" target="_blank"><img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" /></a>'
		), h3, "Wind events and sea ice"
	),
  tags$head(includeScript("ga-sea_ice_winds.js"), includeScript("ga-allapps.js")),
	fluidRow(
		source("external/sidebar.R",local=T)$value,
		source("external/main.R",local=T)$value
	)
))
