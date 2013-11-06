sidebarPanel_2(
	span="span3",
	tags$head(
		#tags$link(rel="stylesheet", type="text/css", href="styles_black_orange.css"),
		#tags$link(rel="stylesheet", type="text/css", href="jquery.slider.min.css"),
		tags$style(type="text/css", "select { max-width: 500px; }"),
		tags$style(type="text/css", "textarea { max-width: 500px; }"),
		tags$style(type="text/css", ".jslider { max-width: 500px; }"),
		tags$style(type='text/css', ".well { max-width: 500px; }")
	),
	wellPanel(
		checkboxInput("showWP1",h5("Data selection"),TRUE),
		conditionalPanel(condition="input.showWP1",
			div(class="row-fluid",
				div(class="span11",uiOutput("dataset")),
				div(class="span1",helpPopup('Choose dataset','Datasets are currently oddly named.'))
			),
			div(class="row-fluid",
				div(class="span6", downloadButton("dl_macorplotPDF","Download PDF")),
				div(class="span6", downloadButton("dl_macorplotPNG","Download PNG"))
			)
		)
	)
)
