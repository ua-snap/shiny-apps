source("external/uiHead.R", local=T)
shinyUI(fluidPage(theme=shinytheme("journal"),
	headerPanel_2(
		HTML('Tree growth and climate: Bootstrapped moving average correlations
			<a href="http://snap.uaf.edu" target="_blank"><img align="right" alt="SNAP Logo" src="./img/SNAP_acronym_100px.png" /></a>'
		), h3, "Tree growth and climate"
	),
	fluidRow(
		source("external/sidebar.R", local=T)$value,
		source("external/main.R", local=T)$value
	)
))
