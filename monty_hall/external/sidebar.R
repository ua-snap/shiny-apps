sidebarPanel_2(
	span="span3",
	tags$head(
		tags$link(rel="stylesheet", type="text/css", href="styles_black_yellow.css"),
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
				div(class="span11",uiOutput("totaldoors")),
				div(class="span1",helpPopup('Number of doors in game','This is the total number of doors, N. If N even, player may select, and subsequently Monty may open, 1 to N/2 - 1 doors each (mutually exclusive). If N odd, then (N - 1)/2 doors each.'))
			),
			div(class="row-fluid",
				div(class="span6", downloadButton("dl_mhplotPDF","Download PDF")),
				div(class="span6", downloadButton("dl_mhplotPNG","Download PNG"))
			)
		)
	),
	h5(textOutput("pageviews"))
)
