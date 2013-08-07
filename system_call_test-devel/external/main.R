mainPanel(
	conditionalPanel(condition='input.goButton > 0', # change to zero
	tabsetPanel(
		tabPanel("System Call", 
			textOutput("sysCall"), value="sc"),
		tabPanelAbout(),
		id="tsp"
	)
	)
)
