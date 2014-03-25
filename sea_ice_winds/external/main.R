mainPanel(
	tabsetPanel(
		tabPanel("Time series plots",
			fluidRow(column(12, plotOutput("plotByYear",height="auto"))),
			fluidRow(column(12, plotOutput("plotByDecade",height="auto"))),
			fluidRow(
				column(3, uiOutput("tp.annstyle")),
				column(3, uiOutput("tp.decstyle")),
				column(3,downloadButton("dl_plotByYear","Download annual graphic")),
				column(3, downloadButton("dl_plotByDecade","Download decadal graphic"))
			), value="ts"),
		tabPanelAbout(),
		id="tsp"
	)
)
