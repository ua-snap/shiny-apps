column(4,
	conditionalPanel(condition="input.tsp!=='rcode'",
		wellPanel(
			fluidRow(
				column(6, checkboxInput("showWP1", h5("Data selection"), TRUE)),
				column(6, conditionalPanel(condition=anyStatic, downloadButton("dl_plotStaticPDF", "Get Plot", class="btn-block btn-primary")))
			),
			conditionalPanel(condition="input.showWP1",
				fluidRow(
					column(12, selectInput("dataset", "Select data:", choices=dataset.names, selected=dataset.names[1], width="100%"))#,
					#column(6",uiOutput("plottype"))
				)
			)
		)
	),
	conditionalPanel(condition=anyStatic,
		wellPanel(
			checkboxInput("showWP2", h5("Contour line properties"), FALSE),
			conditionalPanel(condition="input.showWP2",
				fluidRow(
					column(6,
						selectInput("contour.col", "Contour line color:",
							c("Black","White","Gray","Orange","Blue","Red","green",
								"R:Topo","R:Terrain","R:Heat","R:Cyan-Magenta","purple-yellow"),"R:Topo", width="100%"),
						sliderInput("contour.lwd","Line width:",1,5,1,1, width="100%"),
						selectInput("contour.asp", "Aspect ratio:", c("Original scale","Rescale to square"),"Original scale", width="100%")),
					column(6,
						selectInput("contour.nlevels","Approx. levels:",c(5,10,20,40),10, width="100%"),
						sliderInput("contour.labcex","Contour label size:",0.5,2,1,0.1, width="100%"),
						checkboxInput("contour.drawlabels","Draw labels",TRUE))
				)
			)
		)
	),
	conditionalPanel(condition=nonContourStatic,
		wellPanel(
			checkboxInput("showWP3", h5("Image properties"), FALSE),
			conditionalPanel(condition="input.showWP3",
				fluidRow(
					column(6, 
						selectInput("image.col", "Image colors:",
							c("R:Topo","R:Terrain","R:Heat","R:Cyan-Magenta","black-white","purple-yellow"),"R:Topo", width="100%")),
					column(6, sliderInput("image.nlevels","Number of breaks:",6,30,16,2, width="100%"))
				),
				fluidRow(
					column(6, selectInput("resfac", "Increase resolution by factor:", 1:4,1, width="100%")),
					column(6,
						checkboxInput("rasterImage","rasterImage() smoothing"),
						checkboxInput("contour","Add contour lines:"))
				),
				fluidRow(
					column(6, 
						selectInput("facets","Color cells or borders:", choices=c("Grid cells","Borders"), selected="Grid cells", width="100%")),
					column(6, selectInput("border", "Cell border color:", c("","White","Black"),"", width="100%"))
				),
				fluidRow(
					column(6, selectInput("lighting", "Lighting:", c("None","Default"),"None", width="100%")),
					column(6, sliderInput("shade","Shading:",0,1,0.5,0.05, width="100%"))
				),
				fluidRow(
					column(6, 
						selectInput("image.asp", "Aspect ratio:", c("Original scale","Rescale to square"),"Original scale", width="100%")),
					column(6, sliderInput("image.theta","Rotate (Uncheck smoothing):",-180,180,0,10, width="100%"))
				)
			)
		)
	),
	conditionalPanel(condition=any3DStatic,
		wellPanel(
			checkboxInput("showWP4", h5("Perspective properties"), FALSE),
			conditionalPanel(condition="input.showWP4",
				fluidRow(
					column(6, 
						selectInput("persp.col","Perspective colors:",
							c("R:Topo","R:Terrain","R:Heat","R:Cyan-Magenta","black-white","purple-yellow"),"R:Topo", width="100%")),
					column(6, sliderInput("adjustrelief","Scale relief:",-10,10,0,2, width="100%"))
				),
				fluidRow(
					column(6, 
						selectInput("persp.contourside","2D contour level(s):", c("","Below","Layered","Above"), "", multiple=T, width="100%")),
					column(6, sliderInput("persp.zlim1","Decrease lower Z-limit:",0,5,0,0.5, width="100%"))
				),
				fluidRow(
					column(6, selectInput("persp.imageside","2D image level:",c("","Below","Above"),"",multiple=T, width="100%")),
					column(6, sliderInput("persp.zlim2","Increase upper Z-limit:",0,5,0,0.5, width="100%"))
				),
				fluidRow(
					column(6, 
						selectInput("bty", "Box and background grid:", 
							c("Full box","Back panels only","Panels w/ grid lines","Gray w/ white lines",
								"Black","Black w/ gray lines"),"Black w/ gray lines", width="100%")),
					column(6, sliderInput("theta","Azimuthal viewing angle:",-180,180,40,10, width="100%"))
				),
				fluidRow(
					column(6, 
						selectInput("along", "Ribbons along:", c("x-axis","y-axis","both axes"),"x-axis", width="100%"), 
						checkboxInput("curtain","Drape edges")),
					column(6, sliderInput("phi","Colatitudinal viewing angle:",-90,90,40,10, width="100%"))
				)
			)
		)
	),
	conditionalPanel(condition="input.tsp==='p3Drgl'",
		wellPanel(
			checkboxInput("showWP5", h5("RGL properties"), FALSE),
			conditionalPanel(condition="input.showWP5",
				fluidRow(
					column(6, 
						selectInput("rglcol","RGL colors:",
							c("R:Topo","R:Terrain","R:Heat","R:Cyan-Magenta","black-white","purple-yellow"),"R:Topo", width="100%")),
					column(6, 
						selectInput("rglpointslines","Points/lines (if applicable):",c("Points","Lines"),"Points", width="100%"))
				),
				sliderInput("rgladjustrelief","Scale relief (percent):",-100,100,0,step=10, width="100%")
			)
		)
	),
	conditionalPanel(condition=anyPlot,
		wellPanel(
			checkboxInput("showWP6", h5("General properties"), FALSE),
			conditionalPanel(condition="input.showWP6",
				fluidRow(
					column(6,
						selectInput("colkey", "Color key:", c("None","Default","Manual"),"None", width="100%"),
						checkboxInput("clab", "Show key label:"),
						selectInput("NAcol", "NA color:", choices=c("white","black"), selected="white", width="100%")),
					column(6,
						selectInput("colkey.side","Color key position:", c("Bottom","Left","Top","Right"), "Right", width="100%"), 
						checkboxInput("colkey.addlines", "Add lines to key:"), 
						selectInput("bgcol", "Background color:", c("Black","White"),"Black", width="100%"))
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
			tabPanel("Reactives", value="nlp_reactivesR"),
			id="nlp",
			widths=c(12,1)
		),
		#fluidRow(
		#	column(6", selectInput("hltheme", "Code highlighting theme:", getAceThemes(), selected="clouds_midnight", width="100%")),
		#	column(6", selectInput("hlfontsize", "Font size:", seq(8,24,by=2), selected=12, width="100%"))
		#),
		h6(HTML(
			'<p style="text-align:justify;">I use code externalization for more complex apps to keep the
			<strong><span style="color:#3366ff;">R</span></strong> code organized.
			The <em>Header</em> (not shown), <em>Sidebar</em>, <em>Main</em>, and <em>About</em>
			<strong><span style="color:#3366ff;">R</span></strong> scripts are sourced at the top level on the <em>UI</em> side
			while <em>app.R</em> is sourced in <em>server.R</em>.
			In turn, <em>app.R</em> sources all of the reactive inputs/outputs/expressions
			in any remaining <strong><span style="color:#3366ff;">R</span></strong> scripts.</p>'
		))
	)#,
	#conditionalPanel(condition="input.tsp==='about'", h5(textOutput("pageviews")))
)
