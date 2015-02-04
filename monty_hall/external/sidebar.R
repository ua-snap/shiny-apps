column(2,
	wellPanel(
		checkboxInput("showWP1", h5("Data selection"), TRUE),
		conditionalPanel(condition="input.showWP1",
			fluidRow(
				column(12,uiOutput("totaldoors"))
				#column(1, helpPopup('Number of doors in game','This is the total number of doors, N. If N even, player may select, and subsequently Monty may open, 1 to N/2 - 1 doors each (mutually exclusive). If N odd, then (N - 1)/2 doors each.'))
			),
			downloadButton("dl_mhplotPDF", "Download PDF", class="btn-block btn-warning"),
			downloadButton("dl_mhplotPNG", "Download PNG", class="btn-block btn-info")
		)
	)
)
