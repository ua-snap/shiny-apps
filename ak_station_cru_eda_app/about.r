function(){
	tabPanel("About",
		p(style="text-align:justify",'This web application provides summary statistics, graphics, and basic exploratory data analysis of temeprature and precipitation data from interior Alaska weather stations
		as well as station-based observations from CRU (Climatological Research Unit) data.
		The app showcases some of the data inputs considered for use in a comparison of waeather station data with downscaled Global Circulation Model (GCM) historical values at corresponding grid cells.'),
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
					HTML('<li>'),a("Arctic Sea Ice Extents and Concentrations", href="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				strong('Code'),
				p('Source code available at',
				a('GitHub', href='https://github.com/ua-snap/shiny-apps/tree/master/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')),
				br()
			),
			div(class="span4", strong('Related blog posts'),
				p(HTML('<ul>'),
					HTML('<li>'),a("R Shiny web app: Exploring and comparing Alaska weather station and CRU data", href="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", target="_blank"),HTML('</li>'),
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
						HTML('<li>'),a('reshape2', href="http://cran.r-project.org/web/packages/reshape2/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('ggplot2', href="http://cran.r-project.org/web/packages/ggplot2/index.html", target="_blank"),HTML('</li>'),
					HTML('<ul>'),
				HTML('</ul>'))
			)
		)
	)
}
