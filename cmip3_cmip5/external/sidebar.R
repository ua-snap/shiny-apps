column(4,
	wellPanel(
		checkboxInput("showDataPanel1", h5("Data Selection"), TRUE),
		conditionalPanel(condition="input.showDataPanel1",
			fluidRow(
				column(6, selectInput("vars", "Climate variable:", c("", varnames), selected="", multiple=T, width="100%")),
				column(6, selectInput("units", "Units:", c("C, mm","F, in"), selected="C, mm", width="100%"))
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
				column(6, selectInput("doms", "Region:", c("", region.names), selected="", multiple=T, width="100%")),
				column(6, selectInput("cities", "City:", c("", city.names), selected="", multiple=F, width="100%")) # multiple=FALSE temporarily
			)
		),
		fluidRow(
			column(6, 
			conditionalPanel(condition="input.vars !== null && (input.doms !== null || input.cities !== '') &&
				( (input.cmip3scens !== null && input.cmip3models !== null) || (input.cmip5scens !== null && input.cmip5models !== null) )", uiOutput("GoButton"))
			),
			column(6,
				conditionalPanel(condition="input.tsp == 'plot1' && input.goButton > 0", downloadButton("dlCurTable1", "Download Data", class="btn-success btn-block")),
				conditionalPanel(condition="input.tsp == 'plot2' && input.goButton > 0", downloadButton("dlCurTable2", "Download Data", class="btn-success btn-block")),
				conditionalPanel(condition="input.tsp == 'plot3' && input.goButton > 0", downloadButton("dlCurTable3", "Download Data", class="btn-success btn-block"))
			)
		)
	),
	wellPanel(
		checkboxInput("showDisplayPanel1", h5("Plot Options"), TRUE),
		conditionalPanel(condition="input.showDisplayPanel1",
			fluidRow(
				column(6,
					conditionalPanel(condition="input.tsp == 'plot1'", selectInput("xtime", "X-axis (time)", choices=c("Month", "Year", "Decade"), selected="Year", width="100%")), 
					conditionalPanel(condition="input.tsp == 'plot2'", selectInput("xy", "X & Y axes", choices=c("P ~ T", "T ~ P"), selected="P ~ T", width="100%")),
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
				conditionalPanel(condition="input.tsp == 'plot1'", p(uiOutput("PooledVar"))),
				conditionalPanel(condition="input.tsp == 'plot2'", p(uiOutput("PooledVar2"))),
				conditionalPanel(condition="input.tsp == 'plot3'", p(uiOutput("PooledVar3")))
			),
			fluidRow(
				column(4,
					checkboxInput("showTitle", "Title", TRUE),
					checkboxInput("showpts", "Show points", TRUE),
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("LinePlot")),
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("Conplot")),
					conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("Variability"))
				),
				column(4,
					checkboxInput("showPanelText", "Panel text", TRUE),
					checkboxInput("jitterXY", "Jitter points", FALSE),
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("BarPlot")),
					conditionalPanel(condition="input.tsp == 'plot2'", ""),
					conditionalPanel(condition="input.tsp == 'plot3' & input.variability == true", checkboxInput("boxplots", "Box plots", FALSE))
				),
				column(4,
					checkboxInput("showCRU","Show CRU 3.1", FALSE),
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("VertFacet")),
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("VertFacet2")),
					conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("VertFacet3"))
				)
			),
			conditionalPanel(condition="input.tsp == 'plot3'",
				fluidRow(
					column(6,
						conditionalPanel(condition="input.variability == true && input.boxplots == ''", selectInput("errorBars", "Error bars", choices=c("", "95% CI", "SD", "SE", "Range"), selected="", width="100%")),
						conditionalPanel(condition="input.variability == false", selectInput("dispersion", "Dispersion stat", choices=c("SD", "SE", "Full Spread"), selected="SD", width="100%"))),
					column(6, "")# h5(uiOutput("SummarizeByXtitle"))),	
				)),
			fluidRow(
				column(4,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("Yrange")),
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("Hexbin"))),
				column(4,""),
					#conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("CLbootbar"))),
				column(4,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("CLbootsmooth")))),
			fluidRow(
				column(6,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("Colorseq"), uiOutput("Alpha1"), uiOutput("Bardirection"),
						conditionalPanel(condition="input.group !== null && input.group !== 'None/Force Pool'",
							selectInput("legendPos1","Legend",c("Top","Right","Bottom","Left"),selected="Top", width="100%"))),
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("Colorseq2"), uiOutput("Alpha2"), 
						conditionalPanel(condition="input.group2 !== null && input.group2 !== 'None/Force Pool'",
							selectInput("legendPos2","Legend",c("Top","Right","Bottom","Left"),selected="Top", width="100%"))),
					conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("Colorseq3"), uiOutput("Alpha3"), uiOutput("Bardirection3"),
						conditionalPanel(condition="input.group3 !== null && input.group3 !== 'None/Force Pool'",
							selectInput("legendPos3","Legend",c("Top","Right","Bottom","Left"),selected="Top", width="100%")))),
				column(6,
					conditionalPanel(condition="input.tsp == 'plot1'", uiOutput("Colorpalettes"), uiOutput("PlotFontSize"), uiOutput("Bartype")),
					conditionalPanel(condition="input.tsp == 'plot2'", uiOutput("Colorpalettes2"), uiOutput("PlotFontSize2")),
					conditionalPanel(condition="input.tsp == 'plot3'", uiOutput("Colorpalettes3"), uiOutput("PlotFontSize3"), uiOutput("Bartype3"))
				)
			)
		),
		fluidRow(
			column(6, uiOutput("PlotButton")),
			column(6,
				conditionalPanel(condition="input.tsp == 'plot1' && input.goButton > 0", downloadButton("dlCurPlot1", "Download Plot", class="btn-success btn-block")),
				conditionalPanel(condition="input.tsp == 'plot2' && input.goButton > 0", downloadButton("dlCurPlot2", "Download Plot", class="btn-success btn-block")),
				conditionalPanel(condition="input.tsp == 'plot3' && input.goButton > 0", downloadButton("dlCurPlot3", "Download Plot", class="btn-success btn-block"))
			)
		)
	),
	conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
)
