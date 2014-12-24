mainPanel_2(
	span="span9",
	tabsetPanel(
		tabPanel("Monty Hall probabilities",
			#uiOutput("debugging"),
			plotOutput("mhplot",height="auto"),
			br(), value="ts"),
		tabPanelAbout(),
		id="tsp"
	)
)
