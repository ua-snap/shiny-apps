function(){
	tabPanel("About",
		p(style="text-align:justify",'This R Shiny web app allows the user to perform stochastic gradient boosting on a simulated dataset using the R gbm package.
		The simulated data come directly from the gbm help file. Currently, features are limited.'),
		p(style="text-align:justify",strong('Notes:'),'Also, the app will throw an error if you try to perform cross-validation when gradient boosting, i.e., by setting the number of cross-validation folds > 1.
		This meta-parameter setting corresponds to the cv.folds argument to the gbm function. The help file example will run fine in a stand-alone R session,
		but not when built into a Shiny app.
		I speculate that this has something to do with the current version of the gbm package attempting to take advantage of the base R parallel package, but I have not been able to solve the problem.
		If anyone else can figure it out, please let me know!'),
		p(style="text-align:justify",'I would like to continue enhancing this app with many additional features and graphics, not to mention switching over from the simulated dataset to something more real and relevant.
		Stay tuned for updates.'),
		br(),

		HTML('<div style="clear: left;"><img src="http://www.gravatar.com/avatar/52c27b8719a7543b4b343775183122ea.png" alt="" style="float: left; margin-right:5px" /></div>'),
		strong('Author'),
		p('Matthew Leonawicz',br(),
			'Statistician | useR',br(),
			a('Scenarios Network for Alaska and Arctic Planning', href="http://www.snap.uaf.edu/", target="_blank"),
			'|',
			a('Blog', href="http://blog.snap.uaf.edu/", target="_blank"),
			'|',
			a('LinkedIn', href="http://www.linkedin.com/in/leonawicz/", target="_blank")	
		),
		br(),
		
		div(class="row-fluid",
			div(class="span4",strong('Other apps'),
				p(HTML('<ul>'),
					HTML('<li>'),a("Sampling app version 4", href="http://shiny.snap.uaf.edu/RV_distributionsV4/", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				strong('Code'),
				p('Source code available at',
				a('GitHub', href="https://github.com/ua-snap/shiny-apps/tree/master/gbm_example/", target="_blank")),
				br()
			),
			div(class="span4", strong('Related blog posts'),
				p(HTML('<ul>'),
					HTML('<li>'),a("R Shiny app: Stochastic gradient boosting with gbm", href="http://blog.snap.uaf.edu/2013/06/20/r-shiny-app-stochastic-gradient-boosting-with-gbm/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("R sampling app version 4", href="http://blog.snap.uaf.edu/2013/05/20/r-sampling-app-version-4/", target="_blank"),HTML('</li>'),
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
						HTML('<li>'),a('gbm', href="http://cran.r-project.org/web/packages/gbm/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('ggplot2', href="http://ggplot2.org", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('plyr', href="http://cran.r-project.org/web/packages/plyr/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('reshape2', href="http://cran.r-project.org/web/packages/reshape2/index.html", target="_blank"),HTML('</li>'),
					HTML('<ul>'),
				HTML('</ul>'))
			)
		)
	)
}
