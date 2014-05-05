mainPanel( # testing
	tabsetPanel(
		tabPanel("Home", 
			h1(textOutput("WelcomeTitle")), h3(textOutput("WelcomeSubtitle")), div(verbatimTextOutput("Obs_UpdateFiles"), style="height: 400px;"), value="home"),
		tabPanel("View JSON", 
			div(verbatimTextOutput("JSON_Lines"), style="height: 800px;"), value="viewjson"),
		tabPanelAbout(),
		tabPanel("R Code",
			#uiOutput("codeTab"), # This single line preferable to the below lines
			# Cannot use the above style due to known bug in shinyAce package
			#conditionalPanel(condition="input.nlp==='nlp_aboutR'", show_aboutR),
			#conditionalPanel(condition="input.nlp==='nlp_appR'", show_appR),
			#conditionalPanel(condition="input.nlp==='nlp_globalR'", show_globalR),
			# cannot include "header" if it contains Google Analytics tracking code
			#conditionalPanel(condition="input.nlp==='nlp_headerR'", show_headerR),
			conditionalPanel(condition="input.nlp==='nlp_io.sidebar.wp1R'", show_io.sidebar.wp1R),
			conditionalPanel(condition="input.nlp==='nlp_io.sidebar.wp2R'", show_io.sidebar.wp2R),
			conditionalPanel(condition="input.nlp==='nlp_mainR'", show_mainR),
			conditionalPanel(condition="input.nlp==='nlp_reactivesR'", show_reactivesR),
			conditionalPanel(condition="input.nlp==='nlp_serverR'", show_serverR),
			conditionalPanel(condition="input.nlp==='nlp_sidebarR'", show_sidebarR),
			conditionalPanel(condition="input.nlp==='nlp_uiR'", show_uiR),
			value="rcode"),
		id="tsp",
		type="pills",
		selected="home"
	)
)
