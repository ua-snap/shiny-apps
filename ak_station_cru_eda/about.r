function(){
	tabPanel("About",
		HTML('<div style="float: right; margin: 0 5px 5px 10px;"><iframe width="560" height="315" src="//www.youtube.com/embed/ilZUzn3XUC0" frameborder="0" allowfullscreen></iframe></div>
		
		<p style="text-align:justify">This web application provides summary statistics, graphics, and basic exploratory data analysis of temperature and precipitation data from interior Alaska weather stations
		as well as station-based observations from CRU (Climatological Research Unit) data.
		The app showcases some of the data inputs considered for use in a comparison of weather station data with downscaled global climate model (GCM) historical values at corresponding grid cells.</p>
		
		<p style="text-align:justify">This app represents one of my earliest Shiny apps, and fairly complex for an early app. Although I maintain this app, I do not support any continued development.
		It has its limitations. The "user experience" is not what I would consider ideal, but good enough. The refresh (reactive flush) action of the app can sometimes be a bit annoying visually,
		but it functions properly and displays data accurately, in the ways which are permitted. Shiny coding best practices that I have picked up since this app was created will not find there way here.
		But it is still of interest.</p>'),

		HTML('
		<div style="clear: left;"><img src="http://www.gravatar.com/avatar/52c27b8719a7543b4b343775183122ea.png" alt="" style="float: left; margin-right:5px" /></div>
		<p>Matthew Leonawicz<br/>
		Statistician | useR<br/>
		<a href="http://leonawicz.github.io" target="_blank">Github.io</a> | 
		<a href="http://blog.snap.uaf.edu" target="_blank">Blog</a> | 
		<a href="https://twitter.com/leonawicz" target="_blank">Twitter</a> | 
		<a href="http://www.linkedin.com/in/leonawicz" target="_blank">Linkedin</a> <br/>
		<a href="http://www.snap.uaf.edu/", target="_blank">Scenarios Network for Alaska and Arctic Planning</a>
		</p>'),
		
		fluidRow(
			column(4,
				strong('Related apps'),
				p(HTML('<ul>'),
					HTML('<li>'),a("Coastal Alaska Extreme Temperature and Wind Events", href="http://shiny.snap.uaf.edu/temp_wind_events/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Arctic Sea Ice Extents and Concentrations", href="http://shiny.snap.uaf.edu/sea_ice_coverage/", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				strong('Code'),
				p('Source code available at',
				a('GitHub', href="https://github.com/ua-snap/shiny-apps/tree/master/ak_station_cru_eda", target="_blank")),
				br()
			),
			column(4,
				strong('Related blog posts'),
				p(HTML('<ul>'),
					HTML('<li>'),a("R Shiny web app: Alaska climate data EDA", href="http://blog.snap.uaf.edu/2013/05/20/r-shiny-web-app-alaska-climate-data-eda/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("R Shiny web app: Coastal Alaska extreme temperature and wind events", href="http://blog.snap.uaf.edu/2013/05/20/r-shiny-web-app-extreme-events/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("R Shiny web app: Arctic sea ice extents and concentrations", href="http://blog.snap.uaf.edu/2013/05/20/r-shiny-web-app-sea-ice/", target="_blank"),HTML('</li>'),
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
						HTML('<li>'),a('reshape2', href="http://cran.r-project.org/web/packages/reshape2/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('ggplot2', href="http://cran.r-project.org/web/packages/ggplot2/index.html", target="_blank"),HTML('</li>'),
					HTML('<ul>'),
				HTML('</ul>'))
			)
		),
		value="about"
	)
}
