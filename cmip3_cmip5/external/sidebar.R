column(4,
	wellPanel(
		fluidRow(
			column(4, checkboxInput("showDataPanel1", h5("Data Selection"), TRUE)),
			column(4, actionButton("goButton", "Subset Data")),
			column(4,
				conditionalPanel(condition="input.tsp == 'plot1' && input.goButton > 0", downloadButton("dlCurTable1", "Download Data")),
				conditionalPanel(condition="input.tsp == 'plot2' && input.goButton > 0", downloadButton("dlCurTable2", "Download Data")),
				conditionalPanel(condition="input.tsp == 'plot3' && input.goButton > 0", downloadButton("dlCurTable3", "Download Data"))
			)
		),
		conditionalPanel(condition="input.showDataPanel1",
			fluidRow(
				column(6, selectInput("vars", "Climate variable:", c("", varnames), selected="", multiple=T, width="100%")),
				column(6, selectInput("units", "Units:", c("","C, mm","F, in"), selected="", width="100%"))
			),
			fluidRow(
				column(6, selectInput("cmip3scens", "CMIP3 emissions scenarios:", choices=c("", scennames[[1]]), selected="", multiple=T, width="100%")),
				column(6, selectInput("cmip5scens", "CMIP5 emissions scenarios:", choices=c("", scennames[[2]]), selected="", multiple=T, width="100%"))
			),
			fluidRow(
				column(6, selectInput("cmip3models", "CMIP3 climate models:", choices=c("", modnames[[1]]), selected="", multiple=T, width="100%")),
				column(6, selectInput("cmip5models", "CMIP5 climate models:", choices=c("", modnames[[2]]), selected="", multiple=T, width="100%"))
			),
			fluidRow(
				column(12, checkboxInput("compositeModel", "Make composite(s) of selected models", FALSE))
			),
			sliderInput("yrs","Years:", min=min(years), max=max(years), value=range(years), step=1, format="####", width="100%"),
			fluidRow(
				column(6, selectInput("mos", "Months:", choices=c("", month.abb), selected="", multiple=T, width="100%")),
				column(6,  selectInput("decs", "Decades:", choices=c("", paste0(decades,"s")), selected="", multiple=T, width="100%"))
			),
			fluidRow(
				#column(6, selectInput("doms", "Region:", c("", domnames), selected="", multiple=T, width="100%")),
				column(6, selectInput("doms", "Region:", c("", region.names), selected="", multiple=T, width="100%")),
				#column(6, selectInput("cities", "City:", c("", cities.meta$Domain), selected="", multiple=F, width="100%")) # multiple=FALSE temporarily
				column(6, selectInput("cities", "City:", c("", city.names), selected="", multiple=F, width="100%")) # multiple=FALSE temporarily
			)
		)
	),
	wellPanel(
		fluidRow(
			column(4, checkboxInput("showDisplayPanel1", h5("Plot Options"), TRUE)),
			column(4, uiOutput("PlotButton")),
			column(4,
				conditionalPanel(condition="input.tsp == 'plot1' && input.goButton > 0", downloadButton("dlCurPlot1", "Download Plot")),
				conditionalPanel(condition="input.tsp == 'plot2' && input.goButton > 0", downloadButton("dlCurPlot2", "Download Plot")),
				conditionalPanel(condition="input.tsp == 'plot3' && input.goButton > 0", downloadButton("dlCurPlot3", "Download Plot"))
			)
		),
		conditionalPanel(condition="input.showDisplayPanel1",
			fluidRow(
				column(6,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("Xtime")), 
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("XY")),
					conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("Xvar"))),
				column(6,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("Group")),
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("Group2")),
					conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("Group3")))),
			fluidRow(
				column(6,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("Facet")),
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("Facet2")),
					conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("Facet3"))),
				column(6,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("Subjects")),#,
					#conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("Subjects2")),
					conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("Subjects3"))
					)
				),
			fluidRow(
				column(6, checkboxInput("showpts", "Show points", TRUE)),
				column(6, checkboxInput("jitterXY", "Jitter points", FALSE))
			),
			fluidRow(
				column(6,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("Altplot")),
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("Conplot")),
					conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("Variability"))),
				column(6,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("VertFacet")),
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("VertFacet2")),
					conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("VertFacet3")))),
			fluidRow(
				column(6, checkboxInput("showCRU","Include CRU data", FALSE))),
			fluidRow(
				column(6, conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("Boxplots")), h5(uiOutput("SummarizeByXtitle"))),
				column(6,
					conditionalPanel(condition="input.tsp == 'plot1'", p(uiOutput("PooledVar"))),
					conditionalPanel(condition="input.tsp == 'plot2'", p(uiOutput("PooledVar2"))),
					conditionalPanel(condition="input.tsp == 'plot3'",
						conditionalPanel(condition="input.variability == true", uiOutput("ErrorBars")),
						conditionalPanel(condition="input.variability == false", uiOutput("Dispersion")), p(uiOutput("PooledVar3"))))),
			fluidRow(
				column(4,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("Yrange")),
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("Hexbin"))),
				column(4,""),
					#conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("CLbootbar"))),
				column(4,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("CLbootsmooth")))),
			fluidRow( column(6, p(style="text-align:justify", em("Additional display options available below plot."))), column(6, "") ),
			fluidRow(
				column(6,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("Colorseq"), uiOutput("Alpha1"), uiOutput("Bartype"), uiOutput("LegendPos1")),
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("Colorseq2"), uiOutput("Alpha2"), uiOutput("LegendPos2")),
					conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("Colorseq3"), uiOutput("Alpha3"), uiOutput("Bartype3"), uiOutput("LegendPos3"))),
				column(6,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("Colorpalettes"), uiOutput("PlotFontSize"), uiOutput("Bardirection")),
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("Colorpalettes2"), uiOutput("PlotFontSize2")),
					conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("Colorpalettes3"), uiOutput("PlotFontSize3"), uiOutput("Bardirection3"))
				)
			)
		)
	),
	conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
)
