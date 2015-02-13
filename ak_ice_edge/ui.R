library(shinythemes)

shinyUI(fluidPage(theme=shinytheme("cosmo"),
	progressInit(),
	tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),
	navbarPage(
		title=HTML('<div><a href="http://snap.uaf.edu" target="_blank"><img src="./img/SNAP_acronym_100px.png" width="80%"></a></div>'),
		tabPanel("Map", value="map"),
		tabPanel("About", value="about"),
		windowTitle="Sea Ice Edge",
		collapsible=TRUE,
		id="tsp"
	),
	h4("Estimated Mean Decadal 15% Sea Ice Concentration Edges"),
	conditionalPanel("input.tsp=='map'",
	fluidRow(
		column(4,
			wellPanel(
				selectInput("decades", "Decades", decades.all.lab, selected=decades.all.lab, multiple=T),
				selectInput("months_abb", "Months", month.abb, selected="", multiple=T),
				fluidRow(
					column(6, selectInput("color_by", "Primary variable", c("Decade", "Month"), selected="Decade")),
					column(6, uiOutput("Compare"))
				),
				fluidRow(
					column(6, selectInput("colpal", "Colors", paste0(rownames(brewer.pal.info), " [",brewer.pal.info$category, "]"), selected="RdYlBu [div]")),
					column(6, checkboxInput("include_annual", "Include annual edges", FALSE))
				),
				uiOutput("Alpha"),
				conditionalPanel(condition="input.months_abb !== null && input.decades !== null",
					fluidRow(
						column(6, actionButton("plot_button", "Generate Plot", icon=icon("check"), class="btn-block btn-primary")),
						column(6, downloadButton("dlCurPlot1_PNG", "Get Plot", class="btn-block btn-success"))
					)
				)
			),
			h6(HTML(
				'<p style="text-align:justify;">Select at least one month and decade. <strong>Primary variable:</strong> colored by factor level.
				<strong>Secondary variable:</strong> Solid vs. dashed lines, <strong>maximum two levels permitted</strong>. This is for comparing two groups only. If more than two are selected, additional levels are ignored.</p>
				<p style="text-align:justify;">If the secondary variable not specified, there is no group comparison by line type and the list of levels selected for the non-primary variable is truncated to the first level only.
				If specified, selection is truncated to the first two levels if more are supplied.</p>
				<p style="text-align:justify;">See the <code>About</code> tab above for more details about this app.</p>'
			))
		),
		column(8, conditionalPanel("input.plot_button > 0", plotOutput("PlotMap", width="100%", height="auto")))
	)
	),
	conditionalPanel("input.tsp=='about'", source("about.R",local=T)$value)
))
