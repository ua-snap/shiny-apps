function(){
	tabPanel("About",
		HTML('<div style="float: right; margin: 0 5px 5px 10px;"><iframe width="560" height="315" src="//www.youtube.com/embed/sxVPatuy0X0" frameborder="0" allowfullscreen></iframe></div>'),
		p(style="text-align:justify",'This web application shows the frequency (days per month) of extreme daily temperature and wind events from 1958 and projected through 2100 using global climate model (GCM) values, 
		which have been quantile mapped using the European Reanalysis (ERA-40) observation-based dataset as a historical baseline.
		Frequencies of events are displayed using a time series barplot. A bar can be drawn for each of any subset of months per year.
		Individual months can be highlighted by differently colored time series lines.'),
		p(style="text-align:justify",'The key feature of the app is that the bar plots are conditional bar plots, such that a set of multiple time series bar plots are displayed vertically for visual comparison,
		conditional on levels or classes of a given categorical variable.
		The user can view time series of extreme events for various specific climate variables, geographic locations, climate models, RCPs, and climate variable value thresholds.
		The user can select any one of these variables as a conditional variable to generate a comparative visual display of extreme events bar plots by factor levels of the chosen variable.'),
		p(style="text-align:justify",strong('Notes:'),' Geographic locations are represented by the names of the largest population centers,
		or other sensible region name in the case of no population (e.g, open ocean), for ease of reference, and do not represent point data.
		Values for all GCMs are at a common 2.5 x 2.5 degree resolution after having been regridded for quantile mapping to ERA-40. Therefore the scale is much larger than the place names might suggest.'),
		p(style="text-align:justify",'Positive values for directional wind velocity components indicate West to East and South to North, like an X-Y graph. Negative values indicate winds in the opposite directions.
		For overall wind speed, naturally, only positive thresholds may be selected since speed a magnitude (directionless) and thus is always non-negative. Wind is the square root of the sum of squares of the two velocity components.
		To clarify, the term, above thresholds, for wind velocity components means greater than the selected threshold value(s), as it does for wind speed and temperature. It does not mean further from zero.
		Note that any time the Wind variable is selected, wind threshold options will be limited.
		For example, if you are trying to place wind velocities and wind speed on the same plot, your velocity thresholds will be restricted to positive values due to the concurrent selection of wind speed.
		This is not a "bug" in the program, but rather an opportunity to point out that this web app is not meant to do it all.
		The purpose of the app is to provide a convenient way of interactively exploring a subset of the quantile-mapped daily GCM outputs that I have compiled.
		The goal is not to develop the perfect web tool, but rather to showcase the data that I have been working with.
		As such, there are no plans for continued development or refinement of this particular app.'),
		p(style="text-align:justify",strong('Suggestions:'),'You may download a graphic in pdf form for your convenience using the download button.
		Any plot you produce on the Conditional Barplots main tab, based on your selection of inputs in the sidebar panel, is downloadable in pdf form.
		Whenever you click the download button, you get whatever graphic is currently displayed in your browser.
		Formatting of the pdf plot will not match the browser plot exactly, but it will be a close approximation.'),
		p(style="text-align:justify",'For both the browser display and the pdf download, graphical formatting of the automated visualizations is best when comparing two to four time series barplots. Three is ideal.
		Too many comparisons in one plot, such as conditioning on location and selecting many locations, will make it impossible to achieve nice formatting in the space provided.
		Lastly, there is no appreciable performance hit for selecting several variables, models, RCPs, or thresholds.
		However, in the case of conditioning on locations, each location added to the plot will result in roughly a linear increase in plotting time required.
		This should not be an issue since more than approximately four locations compared at one time will be too visually cluttered anyhow.'),
		p(style="text-align:justify",em('This project is funded by the Alaska Ocean Observing System through its cooperative agreement ##NA11NOS0120020 with the National Oceanic and Atmospheric Administration (NOAA).
		Work was performed by the Alaska Center for Climate Assessment and Policy(ACCAP) at the University of Alaska Fairbanks (UAF) in partnership with the Scenarios Network for Alaska and Arctic Planning (SNAP, UAF).')),
		strong('Download source data'),
		br(),
		a('Quantile-mapped historical daily temperature', href="http://www.snap.uaf.edu/data.php#dataset=Historical_Daily_Mean_Quantile_Mapped_Temperatures", target="_blank"),
		br(),
		a('Quantile-mapped projected daily temperature', href="http://www.snap.uaf.edu/data.php#dataset=Projected_Daily_Mean_Quantile_Mapped_Temperatures", target="_blank"),
		br(),
		a('Quantile-mapped historical daily wind velocity', href="http://www.snap.uaf.edu/data.php#dataset=Historical_Daily_Quantile_Mapped_Near_Surface_Wind_Velocity", target="_blank"),
		br(),
		a('Quantile-mapped projected daily wind velocity', href="http://www.snap.uaf.edu/data.php#dataset=Projected_Daily_Quantile_Mapped_Near_Surface_Wind_Velocity", target="_blank"),
		br(),
		p(),

		HTML('<div style="clear: left;"><img src="http://www.gravatar.com/avatar/52c27b8719a7543b4b343775183122ea.png" alt="" style="float: left; margin-right:5px" /></div>'),
		strong('Author'),
		p('Matthew Leonawicz',br(),
			'Statistician | useR',br(),
			a('Scenarios Network for Alaska and Arctic Planning', href="http://www.snap.uaf.edu/", target="_blank"),
			'|',
			a('Blog', href="http://blog.snap.uaf.edu/", target="_blank"),
			'|',
			a('Twitter', href="https://twitter.com/leonawicz/", target="_blank"),
			'|',
			a('LinkedIn', href="http://www.linkedin.com/in/leonawicz/", target="_blank")	
		),
		br(),
		
		div(class="row-fluid",
			div(class="span4",strong('Related apps'),
				p(HTML('<ul>'),
					HTML('<li>'),a("Arctic Sea Ice Extents and Concentrations", href="http://shiny.snap.uaf.edu/sea_ice_coverage/", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				strong('Code'),
				p('Source code available at',
				a('GitHub', href="https://github.com/ua-snap/shiny-apps/tree/master/temp_wind_events/", target="_blank")),
				br()
			),
			div(class="span4", strong('Related blog posts'),
				p(HTML('<ul>'),
					HTML('<li>'),a("R Shiny web app: Coastal Alaska extreme temperature and wind events", href="http://blog.snap.uaf.edu/2013/05/20/r-shiny-web-app-extreme-events/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("R Shiny web app: Arctic sea ice extents and concentrations", href="http://blog.snap.uaf.edu/2013/05/20/r-shiny-web-app-sea-ice/", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				br()
			),
			div(class="span4",
				strong('References'),
				p(HTML('<ul>'),
					HTML('<li>'),a('Coded in R', href="http://www.r-project.org/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('Built with the Shiny package', href="http://www.rstudio.com/shiny/", target="_blank"),HTML('</li>'),
					HTML('<li>'),"Primary supporting R packages",HTML('</li>'),
					HTML('<ul>'),
						HTML('<li>'),a('mapproj', href="http://cran.r-project.org/web/packages/mapproj/", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('maps', href="http://cran.r-project.org/web/packages/maps/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('raster', href="http://cran.r-project.org/web/packages/raster/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('rasterVis', href="http://cran.r-project.org/web/packages/rasterVis/index.html", target="_blank"),HTML('</li>'),
					HTML('<ul>'),
				HTML('</ul>'))
			)
		),
		value="about"
	)
}
