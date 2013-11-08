function(){
	tabPanel("About",
		p(style="text-align:justify",'This ',a("Shiny", href="http://www.rstudio.com/shiny/", target="_blank"),' application is version four of an expanding app intended for showing various ways of adding 
		desired complexity to your apps, in small digestible doses.
		The premise of this particular app is not complex. This sampling app simply draws random samples from a number of different probability distributions and plots the samples using
		(almost entirely) base R functions.'),
		p(style="text-align:justify",'The utility is in seeing, from version to version, how we can enhance a Shiny app.
		If you are new to Shiny, I hope you find this series helpful and/or inspirational in creating your own Shiny web applications. Shiny is new to me as well. I too am learning as I go.
		I would be happy for any suggestions of ways to improve my code.'),
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
			div(class="span3",strong('Other app versions'),
				p(HTML('<ul>'),
					HTML('<li>'),a("Version 1", href="http://shiny.snap.uaf.edu/RV_distributions/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Version 2", href="http://shiny.snap.uaf.edu/RV_distributionsV2/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Version 3", href="http://shiny.snap.uaf.edu/RV_distributionsV3/", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				strong('Code'),
				p('Source code available at',
				a('GitHub', href='https://github.com/ua-snap/shiny-apps/tree/master/RV_distributionsV4', target="_blank")),
				br()
			),
			div(class="span3", strong('Related blog posts'),
				p(HTML('<ul>'),
					HTML('<li>'),a("Introducing R Shiny web apps", href="http://blog.snap.uaf.edu/2013/05/20/introducing-r-shiny-web-apps/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("R sampling app version 2", href="http://blog.snap.uaf.edu/2013/05/20/r-sampling-app-version-2/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("R sampling app version 3", href="http://blog.snap.uaf.edu/2013/05/20/r-sampling-app-version-3/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("R sampling app version 4", href="http://blog.snap.uaf.edu/2013/05/20/r-sampling-app-version-4/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Mathematical notation in R plots", href="http://blog.snap.uaf.edu/2013/03/25/mathematical-notation-in-r-plots/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Mathematical notation in R plots 2", href="http://blog.snap.uaf.edu/2013/05/14/mathematical-notation-in-r-plots-2/", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				br()
			),
			div(class="span3",
				strong('References'),
				p(HTML('<ul>'),
					HTML('<li>'),a('R', href="http://www.r-project.org/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Shiny", href="http://www.rstudio.com/shiny/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('VGAM', href="http://cran.r-project.org/web/packages/VGAM/index.html", target="_blank"),HTML('</li>'),
				HTML('</ul>'))
			)
		)
	)
}
