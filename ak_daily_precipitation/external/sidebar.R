sidebarPanel_2(
	span="span3",
	tags$head(
		tags$link(rel="stylesheet", type="text/css", href="styles_black_orange.css"),
		tags$link(rel="stylesheet", type="text/css", href="jquery.slider.min.css"),
		tags$style(type="text/css", "select { max-width: 180px; }"),
		tags$style(type="text/css", "textarea { max-width: 300px; }"),
		tags$style(type="text/css", ".jslider { max-width: 400px; }"),
		tags$style(type='text/css', ".well { max-width: 400px; }")
	),
	wellPanel(
		div(class="row-fluid",
		div(class="span6", checkboxInput("showWP1",h5("Data selection"),TRUE)),
		div(class="span6", uiOutput("genPlotButton"))
		),
		conditionalPanel(condition="input.showWP1",
			div(class="row-fluid",
				div(class="span11",uiOutput("loc")),
				div(class="span1",helpPopup('Choose location','<p style="text-align:justify">Currently only Fairbanks, AK is available.</p>'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("yrs")),
				div(class="span1",helpPopup('Choose consecutive years','<p style="text-align:justify">This is an initial subsetting of the data. Years refer to calendar years.</p>'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("mo")),
				div(class="span1",helpPopup('Choose 1st month of precipitation year','<p style="text-align:justify">The annual precipitation cycle is defined as the 1st day of the selected month.</p>'))
			),
			#div(class="row-fluid",
			#	div(class="span11",uiOutput("ph1")),
			#	div(class="span1",helpPopup('Placeholder 1','<p style="text-align:justify">This option currently has no functionality.</p>'))
			#),
			div(class="row-fluid",
				div(class="span11",uiOutput("var")),
				div(class="span1",helpPopup('Choose a variable','<p style="text-align:justify">Currently, only precipitation is available.</p>'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("dailyColPal")),
				div(class="span1",helpPopup('Choose a color palette','<p style="text-align:justify">Currently two options. I would like to add the ability for people to design their own.</p>'))
			)#,
			#div(class="row-fluid",
			#	div(class="span11",uiOutput("ph2")),
			#	div(class="span1",helpPopup('Placeholder 2','<p style="text-align:justify">This option currently has no functionality.</p>'))
			#),
			#div(class="row-fluid",
			#	div(class="span11",uiOutput("ph3")),
			#	div(class="span1",helpPopup('Placeholder 3','<p style="text-align:justify">This option currently has no functionality.</p>'))
			#)
		)
	),
	wellPanel(
		checkboxInput("showWP2",h5("Color/Size rescaling"),FALSE),
		conditionalPanel(condition="input.showWP2",
			div(class="row-fluid",
				div(class="span11",uiOutput("tfColCir")),
				div(class="span1",helpPopup('Main panel relative circle size and color',hp.tfColCir))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("tfCirCexMult")),
				div(class="span1",helpPopup('Main panel relative circle size cex multiplier',hp.tfCirCexMult))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("tfColMar")),
				div(class="span1",helpPopup('Historical mean relative circle color',hp.tfColMar))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("tfColBar")),
				div(class="span1",helpPopup('Bar plot relative color',hp.tfColBar))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("htCompress")),
				div(class="span1",helpPopup('Vertical plot compression factor',hp.htCompress))
			)
		)
	),
	wellPanel(
		checkboxInput("showWP3",h5("Include marginal panels"),FALSE),
		conditionalPanel(condition="input.showWP3",
			div(class="row-fluid",
				div(class="span11",uiOutput("meanHistorical")),
				div(class="span1",helpPopup('Include/exclude marginal panels',hp.marginalPanels))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("bars6mo"))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("mean6mo"))
			)
		)
	),
		wellPanel(
		checkboxInput("showWP4",h5("Allowable missing values"),FALSE),
		conditionalPanel(condition="input.showWP4",
			div(class="row-fluid",
				div(class="span11",uiOutput("maxNAperMo")),
				div(class="span1",helpPopup('Missing values',hp.missingValues))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("maxNAperYr"))
			)
		)
	)
)
