function(){
	tabPanel("About",
		HTML(
		'<p style="text-align:justify">This Shiny app displays plots made using the <em>plot3D</em>, <em>rgl</em>, and <em>shinyRGL</em> packages. Four datasets are currently available.
		The classic volcano dataset is provided in base <strong><span style="color:#3366ff;">R</span></strong> and the hypsometry data are loaded from the <em>plot3D</em> package.
		The latter is a larger dataset and will take longer to draw, especially 3D renderings.
		The other two datasets include a sinc function (sampling function, or cardinal sine function) and a Lorenz attractor.
		The Lorenz attractor dataset is only available for plotting in 3D with RGL. Other plotting options will not appear in the plot type menu when this dataset is selected.</p>
		
		<p style="text-align:justify">The app also features some custom CSS, a pdf download button for any of the static (non-RGL) graphics,
		and a tab for viewing the <strong><span style="color:#3366ff;">R</span></strong> code on which the app is based.
		The code has ACE syntax highlighting via the <em>shinyAce</em> package. The user can control the highlighting theme and font size.
		The plots have a dark theme to blend with the overall CSS. However, plot background color can be set to standard white. This is useful if you plan to print a plot.
		UPDATE: Code syntax highlighting using the <em>shinyAce</em> has been removed. Although it works in Windows via <code>runApp()</code> it is extremely buggy on various servers
		regardless of configurations or versioning. I have had to settle for using the Shiny showcase display mode, which is very elegant but ultimately provides less control.</p>'),


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
					HTML('<li>'),a('plot3D', href="http://cran.r-project.org/web/packages/plot3D/index.html", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('rgl', href="http://cran.r-project.org/web/packages/rgl/index.html", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('shinyRGL', href="http://cran.r-project.org/web/packages/shinyRGL/index.html", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('shinyAce', href="http://cran.r-project.org/web/packages/shinyAce/index.html", target="_blank"),HTML('</li>'),
					HTML('</ul>'),
					HTML('<li>Source code on <a href="https://github.com/ua-snap/shiny-apps/tree/master/plot3D/" target="_blank">GitHub</a></li>'),
				HTML('</ul>'))
			)
		),
		value="about"
	)
}
