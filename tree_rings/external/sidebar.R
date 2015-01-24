column(3,
	wellPanel(
		checkboxInput("showWP1",h5("Data selection"),TRUE),
		conditionalPanel(condition="input.showWP1",
			fluidRow(
				column(11, uiOutput("dataset")),
				column(1, helpPopup('Choose dataset','Datasets are currently oddly named.'))
			),
			fluidRow(
				column(6, downloadButton("dl_macorplotPDF","Download PDF", class="btn-block btn-primary")),
				column(6, downloadButton("dl_macorplotPNG","Download PNG", class="btn-block btn-success"))
			)
		)
	)
)
