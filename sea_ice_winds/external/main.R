mainPanel_2(
	span="span9",
	tabsetPanel(
		tabPanel("Time series plots",
			#uiOutput("debugging"),
			div(class="row-fluid",
				div(class="span3", uiOutput("tp.annualts")),
				div(class="span3", uiOutput("tp.annstyle"))
			),
			plotOutput("plotByYear",height="400px"),
			br(),
			div(class="row-fluid",
				div(class="span3", uiOutput("tp.decadalts")),
				div(class="span3", uiOutput("tp.decstyle"))
			),
			plotOutput("plotByDecade",height="400px"),
			br(),
			div(class="row-fluid",
				div(class="span3", downloadButton("dl_plotByYear","Download annual graphic")),
				div(class="span3", downloadButton("dl_plotByDecade","Download decadal graphic"))
			), br(), value="ts"),
		tabPanelAbout(),
		id="tsp"
	)
)
