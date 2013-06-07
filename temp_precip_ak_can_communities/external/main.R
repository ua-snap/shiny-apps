mainPanel(
	tabsetPanel(
		tabPanel("Communities",
		plotOutput("plot.lp",height="auto"),
		div(class="row-fluid",
			div(class="span2", uiOutput("colorseq")),
			div(class="span2", uiOutput("colorpalettes")),
			div(class="span2", uiOutput("bartype")),
			div(class="span2", uiOutput("bardirection"))
		),
		tableOutput("subset.table"), value="communities"),
		tabPanel("Regions", textOutput("show.gbm1.object.names.if.created.successfully"), value="regions"),
		tabPanelAbout(),
		id="tsp"
	)
)
