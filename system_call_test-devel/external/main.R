mainPanel(
	tabsetPanel(
		tabPanel("Home", 
			div(verbatimTextOutput("Obs_UpdateFiles"), style="height: 100px;"), value="home"),
		tabPanel("View FIF", 
			div(verbatimTextOutput("FIF_Lines"), style="height: 650px;"), value="fif"),
		tabPanelAbout(),
		id="tsp"#,
		#type="pills",
		#selected="home"
	)
)
