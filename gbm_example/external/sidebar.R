column(4,
	uiOutput("showMapPlot"),
	wellPanel(
		h5("Select dataset"),
		fluidRow(
			column(6, selectInput("dat.name","Data:",choices="Simulated data",selected="Simulated data")),
			column(6, uiOutput("vars"))
		)
	),
	wellPanel(
		h5("GBM meta-parameters"),
		uiOutput("n.trees"),
		fluidRow(column(6, uiOutput("interaction.depth")), column(6, uiOutput("shrinkage"))),
		fluidRow(column(6, uiOutput("train.fraction")), column(6, uiOutput("bag.fraction"))),
		fluidRow(column(6, uiOutput("cv.folds")), column(6, uiOutput("n.minobsinnode"))),
		actionButton("goButton", "Build Model", class="btn-block btn-primary")
	)
)
