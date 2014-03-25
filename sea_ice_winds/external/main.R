mainPanel(
	tabsetPanel(
		tabPanel("Time series plots",
			plotOutput("plotByYear",height="auto"),
			plotOutput("plotByDecade",height="auto"),
			fluidRow(
				column(3, uiOutput("tp.annstyle")),
				column(3, uiOutput("tp.decstyle")),
				column(3, br(), downloadButton("dl_plotByYear","Download annual graphic")),
				column(3, br(), downloadButton("dl_plotByDecade","Download decadal graphic"))
			), value="ts"),
		tabPanelAbout(),
		id="tsp"
	)
)
