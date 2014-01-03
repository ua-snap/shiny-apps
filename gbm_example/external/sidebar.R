sidebarPanel(
	tags$head(
		tags$style(type="text/css", "select { max-width: 500px; width: 100%; }"),
		tags$style(type="text/css", "textarea { max-width: 500px; width: 100%; }"),
		tags$style(type="text/css", ".jslider { max-width: 500px; width: 100%; }"),
		tags$style(type="text/css", ".well { max-width: 500px; }")
	  ),
	uiOutput("showMapPlot"),
	wellPanel(
		h5("Select dataset"),
		div(class="row-fluid", div(class="span6", uiOutput("dat.name"), actionButton("goButton", "Build Model")), div(class="span6", uiOutput("vars")))
	),
	wellPanel(
		h5("GBM meta-parameters"),
		uiOutput("n.trees"),
		div(class="row-fluid", div(class="span6", uiOutput("interaction.depth")), div(class="span6", uiOutput("shrinkage"))),
		div(class="row-fluid", div(class="span6", uiOutput("train.fraction")), div(class="span6", uiOutput("bag.fraction"))),
		div(class="row-fluid", div(class="span6", uiOutput("cv.folds")), div(class="span6", uiOutput("n.minobsinnode")))
	),
	h5(textOutput("pageviews"))
)
