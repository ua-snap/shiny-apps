column(8,
	tabsetPanel(
		tabPanel("2D Contour", conPan_LA, plotOutput("plot_2D_contour",height="auto"), value="p2Dcontour"),
		tabPanel("2D Image", conPan_LA,	plotOutput("plot_2D_image",height="auto"), value="p2Dimage"),
		tabPanel("3D Perspective", conPan_LA, plotOutput("plot_3D_persp",height="auto"), value="p3Dpersp"),
		tabPanel("3D Ribbon", conPan_LA, plotOutput("plot_3D_ribbon",height="auto"), value="p3Dribbon"),
		tabPanel("3D Histogram", conPan_LA, plotOutput("plot_3D_hist",height="auto"), value="p3Dhist"),
		tabPanel("3D Interactive", webGLOutput("plot_3D_rgl",height="auto"), value="p3Drgl"),
		tabPanelAbout(),
		tabPanel("R Code",
			#uiOutput("codeTab"), # This single line preferable to the below lines
			# Cannot use the above style due to known bug in shinyAce package
			conditionalPanel(condition="input.nlp==='nlp_aboutR'", show_aboutR),
			conditionalPanel(condition="input.nlp==='nlp_appR'", show_appR),
			conditionalPanel(condition="input.nlp==='nlp_globalR'", show_globalR),
			# cannot include "header" if it contains Google Analytics tracking code
			#conditionalPanel(condition="input.nlp==='nlp_headerR'", show_headerR),
			conditionalPanel(condition="input.nlp==='nlp_mainR'", show_mainR),
			conditionalPanel(condition="input.nlp==='nlp_reactivesR'", show_reactivesR),
			conditionalPanel(condition="input.nlp==='nlp_serverR'", show_serverR),
			conditionalPanel(condition="input.nlp==='nlp_sidebarR'", show_sidebarR),
			conditionalPanel(condition="input.nlp==='nlp_uiR'", show_uiR),
			value="rcode"),
		id="tsp",
		type="pills",
		selected="about"
	)
)
