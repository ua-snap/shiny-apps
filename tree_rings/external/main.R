mainPanel_2(
	span="span9",
	tabsetPanel(
		tabPanel("Correlation Plots",
			#uiOutput("debugging"),
			plotOutput("macorplot",height="auto"),
			br(), value="ts"),
		tabPanelAbout(),
		id="tsp"
	)
)
