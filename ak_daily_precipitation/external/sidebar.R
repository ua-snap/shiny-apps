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
		div(class="span6", uiOutput("GenPlotButton"))
		),
		conditionalPanel(condition="input.showWP1",
			div(class="row-fluid",
				div(class="span11",uiOutput("Loc")),
				div(class="span1",helpPopup('Choose location','There are 20 stations available. When blank, the text field is type-searchable.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("Yrs")),
				div(class="span1",helpPopup('Choose consecutive years','Subset the data. Years refer to calendar years.
												A max range of January 1, 1950 up through yesterday are downloaded form the ACIS API.
												Upon changing stations, a new dataset is downloaded from the API and the slider will refresh.
												The slider can be used to subset this data to a shorter period.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("Mo")),
				div(class="span1",helpPopup('Choose center month of precipitation year','The annual precipitation cycle is defined by the 1st day of the selected month. The graphic is centered on this month.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("Var")),
				div(class="span1",helpPopup('Choose a variable','Currently, only precipitation is available. Other climate variables may be added later. The menu remains as a placeholder for future options.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("DailyColPal")),
				div(class="span1",helpPopup('Choose a color palette','Currently six options.'))
			)
		)
	),
	wellPanel(
		checkboxInput("showWP2",h5("Color/Size rescaling"),FALSE),
		conditionalPanel(condition="input.showWP2",
			div(class="row-fluid",
				div(class="span11",uiOutput("TfColCir")),
				div(class="span1",helpPopup('Main panel relative circle size and color',hp.tfColCir))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("TfCirCexMult")),
				div(class="span1",helpPopup('Main panel relative circle size cex multiplier',hp.tfCirCexMult))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("TfColMar")),
				div(class="span1",helpPopup('Historical mean relative circle color',hp.tfColMar))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("TfColBar")),
				div(class="span1",helpPopup('Bar plot relative color',hp.tfColBar))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("HtCompress")),
				div(class="span1",helpPopup('Vertical plot compression factor',hp.htCompress))
			)
		)
	),
	wellPanel(
		checkboxInput("showWP3",h5("Include marginal panels"),FALSE),
		conditionalPanel(condition="input.showWP3",
			div(class="row-fluid",
				div(class="span11",uiOutput("MeanHistorical")),
				div(class="span1",helpPopup('Include/exclude marginal panels',hp.marginalPanels))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("Bars6mo"))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("Mean6mo"))
			)
		)
	),
	wellPanel(
		checkboxInput("showWP4",h5("Allowable missing values"),FALSE),
		conditionalPanel(condition="input.showWP4",
			div(class="row-fluid",
				div(class="span11",uiOutput("MaxNAperMo")),
				div(class="span1",helpPopup('Missing values',hp.missingValues))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("MaxNAperYr"))
			)
		)
	),
	conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
)
