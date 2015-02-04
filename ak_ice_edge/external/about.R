function(){
	tabPanel("About",
		HTML(
		'<p style="text-align:justify">This R Shiny web application displays estimated sea ice edge. Work in progress. [Add details]</p>'),

		HTML('
		<div style="clear: left;"><img src="http://www.gravatar.com/avatar/52c27b8719a7543b4b343775183122ea.png" alt="" style="float: left; margin-right:5px" /></div>
		<p>Matthew Leonawicz<br/>
		Statistician | useR<br/>
		<a href="http://leonawicz/github.io" target="_blank">Github.io</a> | 
		<a href="http://blog.snap.uaf.edu" target="_blank">Blog</a> | 
		<a href="https://twitter.com/leonawicz" target="_blank">Twitter</a> | 
		<a href="http://www.linkedin.com/in/leonawicz" target="_blank">Linkedin</a> <br/>
		<a href="http://www.snap.uaf.edu/", target="_blank">Scenarios Network for Alaska and Arctic Planning</a>
		</p>'),
		
		fluidRow(
			column(4,
			strong('Other apps'),
				p(HTML('<ul>'),
					HTML('<li>'),a("Random variables: App tutorial part 1", href="http://shiny.snap.uaf.edu/RV_distributions/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Random variables: App tutorial part 2", href="http://shiny.snap.uaf.edu/RV_distributionsV2/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Random variables: App tutorial part 3", href="http://shiny.snap.uaf.edu/RV_distributionsV3/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Random variables: App tutorial part 4", href="http://shiny.snap.uaf.edu/RV_distributionsV4/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Sea ice and extreme wind events", href="http://shiny.snap.uaf.edu/sea_ice_winds/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Arctic sea ice extents and concentrations", href="http://shiny.snap.uaf.edu/sea_ice_coverage/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Coastal Alaska extreme temperatures and winds", href="http://shiny.snap.uaf.edu/temp_wind_events/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Alaska weather station and CRU EDA", href="http://shiny.snap.uaf.edu/ak_station_cru_eda/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Alaska and western Canada communities and climate", href="http://shiny.snap.uaf.edu/akcan_climate/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Alaska  communities historical daily precipitation", href="http://shiny.snap.uaf.edu/ak_daily_precipitation/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Gradient boosting example", href="http://shiny.snap.uaf.edu/gbm_example/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Basic example app with image() plots", href="http://shiny.snap.uaf.edu/tree_rings/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Monty Hall gone wild", href="http://shiny.snap.uaf.edu/monty_hall/", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				br()
			),
			column(4,
				strong('Related blog posts'),
				p(HTML('<ul>'),
					HTML('<li>'),a("Random variables: App tutorial part 1", href="http://blog.snap.uaf.edu/2013/05/20/introducing-r-shiny-web-apps/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Random variables: App tutorial part 2", href="http://blog.snap.uaf.edu/2013/05/20/r-sampling-app-version-2/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Random variables: App tutorial part 3", href="http://blog.snap.uaf.edu/2013/05/20/r-sampling-app-version-3/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Random variables: App tutorial part 4", href="http://blog.snap.uaf.edu/2013/05/20/r-sampling-app-version-4/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Sea ice and extreme wind events", href="http://blog.snap.uaf.edu/2013/09/09/r-shiny-app-arctic-sea-ice-concentration-and-extreme-winds/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Arctic sea ice extents and concentrations", href="http://blog.snap.uaf.edu/2013/05/20/r-shiny-web-app-sea-ice/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Coastal Alaska extreme temperatures and winds", href="http://blog.snap.uaf.edu/2013/05/20/r-shiny-web-app-extreme-events/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Alaska weather station and CRU EDA", href="http://blog.snap.uaf.edu/2013/05/20/r-shiny-web-app-alaska-climate-data-eda/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Alaska and western Canada communities and climate", href="http://blog.snap.uaf.edu/2013/07/16/r-shiny-app-alaskawestern-canada-communities-and-climate/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Alaska  communities historical daily precipitation", href="http://blog.snap.uaf.edu/2013/09/17/customizable-charts-with-r-base-graphics-and-shiny/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Gradient boosting example", href="http://blog.snap.uaf.edu/2013/06/20/r-shiny-app-stochastic-gradient-boosting-with-gbm/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Basic example app with image() plots", href="http://blog.snap.uaf.edu/2013/11/11/r-shiny-image-plots-no-frills-example/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Monty Hall gone wild", href="http://blog.snap.uaf.edu/2013/11/11/r-shiny-app-monty-hall-gone-wild/", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				br()
			),
			column(4,
				strong('References'),
				p(HTML('<ul>'),
					HTML('<li>'),a('Coded in R', href="http://www.r-project.org/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('Built with the Shiny package', href="http://www.rstudio.com/shiny/", target="_blank"),HTML('</li>'),
					HTML('<li>'),"Additional supporting R packages",HTML('</li>'),
					HTML('<ul>'),
					HTML('<li>'),a('shinyIncubator', href="https://github.com/rstudio/shiny-incubator", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('raster', href="http://cran.r-project.org/web/packages/raster/index.html", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('rasterVis', href="http://cran.r-project.org/web/packages/rasterVis/index.html", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('png', href="http://cran.r-project.org/web/packages/png/index.html", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('gridExtra', href="http://cran.r-project.org/web/packages/gridExtra/index.html", target="_blank"),HTML('</li>'),
					HTML('</ul>'),
					HTML('<li>Source code on <a href="https://github.com/ua-snap/shiny-apps/tree/master/ak_ice_edge/" target="_blank">GitHub</a></li>'),
				HTML('</ul>'))
			)
		),
		value="about"
	)
}
