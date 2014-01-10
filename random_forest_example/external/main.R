mainPanel_2(
	span="span9",
	conditionalPanel(condition='input.goButton > 0',
	uiOutput("mpContent")
	)
)
