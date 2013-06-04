sidebarPanel(
	tags$head(
		tags$style(type="text/css", "label.radio { display: inline-block; }", ".radio input[type=\"radio\"] { float: none; }"),
		tags$style(type="text/css", "select { max-width: 150px; }"),
		tags$style(type="text/css", "textarea { max-width: 150px; }"),
		tags$style(type="text/css", ".jslider { max-width: 500px; }"),
		tags$style(type='text/css', ".well { max-width: 500px; }"),
		tags$style(type='text/css', ".span4 { max-width: 500px; }")
	  ),
	uiOutput("showMapPlot"),
	wellPanel(
		h5("Select dataset"),
		div(class="row-fluid", div(class="span6", uiOutput("dat.name"), actionButton("goButton", "Build Model")), div(class="span6", uiOutput("vars"))),
		tags$style(type="text/css", '#dat.name {width: 150px}'),
		tags$style(type="text/css", '#vars {width: 150px}')
	),
	wellPanel(
		h5("GBM meta-parameters"),
		uiOutput("n.trees"),
		div(class="row-fluid", div(class="span6", uiOutput("interaction.depth")), div(class="span6", uiOutput("shrinkage"))),
		div(class="row-fluid", div(class="span6", uiOutput("train.fraction")), div(class="span6", uiOutput("bag.fraction"))),
		div(class="row-fluid", div(class="span6", uiOutput("cv.folds")), div(class="span6", uiOutput("n.minobsinnode"))),
		tags$style(type="text/css", '#interaction.depth {width: 150px}'),
		tags$style(type="text/css", '#shrinkage {width: 150px}'),
		tags$style(type="text/css", '#training.fraction {width: 150px}'),
		tags$style(type="text/css", '#bag.fraction {width: 150px}'),
		tags$style(type="text/css", '#cv.folds {width: 150px}'),
		tags$style(type="text/css", '#n.minobsinnode {width: 150px}')
	)
)
