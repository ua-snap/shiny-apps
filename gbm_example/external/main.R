mainPanel(
	tabsetPanel(
		tabPanel("Relative Influence", h4(uiOutput("no.vars.selected")), textOutput("show.gbm1.object.names.if.created.successfully"), plotOutput("plot.ri",height="auto"), 
				#tableOutput("ri.table"),
				div(class="row-fluid", div(class="span4", tableOutput("ri.table.oob")), div(class="span4", tableOutput("ri.table.test")), div(class="span4", tableOutput("ri.table.cv"))),
				value="ri"),
		tabPanel("Error Curves", plotOutput("plot.best.iter",height="auto"), tableOutput("best.iter.table"), value="error"),
		tabPanelAbout(),
		id="tsp"
	)
)
