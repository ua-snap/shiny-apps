column(3,
	wellPanel(
		fluidRow(
			column(12, selectInput("loc", "Location:", choices=c("", paste0(loc.names,", AK")), selected="", width="100%"))#,
			#column(1,helpPopup('Choose location','There are 20 stations available. When blank, the text field is type-searchable.'))
		),
		fluidRow(
			column(12,uiOutput("Yrs"))#,
			#column(1,helpPopup('Choose consecutive years','Subset the data. Years refer to calendar years.
			#								A max range of January 1, 1950 up through yesterday are downloaded form the ACIS API.
			#								Upon changing stations, a new dataset is downloaded from the API and the slider will refresh.
			#								The slider can be used to subset this data to a shorter period.'))
		),
		#fluidRow(
		#	column(12,selectInput("var", "Variable:", choices=vars, selected=vars[1], width="100%"))#,
		#	#column(1,helpPopup('Choose a variable','Currently, only precipitation is available. Other climate variables may be added later. The menu remains as a placeholder for future options.'))
		#),
		fluidRow(
			column(6,selectInput("mo", "Center month:", choices=month.abb, selected=month.abb[7], width="100%")),
			#column(1,helpPopup('Choose center month of precipitation year','The annual precipitation cycle is defined by the 1st day of the selected month. The graphic is centered on this month.'))
			column(6,selectInput("dailyColPal", "Colors:", palettes, palettes[1], width="100%"))#,
			#column(1,helpPopup('Choose a color palette','Currently six options.'))
		),
		fluidRow(column(12, uiOutput("GenPlotButton")))
	),
	wellPanel(
		checkboxInput("showWP2",h6("Color/Size rescaling"),FALSE),
		conditionalPanel(condition="input.showWP2",
			fluidRow(
				column(12,selectInput("tfColCir", "Circle size and color gradient:", choices=0:3, selected=0, width="100%"))#,
				#column(1,helpPopup('Main panel relative circle size and color',hp.tfColCir))
			),
			fluidRow(
				column(12,selectInput("tfCirCexMult", "Circle size cex multiplier:", choices=1:20, selected=10, width="100%"))#,
				#column(1,helpPopup('Main panel relative circle size cex multiplier',hp.tfCirCexMult))
			),
			fluidRow(
				column(12,selectInput("tfColMar", "Historical mean color gradient:", choices=0:10, selected=0, width="100%"))#,
				#column(1,helpPopup('Historical mean relative circle color',hp.tfColMar))
			),
			fluidRow(
				column(12,selectInput("tfColBar", "Barplot color gradient:", choices=0:5, selected=0, width="100%"))#,
				#column(1,helpPopup('Bar plot relative color',hp.tfColBar))
			),
			fluidRow(
				column(12,selectInput("htCompress", "Vertical plot compression factor", choices=seq(0.5,2,by=0.25), selected=1.5, width="100%"))#,
				#column(1,helpPopup('Vertical plot compression factor',hp.htCompress))
			)
		)
	),
	wellPanel(
		checkboxInput("showWP3",h6("Include marginal panels"),FALSE),
		conditionalPanel(condition="input.showWP3",
			fluidRow(
				column(12,checkboxInput("meanHistorical","Daily historical means:",TRUE))#,
				#column(1,helpPopup('Include/exclude marginal panels',hp.marginalPanels))
			),
			fluidRow(
				column(12,checkboxInput("bars6mo","6-month totals:",TRUE))
			),
			fluidRow(
				column(12,checkboxInput("mean6mo","Historical 6-month totals:",TRUE))
			)
		)
	),
	wellPanel(
		checkboxInput("showWP4",h6("Allowable missing values"),FALSE),
		conditionalPanel(condition="input.showWP4",
			fluidRow(
				column(12,sliderInput("maxNAperMo", "Max. NA/month:", min=0, max=10, value=5, width="100%"))#,
				#column(1,helpPopup('Missing values',hp.missingValues))
			),
			fluidRow(
				column(12,sliderInput("maxNAperYr","Max. NA/year:", min=0, max=60, value=30, width="100%"))
			)
		)
	)
)
