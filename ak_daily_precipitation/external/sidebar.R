column(3,
	tags$head(
		tags$link(rel="stylesheet", type="text/css", href="styles_black_orange.css"),
		tags$link(rel="stylesheet", type="text/css", href="jquery.slider.min.css")
	),
	wellPanel(
		div(class="row-fluid",
		div(class="span6", checkboxInput("showWP1",h5("Data selection"),TRUE)),
		div(class="span6", uiOutput("GenPlotButton"))
		),
		conditionalPanel(condition="input.showWP1",
			div(class="row-fluid",
				div(class="span11",selectInput("loc", "Location:", choices=c("", paste0(loc.names,", AK")), selected="", width="100%")),
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
				div(class="span11",selectInput("mo", "Center graphic on month:", choices=month.abb, selected=month.abb[7], width="100%")),
				div(class="span1",helpPopup('Choose center month of precipitation year','The annual precipitation cycle is defined by the 1st day of the selected month. The graphic is centered on this month.'))
			),
			div(class="row-fluid",
				div(class="span11",selectInput("var", "Variable:", choices=vars, selected=vars[1], width="100%")),
				div(class="span1",helpPopup('Choose a variable','Currently, only precipitation is available. Other climate variables may be added later. The menu remains as a placeholder for future options.'))
			),
			div(class="row-fluid",
				div(class="span11",selectInput("dailyColPal", "Color theme:", palettes, palettes[1], width="100%")),
				div(class="span1",helpPopup('Choose a color palette','Currently six options.'))
			)
		)
	),
	wellPanel(
		checkboxInput("showWP2",h5("Color/Size rescaling"),FALSE),
		conditionalPanel(condition="input.showWP2",
			div(class="row-fluid",
				div(class="span11",selectInput("tfColCir", "Circle size and color gradient:", choices=0:3, selected=0, width="100%")),
				div(class="span1",helpPopup('Main panel relative circle size and color',hp.tfColCir))
			),
			div(class="row-fluid",
				div(class="span11",selectInput("tfCirCexMult", "Circle size cex multiplier:", choices=1:20, selected=10, width="100%")),
				div(class="span1",helpPopup('Main panel relative circle size cex multiplier',hp.tfCirCexMult))
			),
			div(class="row-fluid",
				div(class="span11",selectInput("tfColMar", "Historical mean color gradient:", choices=0:10, selected=0, width="100%")),
				div(class="span1",helpPopup('Historical mean relative circle color',hp.tfColMar))
			),
			div(class="row-fluid",
				div(class="span11",selectInput("tfColBar", "Barplot color gradient:", choices=0:5, selected=0, width="100%")),
				div(class="span1",helpPopup('Bar plot relative color',hp.tfColBar))
			),
			div(class="row-fluid",
				div(class="span11",selectInput("htCompress", "Vertical plot compression factor", choices=seq(0.5,2,by=0.25), selected=1.5, width="100%")),
				div(class="span1",helpPopup('Vertical plot compression factor',hp.htCompress))
			)
		)
	),
	wellPanel(
		checkboxInput("showWP3",h5("Include marginal panels"),FALSE),
		conditionalPanel(condition="input.showWP3",
			div(class="row-fluid",
				div(class="span11",checkboxInput("meanHistorical","Daily historical means:",TRUE)),
				div(class="span1",helpPopup('Include/exclude marginal panels',hp.marginalPanels))
			),
			div(class="row-fluid",
				div(class="span11",checkboxInput("bars6mo","6-month totals:",TRUE))
			),
			div(class="row-fluid",
				div(class="span11",checkboxInput("mean6mo","Historical 6-month totals:",TRUE))
			)
		)
	),
	wellPanel(
		checkboxInput("showWP4",h5("Allowable missing values"),FALSE),
		conditionalPanel(condition="input.showWP4",
			div(class="row-fluid",
				div(class="span11",sliderInput("maxNAperMo", "Max. NA/month:", min=0, max=10, value=5, width="100%")),
				div(class="span1",helpPopup('Missing values',hp.missingValues))
			),
			div(class="row-fluid",
				div(class="span11",sliderInput("maxNAperYr","Max. NA/year:", min=0, max=60, value=30, width="100%"))
			)
		)
	),
	conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
)
