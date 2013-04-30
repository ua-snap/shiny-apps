function(){
	tabPanel("About",
		p(style="text-align:justify",'This web application shows extreme temperature and wind events from 1958 and projected through 2100.
		Frequencies of events per month are displayed using a time series barplot. A bar can be drawn for each of any subset of months per year.
		Individual months can be highlighted by differently colored time series lines.'),
		p(style="text-align:justify",'The key feature of the app is that the barplots are condititional barplots, in the sense that a set of barplots are displayed vertically for visual comparison,
		conditional on levels or classes of a given categorical variable.
		The user can view time series of extreme events for various specific geographic locations, climate models, RCPs, climate variables, and climate variable value thresholds,
		The user can select any one of these variables as a conditional variable to generate a comparative visual display of extreme events barplots by factor levels of the chosen variable.'),
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
					HTML('<li>'),a("Arctic Sea Ice Extents and Concentrations", href="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", target="_blank"),HTML('</li>'),
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
