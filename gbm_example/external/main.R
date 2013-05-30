mainPanel(
	tabsetPanel(
		tabPanel("Relative Influence", textOutput("num.cv.folds"), plotOutput("plot.ri",height="auto"), tableOutput("ri.table"), value="ri"),
		tabPanel("Error Curves", plotOutput("plot.best.iter",height="auto"), tableOutput("best.iter.table"), value="ri"),
		tabPanelAbout(),
		id="tsp"
	)
)
