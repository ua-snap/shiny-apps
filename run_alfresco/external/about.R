function(){
	tabPanel("About",
	HTML('<div>style="background-color:#000000; opacity:0.9; padding: 25px 25px 25px 25px; height: 800px;"</div>
		
		<p style="text-align:justify">This R Shiny web application, hosted on SNAP\'s Eris server, enables a user to launch ALFRESCO jobs on SNAP\'s Atlas cluster conveniently via an internet browser.
		The user selects options for their ALFRESCO job and then submits the job. First, some job-specific directories are created on Atlas.
		Next, job-specific files are transferred from Eris to Atlas.
		Other supporting files and data which do not change from job to job are already stored on Atlas. Some reside in standard locations. Others are copied into these new directories on Atlas as well.
		At this point everything is in place to run ALFRESCO. The final system() call made by R in the app is to launch a SLURM script via sbatch on Atlas.</p>
		
		<p style="text-align:justify">Aside from initially compiling the user\'s inputs and sending the information to Atlas to prepare for a job, this app essentially serves the purpose of telling another process to run on another server.
		Whatever processes are in the SLURM scripts executed with sbatch on Atlas are what will occur on that system.
		Currently, the SLURM script called by this app will run ALFRESCO under certain conditions, followed by post-processing of ALFRESCO output in R yielding some stock summaries, graphics, and data.
		One goal is to include among these results an auto-generated Shiny app to provide interactive exploration of the post-processing results, which would be passed back to Eris for web hosting,
		with a Eris url being emailed to the user.</p>'),


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
					HTML('<li>'),"Primary supporting R packages",HTML('</li>'),
					HTML('<ul>'),
						HTML('<li>'),a('assertive', href="http://cran.r-project.org/web/packages/assertive/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('shinyAce', href="http://cran.r-project.org/web/packages/shinyAce/index.html", target="_blank"),HTML('</li>'),
					HTML('</ul>'),
				HTML('</ul>')),
				strong('Code'),
				p('Source code available at',
				a('GitHub', href="https://github.com/ua-snap/shiny-apps/tree/master/system_call_test-devel/", target="_blank"))
			)
		),
		value="about"
	)
}
