sidebarPanel(
	tags$head(
		tags$link(rel="stylesheet", type="text/css", href="styles_black_lightblue.css")
	),
	conditionalPanel(condition="input.tsp!=='rcode'",
		wellPanel(
			div(class="row-fluid",
				div(class="span6",checkboxInput("showWP1",h5("Data selection"),TRUE)),
				div(class="span6",conditionalPanel( condition="input.plottype!='3D - interactive (rgl)'", downloadButton("dl_plot1PDF","Download PDF") ))
			),
			conditionalPanel(condition="input.showWP1",
				div(class="row-fluid",
					div(class="span6",uiOutput("dataset")),
					div(class="span6",uiOutput("plottype"))
				)
			)
		),
		wellPanel(
			checkboxInput("showWP2",h5("Contour line properties"),FALSE),
			conditionalPanel(condition="input.showWP2",
				div(class="row-fluid",
					div(class="span6",uiOutput("contourcol"), uiOutput("contourlwd"), uiOutput("contourasp")),
					div(class="span6",uiOutput("contournlevels"), uiOutput("labelSize"), uiOutput("contourdrawlabels"))
				)
			)
		),
		wellPanel(
			checkboxInput("showWP3",h5("Image properties"),FALSE),
			conditionalPanel(condition="input.showWP3",
				div(class="row-fluid",
					div(class="span6",uiOutput("imagecol")),
					div(class="span6",uiOutput("imagenlevels"))
				),
				div(class="row-fluid",
					div(class="span6",uiOutput("resfac")),
					div(class="span6",uiOutput("rasterImage"), uiOutput("contour"))
				),
				div(class="row-fluid",
					div(class="span6",uiOutput("facets")),
					div(class="span6",uiOutput("border"))
				),
				div(class="row-fluid",
					div(class="span6",uiOutput("lighting")),
					div(class="span6",uiOutput("shade"))
				),
				div(class="row-fluid",
					div(class="span6",uiOutput("imageasp")),
					div(class="span6",uiOutput("imagetheta"))
				)
			)
		),
		wellPanel(
			checkboxInput("showWP4",h5("Perspective properties"),FALSE),
			conditionalPanel(condition="input.showWP4",
				div(class="row-fluid",
					div(class="span6", uiOutput("perspcol")),
					div(class="span6", uiOutput("imgadjustrelief"))
				),
				div(class="row-fluid",
					div(class="span6", uiOutput("perspcontourside")),
					div(class="span6", uiOutput("perspzlim1"))
				),
				div(class="row-fluid",
					div(class="span6", uiOutput("perspimageside")),
					div(class="span6", uiOutput("perspzlim2"))
				),
				div(class="row-fluid",
					div(class="span6", uiOutput("bty")),
					div(class="span6", uiOutput("theta"))
				),
				div(class="row-fluid",
					div(class="span6", uiOutput("along"), uiOutput("curtain")),
					div(class="span6", uiOutput("phi"))
				)
			)
		),
		wellPanel(
			checkboxInput("showWP5",h5("RGL properties"),FALSE),
			conditionalPanel(condition="input.showWP5",
				div(class="row-fluid",
					div(class="span6",uiOutput("rglcol")),
					div(class="span6",uiOutput("RglPointsLines"))
				),
				uiOutput("rgladjustrelief")
			)
		),
		wellPanel(
			checkboxInput("showWP6",h5("General properties"),FALSE),
			conditionalPanel(condition="input.showWP6",
				div(class="row-fluid",
					div(class="span6",uiOutput("colkey"), uiOutput("clab"), uiOutput("NAcol")),
					div(class="span6",uiOutput("colkeyside"), uiOutput("colkeyaddlines"), uiOutput("bgcol"))
				)
			)
		)
	),
	conditionalPanel(condition="input.tsp==='rcode'",
		navlistPanel(
			"Top-level Code",
			tabPanel("Global", value="nlp_globalR"),
			tabPanel("UI", value="nlp_uiR"),
			tabPanel("Server", value="nlp_serverR"),
			"Mid-level Code",
			tabPanel("App", value="nlp_appR"),
			#tabPanel("Header", value="nlp_headerR"), # cannot include "header" if it contains Google Analytics tracking code
			tabPanel("Sidebar", value="nlp_sidebarR"),
			tabPanel("Main", value="nlp_mainR"),
			tabPanel("About", value="nlp_aboutR"),
			"Bottom-level Code",
			tabPanel("Well Panel 1", value="nlp_io.sidebar.wp1R"),
			tabPanel("Well Panel 2", value="nlp_io.sidebar.wp2R"),
			tabPanel("Well Panel 3", value="nlp_io.sidebar.wp3R"),
			tabPanel("Well Panel 4", value="nlp_io.sidebar.wp4R"),
			tabPanel("Well Panel 5", value="nlp_io.sidebar.wp5R"),
			tabPanel("Well Panel 6", value="nlp_io.sidebar.wp6R"),
			tabPanel("Reactives", value="nlp_reactivesR"),
			id="nlp",
			widths=c(12,1)
		),
		div(class="row-fluid",
			div(class="span6", uiOutput("HLTheme")),
			div(class="span6", uiOutput("HLFontSize"))
		),
		uiOutput("CodeDescription")
	),
	conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
)
