column(3,
	wellPanel(
		checkboxInput("showWP1",h5("Data selection"),TRUE),
		conditionalPanel(condition="input.showWP1",
			fluidRow(
				column(12, uiOutput("dataset"))
			),
			fluidRow(
				column(6, downloadButton("dl_macorplotPDF","Get PDF", class="btn-block btn-primary")),
				column(6, downloadButton("dl_macorplotPNG","Get PNG", class="btn-block btn-success"))
			)
		)
	)
)
