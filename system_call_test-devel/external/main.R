mainPanel(
	tabsetPanel(
		tabPanel("Home", 
			div(verbatimTextOutput("Obs_UpdateFiles")style="height: 100px;"), h1(textOutput("WelcomeTitle")), h3(textOutput("WelcomeSubtitle")), value="home"),
		tabPanel("View FIF", 
			div(verbatimTextOutput("FIF_Lines"), style="height: 650px;"), value="fif"),
		tabPanelAbout(),
		id="tsp"#,
		#type="pills",
		#selected="home"
	)
)
