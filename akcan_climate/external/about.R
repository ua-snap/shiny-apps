function(){
	tabPanel("About",
		p(style="text-align:justify",'This R Shiny web app is currently under development.
		The data in the app and their varied representations are subject to change and should not be considered valid and vetted until the final version is released and this message has been removed.
		This release includes both historical and projected global climate model (GCM) output for decadal mean temperature and precipitation.
		There are five Coupled Model Intercomparison Project Phase 3 (CMIP3) GCMs and three emissions scenarios for each.'),
		p(style="text-align:justify",'The app currently has many features.
		The upper sidebar panel is for selecting subsets of data, choosing units of measurement, and performing the subset action and creating a new plot.
		Any time data selections are altered, a new subset and plot must be generating by clicking the appropriate button.'),
		p(style="text-align:justify",'The lower sidebar panel is for general plot formatting.
		Most options here will not auto-update the graphic in the main panel, but currently some may.
		Also, some options are mutually exclusive, so selecting one may immediately alter the selection of another, which may auto-update the plot.
		Generally, however, as with data selection, the user must click the corresponding update button after making changes to formatting selections.
		The formatting options that appear in the main panel below the plot are ones that will always force an auto-upate of the plot as soon as they are changed.'),
		p(style="text-align:justify",'The app allows the user to look at many different kinds of subsets of the data in many ways.
		There is as much control over how the output graphic looks as there is in determining which data it graphs.
		There are also buttons at the bottom of the main panel for downloading a csv file of the currently selected data and a pdf of the current plot.'),
		p(style="text-align:justify",strong('Notes:'),
		'The app uses a large but incomplete subset of the same cities from Alaska and Western Canada which are included in the SNAP ',
		a("Community Charts",href="http://www.snap.uaf.edu/charts.php", target="_blank"),
		'tool. There are somewhat fewer communities, including only those with populations greater than 2,500.
		However, there is more versatility in terms of data sources, selection/subsetting options, user control, plotting,
		and direct access to tabular data and graphic output in file format rather than strictly as browser viewing.
		I cannot vouch for the population data. I am sure that for some locations the population value shown in small table below the plot has low precision and/or accuracy, or is at least out of date,
		but it is not relevant to the app. I only mention it since the numbers are in fact displayed on the screen.'),
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
			a('Blog', href="http://blog.snap.uaf.edu/", target="_blank"),
			'|',
			a('LinkedIn', href="http://www.linkedin.com/pub/matthew-leonawicz/85/1/234", target="_blank")	
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
