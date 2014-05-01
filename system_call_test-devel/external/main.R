mainPanel(
	tabsetPanel(
		tabPanel("Home", 
			h1(textOutput("WelcomeTitle")), h3(textOutput("WelcomeSubtitle")), div(verbatimTextOutput("Obs_UpdateFiles"), style="height: 400px;"), value="home"),
		tabPanel("View FIF", 
			div(verbatimTextOutput("FIF_Lines"), style="height: 650px;"), value="fif"),
		tabPanelAbout(),
		id="tsp",
		type="pills",
		selected="home"
	)
)
