column(4,
	conditionalPanel(condition="input.tsp!=='about'",
		wellPanel(
			h5("Select data"),
			selectInput("months_abb", "Months:", choices=month.abb, selected="", multiple=T, width="100%"),
			selectInput("decades", "Decades:", choices=decades.all.lab, selected=decades.all.lab, multiple=T, width="100%"),
			selectInput("color_by", "Primary variable:", choices=c("Decade", "Month"), selected="Decade", width="100%"),
			uiOutput("Compare"),
			checkboxInput("include_annual", "Include annual edges:", FALSE),
			conditionalPanel(condition="input.months_abb !== null && input.decades !== null",
				fluidRow(
					column(6, actionButton("plot_button", "Generate Plot", icon=icon("check"), class="btn-block btn-primary")),
					column(6, downloadButton("dlCurPlot1_PNG", "Download Plot", class="btn-block btn-success"))
				)
			)
		),
		h6(HTML(
			'<p style="text-align:justify;">Select at least one month and decade.
			Primary variable: colored by level.
			Secondary variable: Solid vs. dashed lines, two levels permitted, truncated to first two levels if more supplied.
			If not selected, truncated to one level if more supplied.</p>
			
			<p style="text-align:justify;">Displaying annual ice edges shows variability around the mean.
			Some plots reveal limitations of the estimator as averaged over a decadal timeframe,
			where the decadal mean line does not always look subjectively like it is in the "middle" of the annual estimated 15% concentration contours.
			Annual edges use semi-transparent color so that interannual variability is visible without obstructing the decadal mean.</p>
			
			<p style="text-align:justify;">Due to the amount of layering required, plotting may take about ten seconds, higher quality downloads up to 30 seconds.
			Generate a map in the browser and/or download a PNG using the buttons above.
			PNG formatting differs slightly from browser formatting.</p>
			
			<p style="text-align:justify;">See the <em>About</em> tab above for more details.</p>'
		))
	)
)
