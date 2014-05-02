mainPanel(
	tabsetPanel(
		tabPanel("R plot3D examples",
			conditionalPanel(condition="input.plottype!='3D - interactive (rgl)'",
				plotOutput("plot1",height="auto")
			),
			br(),
			conditionalPanel(condition="input.plottype=='3D - interactive (rgl)'",
				webGLOutput("plot2",height="auto")
			),
			value="plots"),
		tabPanelAbout(),
		tabPanel("R Code",
			#uiOutput("codeTab"), # This single line preferable to the below lines
			# Cannot use the above style due to known bug in shinyAce package
			conditionalPanel(condition="input.nlp==='nlp_aboutR'", show_aboutR),
			conditionalPanel(condition="input.nlp==='nlp_appR'", show_appR),
			conditionalPanel(condition="input.nlp==='nlp_globalR'", show_globalR),
			# cannot include "header" if it contains Google Analytics tracking code
			#conditionalPanel(condition="input.nlp==='nlp_headerR'", show_headerR),
			conditionalPanel(condition="input.nlp==='nlp_io.sidebar.wp1R'", show_io.sidebar.wp1R),
			conditionalPanel(condition="input.nlp==='nlp_io.sidebar.wp2R'", show_io.sidebar.wp2R),
			conditionalPanel(condition="input.nlp==='nlp_io.sidebar.wp3R'", show_io.sidebar.wp3R),
			conditionalPanel(condition="input.nlp==='nlp_io.sidebar.wp4R'", show_io.sidebar.wp4R),
			conditionalPanel(condition="input.nlp==='nlp_io.sidebar.wp5R'", show_io.sidebar.wp5R),
			conditionalPanel(condition="input.nlp==='nlp_io.sidebar.wp6R'", show_io.sidebar.wp6R),
			#conditionalPanel(condition="input.nlp==='nlp_mainR'", show_mainR),
			#conditionalPanel(condition="input.nlp==='nlp_reactivesR'", show_reactivesR),
			#conditionalPanel(condition="input.nlp==='nlp_serverR'", show_serverR),
			#conditionalPanel(condition="input.nlp==='nlp_sidebarR'", show_sidebarR),
			#conditionalPanel(condition="input.nlp==='nlp_uiR'", show_uiR),
			value="rcode"),
		id="tsp",
		type="pills",
		selected="about"
	)
)
