column(4,
	uiOutput("showMapPlot"),
	wellPanel(
		h5("Select dataset"),
		div(class="row-fluid",
			div(class="span6", selectInput("dat.name","Data:",choices="Simulated data",selected="Simulated data"),
			actionButton("goButton", "Build Model")),
			div(class="span6", uiOutput("vars")))
	),
	wellPanel(
		h5("GBM meta-parameters"),
		uiOutput("n.trees"),
		div(class="row-fluid", div(class="span6", uiOutput("interaction.depth")), div(class="span6", uiOutput("shrinkage"))),
		div(class="row-fluid", div(class="span6", uiOutput("train.fraction")), div(class="span6", uiOutput("bag.fraction"))),
		div(class="row-fluid", div(class="span6", uiOutput("cv.folds")), div(class="span6", uiOutput("n.minobsinnode")))
	),
	conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
)
