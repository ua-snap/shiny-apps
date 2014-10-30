column(4,
	#### Data selection panel
	conditionalPanel(condition="input.tsp == 'plot_heatmap' || input.tsp == 'plot_ts' || input.tsp == 'plot_scatter' || input.tsp == 'plot_variability' || input.tsp == 'plot_spatial'",
	wellPanel(
		checkboxInput("showDataPanel1", h5("Data Selection"), TRUE),
		conditionalPanel(condition="input.showDataPanel1",
			fluidRow(
				column(6, selectInput("vars", "Climate variable:", c("", varnames), selected="", multiple=T, width="100%")),
				column(6, 
					selectInput("aggStats", "Stat:", stats.colnames, selected=stats.colnames[1], width="100%"),
					selectInput("units", "Units:", c("C, mm","F, in"), selected="C, mm", width="100%")
				)
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
				column(6, uiOutput("Months2Seasons"), uiOutput("N_Seasons")),
				column(6, uiOutput("Decades2Periods"), uiOutput("N_Periods"))
			),
			fluidRow(
				column(6, selectInput("loctype", "Spatial scale:", region.names, selected=region.names[1], multiple=FALSE, width="100%")), # May use multiple=TRUE later
				column(6, uiOutput("Location"))
			)
		),
		fluidRow(
			column(6, 
			conditionalPanel(condition="input.vars !== null &&
			( (input.loctype !== 'Cities' && input.locs_regions !== null) || (input.loctype == 'Cities' && input.locs_cities !== null) ) &&
				( (input.cmip3scens !== null && input.cmip3models !== null) || (input.cmip5scens !== null && input.cmip5models !== null) )", uiOutput("GoButton"))
			),
			column(6,
				conditionalPanel(condition="input.tsp == 'plot_heatmap' && input.goButton > 0", downloadButton("dlCurTableHeatmap", "Download Data", class="btn-success btn-block")),
				conditionalPanel(condition="input.tsp == 'plot_ts' && input.goButton > 0", downloadButton("dlCurTableTS", "Download Data", class="btn-success btn-block")),
				conditionalPanel(condition="input.tsp == 'plot_scatter' && input.goButton > 0", downloadButton("dlCurTableScatter", "Download Data", class="btn-success btn-block")),
				conditionalPanel(condition="input.tsp == 'plot_variability' && input.goButton > 0", downloadButton("dlCurTableVariability", "Download Data", class="btn-success btn-block")),
				conditionalPanel(condition="input.tsp == 'plot_spatial' && input.goButton > 0", downloadButton("dlCurTableSpatial", "Download Data", class="btn-success btn-block"))
			)
		)
	)
	),
	#### Plot options panel
	conditionalPanel(condition="output.ShowPlotOptionsPanel == true && (input.tsp == 'plot_heatmap' || input.tsp == 'plot_ts' || input.tsp == 'plot_scatter' || input.tsp == 'plot_variability' || input.tsp == 'plot_spatial')",
	wellPanel(
		checkboxInput("showDisplayPanel1", h5("Plot Options"), TRUE),
		conditionalPanel(condition="input.showDisplayPanel1",
		
		conditionalPanel(condition="input.tsp == 'plot_heatmap'",
			fluidRow(column(6, uiOutput("Heatmap_x")), column(6, uiOutput("Heatmap_y"))),
			fluidRow(column(6,uiOutput("FacetHeatmap")), column(6, uiOutput("StatHeatmap"))),
			fluidRow(uiOutput("PooledVarHeatmap"))
		),
		conditionalPanel(condition="input.tsp == 'plot_ts'",
			fluidRow(column(6, selectInput("xtime", "X-axis (time)", choices=c("Month", "Year", "Decade"), selected="Year", width="100%")), column(6, uiOutput("Group"))),
			fluidRow(column(6,uiOutput("Facet"))),
			fluidRow(uiOutput("PooledVar"))
		),
		conditionalPanel(condition="input.tsp == 'plot_scatter'",
			fluidRow(column(6, selectInput("xy", "X & Y axes", choices=c("P ~ T", "T ~ P"), selected="P ~ T", width="100%")), column(6, uiOutput("Group2"))),
			fluidRow(column(6,uiOutput("Facet2"))),
			fluidRow(uiOutput("PooledVar2"))
		),
		conditionalPanel(condition="input.tsp == 'plot_variability'",
			fluidRow(column(6, uiOutput("Xvar")), column(6, uiOutput("Group3"))),
			fluidRow(
				column(6,uiOutput("Facet3")),
				column(6,
					conditionalPanel(condition="input.variability == true && input.boxplots == ''", selectInput("errorBars", "Error bars", choices=c("", "95% CI", "SD", "SE", "Range"), selected="", width="100%")),
					conditionalPanel(condition="input.variability == false", selectInput("dispersion", "Dispersion stat", choices=c("SD", "SE", "Full Spread"), selected="SD", width="100%"))
				)
			),
			fluidRow(uiOutput("PooledVar3"))
		),
		conditionalPanel(condition="input.tsp == 'plot_spatial'",
			fluidRow(column(6, uiOutput("Spatial_x")), column(6, uiOutput("GroupSpatial"))),
			fluidRow(
				column(6,uiOutput("FacetSpatial")),
				column(6,uiOutput("PlotTypeSpatial"))
			),
			conditionalPanel(condition="input.plotTypeSpatial == 'Stripchart'", sliderInput("thinSpatialSample", "Thin samples", 0.05, 1, 1, step=0.05, width="100%")),
			fluidRow(uiOutput("PooledVarSpatial"))
		),
		fluidRow(column(4, checkboxInput("showTitle", "Title", TRUE)), column(4, checkboxInput("showPanelText", "Panel text", TRUE)), column(4, checkboxInput("showCRU","Show CRU 3.1", FALSE))),
		conditionalPanel(condition="input.tsp !== 'plot_heatmap'",
			fluidRow(column(4, checkboxInput("showpts", "Show points", TRUE)), column(4, checkboxInput("jitterXY", "Jitter points", FALSE)), column(4, checkboxInput("showlines", "Show lines", FALSE))),
			conditionalPanel(condition="input.tsp == 'plot_ts'", 
				fluidRow(
					column(4, checkboxInput("linePlot", "Trend lines", FALSE)),
					column(4, checkboxInput("yrange", "Group range", FALSE), conditionalPanel(condition="input.vars !== null && input.vars[0] == 'Precipitation'", checkboxInput("barPlot", "Barplot", FALSE))),
					column(4, checkboxInput("clbootsmooth", "Confidence band", FALSE), uiOutput("VertFacet"))
				)
			),
			conditionalPanel(condition="input.tsp == 'plot_scatter'", fluidRow(column(4, uiOutput("Hexbin")))),
			conditionalPanel(condition="input.tsp == 'plot_variability'",
				fluidRow(
					column(4, uiOutput("Variability")),
					column(4, conditionalPanel(condition="input.tsp == 'plot_variability'", checkboxInput("boxplots", "Box plots", FALSE))),
					column(4, uiOutput("VertFacet3"))
				)
			),
			conditionalPanel(condition="input.tsp == 'plot_spatial'", 
				fluidRow(
					column(4,
						conditionalPanel(condition="input.plotTypeSpatial !== 'Stripchart'", checkboxInput("linePlotSpatial", "Trend lines", FALSE)),
						conditionalPanel(condition="input.plotTypeSpatial == 'Stripchart'", checkboxInput("boxplotsSpatial", "Box plots", FALSE))
					),
					column(4, uiOutput("VertFacetSpatial"))
				)
			)
		),
		conditionalPanel(condition="input.tsp == 'plot_heatmap'",
			fluidRow(column(4, checkboxInput("aspect1to1", "1:1 Aspect", FALSE)), column(4, checkboxInput("revHeatmapColors", "Reverse colors", FALSE)), column(4, checkboxInput("showHeatmapVals", "Cell values", FALSE)))
		),
		fluidRow(column(4, checkboxInput("plotThemeDark", "Dark theme", FALSE))),
		conditionalPanel(condition="input.tsp == 'plot_heatmap'",
			fluidRow(
				column(6,
					uiOutput("ColorseqHeatmap"),
					conditionalPanel(condition="input.heatmap_x !== null && input.heatmap_y !== null",
						selectInput("legendPosHeatmap","Legend",c("Bottom", "Right", "Top", "Left"),selected="Bottom", width="100%"))
				),
				column(6, uiOutput("ColorpalettesHeatmap"), uiOutput("PlotFontSizeHeatmap"))
			)
		),
		conditionalPanel(condition="input.tsp == 'plot_ts'",
			fluidRow(column(4, uiOutput("Yrange")), column(4,""), column(4, uiOutput("CLbootsmooth"))),
			fluidRow(
				column(6,
					uiOutput("Colorseq"), uiOutput("Alpha1"), uiOutput("Bardirection"),
					conditionalPanel(condition="input.group !== null && input.group !== 'None'",
						selectInput("legendPos1","Legend",c("Bottom", "Right", "Top", "Left"),selected="Bottom", width="100%"))
					),
				column(6, uiOutput("Colorpalettes"), uiOutput("PlotFontSize"), uiOutput("Bartype"))
			)
		),
		conditionalPanel(condition="input.tsp == 'plot_scatter'",
			fluidRow(
				column(6, uiOutput("Colorseq2"), uiOutput("Alpha2"), 
					conditionalPanel(condition="input.group2 !== null && input.group2 !== 'None'",
						selectInput("legendPos2","Legend",c("Bottom", "Right", "Top", "Left"),selected="Bottom", width="100%"))
				),
				column(6, uiOutput("Colorpalettes2"), uiOutput("PlotFontSize2"))
			)
		),
		conditionalPanel(condition="input.tsp == 'plot_variability'",
			fluidRow(
				column(6,
					uiOutput("Colorseq3"), uiOutput("Alpha3"), uiOutput("Bardirection3"),
					conditionalPanel(condition="input.group3 !== null && input.group3 !== 'None'",
						selectInput("legendPos3","Legend",c("Bottom", "Right", "Top", "Left"),selected="Bottom", width="100%"))
				),
				column(6, uiOutput("Colorpalettes3"), uiOutput("PlotFontSize3"), uiOutput("Bartype3"))
			)
		),
		conditionalPanel(condition="input.tsp == 'plot_spatial'",
			fluidRow(
				column(6,
					uiOutput("ColorseqSpatial"), uiOutput("AlphaSpatial"), uiOutput("DensityTypeSpatial"), uiOutput("StripDirectionSpatial"),
					conditionalPanel(condition="input.groupSpatial !== null && input.groupSpatial !== 'None'",
						selectInput("legendPosSpatial","Legend",c("Bottom", "Right", "Top", "Left"),selected="Bottom", width="100%"))
				),
				column(6, uiOutput("ColorpalettesSpatial"), uiOutput("PlotFontSizeSpatial"))
			)
		)
		),
		fluidRow(
			column(6, uiOutput("PlotButton")),
			column(6,
				conditionalPanel(condition="input.tsp == 'plot_heatmap' && input.plotButton > 0", downloadButton("dlCurPlotHeatmap", "Download Plot", class="btn-success btn-block")),
				conditionalPanel(condition="input.tsp == 'plot_ts' && input.plotButton > 0", downloadButton("dlCurPlotTS", "Download Plot", class="btn-success btn-block")),
				conditionalPanel(condition="input.tsp == 'plot_scatter' && input.plotButton > 0", downloadButton("dlCurPlotScatter", "Download Plot", class="btn-success btn-block")),
				conditionalPanel(condition="input.tsp == 'plot_variability' && input.plotButton > 0", downloadButton("dlCurPlotVariability", "Download Plot", class="btn-success btn-block")),
				conditionalPanel(condition="input.tsp == 'plot_spatial' && input.plotButton > 0", downloadButton("dlCurPlotSpatial", "Download Plot", class="btn-success btn-block"))
			)
		)
	)
	)
)
