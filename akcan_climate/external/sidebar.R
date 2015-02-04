column(4,
	wellPanel(
		checkboxInput("showDataPanel1", h5("Data Selection Panel"), TRUE),
		conditionalPanel(condition="input.showDataPanel1",
			fluidRow(
				column(6, selectInput("dat.name", "Data:", choices=c("","CMIP3 Historical","CMIP3 Projected"), selected="", width="100%")),
				column(6, selectInput(inputId = "locationSelect", label = "Select a community:", choices = c("",communities), selected="", width="100%"))
			),
			fluidRow( column(6, uiOutput("vars")), column(6, uiOutput("units"))),
			fluidRow( column(6, uiOutput("models")), column(6, uiOutput("scens"))),
			fluidRow( column(6, uiOutput("mos")), column(6, uiOutput("decs"))),
			uiOutput("GoButton")
		)
	),
	wellPanel(
		checkboxInput("showDisplayPanel1", h5("Plot Options Panel"), TRUE),
		conditionalPanel(condition="input.showDisplayPanel1",
			fluidRow( column(4, uiOutput("xtime")), column(4, uiOutput("group")), column(4, uiOutput("facet"))),
			fluidRow( column(4, uiOutput("jitterXY")), column(4, uiOutput("altplot")), column(4, uiOutput("vert.facet"))),
			fluidRow( column(6, h5(uiOutput("summarizeByXtitle"))), column(6, p(uiOutput("pooled.var")))),
			fluidRow( column(4, uiOutput("yrange")), column(4, uiOutput("clbootbar")), column(4, uiOutput("clbootsmooth"))),
			p(style="text-align:justify",em("Additional specific display options are available below the plot.")),
			uiOutput("PlotButton")
		)
	)
)
