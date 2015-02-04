source("external/uiHead.R",local=T)
shinyUI(pageWithSidebar(
	headerPanel_2(
		HTML('Customizable charts: US communities, daily precipitation
			<a href="http://snap.uaf.edu" target="_blank"><img id="stats_logo" align="right" alt="SNAP Logo" src="./img/SNAP_acronym_for-dark-bkgrnd_100px.png" /></a>'
		), h4, "US daily precipitation"
	),
	source("external/sidebar.R",local=T)$value,
	source("external/main.R",local=T)$value
))
