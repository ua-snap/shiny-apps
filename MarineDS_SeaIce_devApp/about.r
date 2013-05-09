function(){
	tabPanel("About",value="ts",
		p(style="text-align:justify",'This web application shows sea ice coverage over the Arctic from 1860 and projected through 2099.
		The first tab includes a time series plot of total sea ice extent by global circulation model (GCM), including a five-model averaged composite.
		Linear, quadratic, and locally weighted Loess fitted trends are available for overlay.
		Fitted trend model output is displayed below the plot for each climate model and regression model.'),
		p(style="text-align:justify",'The second tab shows a panel graphic of spatially explicit sea ice concentration values for each model including the composite.
		This graphic is for illustration purposes only and should not be treated as spatially accurate with respect to the displayed land masses.
		Pixels from the original raster datasets, aggregated to a coarser scale (for app efficiency),
		are not intended to line up perfectly with the overlain landmass outlines, which are provided only for convenient reference and visual orientation for the user.'),
		p(style="text-align:justify",'The purpose of the app is to provide a relatively simple and convenient way of interactively exploring a subset of aggregated (across time and space) GCM sea ice outputs.
		The goal is not to develop the perfect web tool, but rather to showcase some of the data.
		As such, there are no plans for continued development or refinement of this particular app.'),
		br(),

		HTML('<div style="clear: left;"><img src="http://www.gravatar.com/avatar/52c27b8719a7543b4b343775183122ea.png" alt="" style="float: left; margin-right:5px" /></div>'),
		strong('Author'),
		p('Matthew Leonawicz',br(),
			'Statistician | useR',br(),
			a('Scenarios Network for Alaska and Arctic Planning', href="http://www.snap.uaf.edu/", target="_blank"),
			'|',
			a('Blog', href="http://blog.snap.uaf.edu/", target="_blank")
		),
		br(),
		
		div(class="row-fluid",
			div(class="span4",strong('Related apps'),
				p(HTML('<ul>'),
					HTML('<li>'),a("Coastal Alaska Extreme Temperature and Wind Events", href="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				strong('Code'),
				p('Source code available at',
				a('GitHub', href='https://github.com/ua-snap/shiny-apps/tree/master/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')),
				br()
			),
			div(class="span4", strong('Related blog posts'),
				p(HTML('<ul>'),
					HTML('<li>'),a("R Shiny web app: Coastal Alaska extreme temperature and wind events", href="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("R Shiny web app: Arctic sea ice extents and concentrations", href="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				br()
			),
			div(class="span4",
				strong('References'),
				p(HTML('<ul>'),
					HTML('<li>'),a('Coded in R', href="http://www.r-project.org/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('Built with the Shiny package', href="http://www.rstudio.com/shiny/", target="_blank"),HTML('</li>'),
					HTML('<li>'),"Additional supporting R packages",HTML('</li>'),
					HTML('<ul>'),
						HTML('<li>'),a('mapproj', href="http://cran.r-project.org/web/packages/mapproj/", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('maps', href="http://cran.r-project.org/web/packages/maps/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('raster', href="http://cran.r-project.org/web/packages/raster/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('rasterVis', href="http://cran.r-project.org/web/packages/rasterVis/index.html", target="_blank"),HTML('</li>'),
					HTML('<ul>'),
				HTML('</ul>'))
			)
		)
	)
}
