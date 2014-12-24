column(8,
	tabsetPanel(
		tabPanel("Relative Influence", plotOutput("plot.ri",height="auto"), 
				dataTableOutput("ri.table"),
				#div(class="row-fluid", div(class="span4", dataTableOutput("ri.table.oob")), div(class="span4", dataTableOutput("ri.table.test")), div(class="span4", dataTableOutput("ri.table.cv"))),
				value="ri"),
		tabPanel("Error Curves", plotOutput("plot.best.iter",height="auto"), dataTableOutput("best.iter.table"), value="error"),
		tabPanelAbout(),
		id="tsp"
	)
)
