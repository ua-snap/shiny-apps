function(){
	tabPanel("About",
		p(style="text-align:justify",'This R Shiny web app is currently under development.
		This release includes both historical and projected global climate model (GCM) output for temperature and precipitation, in the form of decadal means and totals, respectively.
		There are five AR4/CMIP3 GCMs and three emissions scenarios for each.'),
		p(style="text-align:justify",'The app currently has many features.
		The upper sidebar panel is for selecting subsets of data, choosing units of measurement, and performing the subset action and creating a new plot.
		The lower sidebar panel is for general plot formatting. Most options here will not auto-update the graphic in the main panel, but some may.
		Generally the user must click the update button. The formatting options that appear in the main panel below the plot are ones that will force an auto-upate of the plot as soon as they are changed.
		The app allows the user to look at many different kinds of subsets of the data in many ways. There is as much control over how the output graphic looks as there is in determining what data it graphs.
		There are also buttons at the bottom of the main panel for downloading a csv file of the currently selected data and a pdf of the current plot.'),
		p(style="text-align:justify",strong('Notes:'),
		'The app uses a large but not complete subset of the same cities from Alaska and Western Canada which are included in <a/ "http://www.snap.uaf.edu/charts.phpSNAPs" target="_blank">Community Charts tool</a>.
		There are somewhat fewer communities, including only those with populations greater than 2,500.
		However, there is more versatility in terms of data sources, selection/subsetting options, user control, plotting,
		and direct access to tabular data and graphic output in file format rather than strictly as browser viewing.'),
		p(style="text-align:justify",'Positive values for directional wind velocity components indicate...'),
		p(style="text-align:justify",strong('Suggestions:'),'For the time being, this developmental version of the app should function very well. Stay tuned for updates.
		There are a variety of features I am considering adding when I have time.
		These will likely spill over onto additional main panel tabs, somewhere between the two currently called "Communities" and "About".'),
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
					HTML('<li>'),a("Coastal Alaska extreme temperature and wind events", href="http://shiny.snap.uaf.edu/temp_wind_events/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Arctic Sea Ice Extents and Concentrations", href="http://shiny.snap.uaf.edu/sea_ice_coverage/", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				strong('Code'),
				p('Source code available at',
				a('GitHub', href="https://github.com/ua-snap/shiny-apps/tree/master/akcan_climate/", target="_blank")),
				br()
			),
			div(class="span4", strong('Related blog posts'),
				p(HTML('<ul>'),
					HTML('<li>'),a("R Shiny app: Alaska and western Canada climate", href="http://blog.snap.uaf.edu/2013/05/20/r-shiny-web-app-extreme-events/", target="_blank"),HTML('</li>'),
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
						HTML('<li>'),a('ggplot2', href="http://ggplot2.org", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('Hmisc', href="http://cran.r-project.org/web/packages/Hmisc/index.html", target="_blank"),HTML('</li>'),
					HTML('<ul>'),
				HTML('</ul>'))
			)
		)
	)
}
