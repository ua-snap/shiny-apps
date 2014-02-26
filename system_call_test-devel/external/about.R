function(){
	tabPanel("About",
	div(style="background-color:#000000; opacity:0.9; padding: 25px 25px 25px 25px; height: 600px;",
		p(style="text-align:justify",'This R Shiny web app provides an illustration of the use of Random Forest, a tree-based, nonparametric regression/classification algorithm.
		The app makes use of an example dataset of various attributes of the flags of different nations, as well as some additional country metadata. The dataset is somewhat dated, published in 1986.
		For example, it still includes East and West Germany. Other information such as country population will similarly be quite out of date.
		Nevertheless, it is an interesting dataset and this app is just for illustration purposes anyhow. More details on the data can be found below.
		'),
		p(style="text-align:justify",'The app has sidebar inputs for choosing response and explanatory variables.
		Currently, I have restricted the choices of response variables to categorical variables, until I have a chance to generalize the app to include regression. As of now it is only geared toward classification.
		The other sidebar inputs are for random forest meta-parameters (arguments passed to randomForest in R). Right now I have limited this to the number of trees.'),
		p(style="text-align:justify",'The main panel has tabs for each of a number of summary plots, which show and update only after a random forest model has been built.
		I used ggplot2 to create these graphics. Each tab has a button for downloading the currently displayed plot as a pdf.
		Formatting of the downloaded file will not be identical to that shown in the browser.'),
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
			div(class="span4",strong('Related apps'),
				p(HTML('<ul>'),
					HTML('<li>'),a("Stochastic gradient boosting example using gbm", href="http://shiny.snap.uaf.edu/gbm_example/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("Alaska/ Western Canada climate data with ggplot", href="http://shiny.snap.uaf.edu/akcan_climate/", target="_blank"),HTML('</li>'),
				HTML('</ul>')),
				strong('Code'),
				p('Source code available at',
				a('GitHub', href="https://github.com/ua-snap/shiny-apps/tree/master/random_forest_example/", target="_blank")),
				br()
			),
			div(class="span4", strong('Related blog posts'),
				p(HTML('<ul>'),
					HTML('<li>'),a("R Shiny app: Stochastic gradient boosting with gbm", href="http://blog.snap.uaf.edu/2013/06/20/r-shiny-app-stochastic-gradient-boosting-with-gbm/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a("R Shiny app: Alaska/western Canada communities and climate", href="http://blog.snap.uaf.edu/2013/07/16/r-shiny-app-alaskawestern-canada-communities-and-climate/", target="_blank"),HTML('</li>'),
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
						HTML('<li>'),a('randomForest', href="http://cran.r-project.org/web/packages/randomForest/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('plyr', href="http://cran.r-project.org/web/packages/plyr/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('reshape2', href="http://cran.r-project.org/web/packages/reshape2/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('gridExtra', href="http://cran.r-project.org/web/packages/gridExtra/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('gtable', href="http://cran.r-project.org/web/packages/gtable/index.html", target="_blank"),HTML('</li>'),
					HTML('<ul>'),
				HTML('</ul>'))
			)
		),
		br()
	),
	value="about"
	)
}
