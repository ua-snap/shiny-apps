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
			uiOutput("codeTab"),
			value="rcode"),
		id="tsp",
		type="pills",
		selected="about"
	)
)
