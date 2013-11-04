function(){
	tabPanel("About",
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
		p(style="text-align:justify",strong('Notes:'),
		'Use the "# of Variables" tab with caution! Due to the use of cross-validation, which is additionally both nested and replicated, the data for this plot can take a while to generate,
		perhaps about one minute per replicate. I would love to parallelize this, but at this time I am restricted to serial processing. I am hopeful to see this change in the near future.
		When this function is processing, you will be able to move around to other tabs, but nothing new will happen.
		All other calls that would occur will be suspended until the replicates of the rfcv function have finished running.
		I included this in the app for now only so that I could share it with others and to demonstrate a need and make a case for better solutions.
		Otherwise I would certainly leave it out in its current form.'),
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
		br(),
		
		p(strong('Flag Dataset metadata')),
		p("A sample from the raw file found here, with some of minor edits, for instance I shortened some names and I don't use numeric IDs for factor variables in this app:
		Bache, K. & Lichman, M. (2013). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. Irvine, CA: University of California, School of Information and Computer Science."),
		strong('Source Information'),
		HTML('<ul>'),
			HTML('<li>'),'Creators: Collected primarily from the "Collins Gem Guide to Flags": Collins Publishers (1986).',HTML('</li>'),
			HTML('<li>'),'Donor: Richard S. Forsyth, Date: 5/15/1990',HTML('</li>'),
		HTML('</ul>'),
		strong('Usage'),
		HTML('<ul>'),
			HTML('<li>'),"Past Usage: None known other than what is shown in Forsyth's PC/BEAGLE User's Guide.",HTML('</li>'),
			HTML('<li>'),'This data file contains details of various nations and their flags. In this file the fields are separated by spaces (not commas).
			With this data you can try things like predicting the religion of a country from its size and the colours in its flag.',HTML('</li>'),
		HTML('</ul>'),
		strong('Attributes'),
		HTML('<ul>'),
			HTML('<li>'),"10 attributes are numeric-valued. The remainder are either Boolean-or nominal-valued.",HTML('</li>'),
			HTML('<li>'),'Number of Instances: 194. Number of attributes: 30 (overall).',HTML('</li>'),
			HTML('<ol>'),
				HTML('<li>'),'name: name of the country concerned',HTML('</li>'),
				HTML('<li>'),'landmass: 1=N.America, 2=S.America, 3=Europe, 4=Africa, 5=Asia, 6=Oceania',HTML('</li>'),
				HTML('<li>'),'zone: geographic quadrant, based on Greenwich and the Equator: 1=NE, 2=SE, 3=SW, 4=NW',HTML('</li>'),
				HTML('<li>'),'area: in thousands of square km',HTML('</li>'),
				HTML('<li>'),'population: in round millions',HTML('</li>'),
				HTML('<li>'),'language: 1=English, 2=Spanish, 3=French, 4=German, 5=Slavic, 6=Other, Indo-European, 7=Chinese, 8=Arabic, 9=Japanese/Turkish/Finnish/Magyar, 10=Others',HTML('</li>'),
				HTML('<li>'),'religion: 0=Catholic, 1=Other Christian, 2=Muslim, 3=Buddhist, 4=Hindu, 5=Ethnic, 6=Marxist, 7=Others',HTML('</li>'),
				HTML('<li>'),'bars: number of vertical bars in the flag',HTML('</li>'),
				HTML('<li>'),'stripes: number of horizontal stripes in the flag',HTML('</li>'),
				HTML('<li>'),'colours: number of different colours in the flag',HTML('</li>'),
				HTML('<li>'),'red: 0 if red absent, 1 if red present in the flag',HTML('</li>'),
				HTML('<li>'),'green: same for green',HTML('</li>'),
				HTML('<li>'),'blue: same for blue',HTML('</li>'),
				HTML('<li>'),'gold: same for gold (also yellow)',HTML('</li>'),
				HTML('<li>'),'white: same for white',HTML('</li>'),
				HTML('<li>'),'black: same for black',HTML('</li>'),
				HTML('<li>'),'orange: same for orange (also brown)',HTML('</li>'),
				HTML('<li>'),'mainhue: predominant colour in the flag (tie-breaks decided by taking the topmost hue, if that fails then the most central hue, and if that fails the leftmost hue)',HTML('</li>'),
				HTML('<li>'),'circles: number of circles in the flag',HTML('</li>'),
				HTML('<li>'),'crosses: number of (upright) crosses',HTML('</li>'),
				HTML('<li>'),'saltires: number of diagonal crosses',HTML('</li>'),
				HTML('<li>'),'quarters: number of quartered sections',HTML('</li>'),
				HTML('<li>'),'sunstars: number of sun or star symbols',HTML('</li>'),
				HTML('<li>'),'crescent: 1 if a crescent moon symbol present, else 0',HTML('</li>'),
				HTML('<li>'),'triangle: 1 if any triangles present, 0 otherwise',HTML('</li>'),
				HTML('<li>'),'icon: 1 if an inanimate image present (e.g., a boat), otherwise 0',HTML('</li>'),
				HTML('<li>'),'animate: 1 if an animate image (e.g., an eagle, a tree, a human hand) present, 0 otherwise',HTML('</li>'),
				HTML('<li>'),'text: 1 if any letters or writing on the flag (e.g., a motto or slogan), 0 otherwise',HTML('</li>'),
				HTML('<li>'),'topleft: colour in the top-left corner (moving right to decide tie-breaks)',HTML('</li>'),
				HTML('<li>'),'botright: colour in the bottom-left corner (moving left to decide tie-breaks)',HTML('</li>'),
			HTML('</ol>'),
		HTML('</ul>')
	)
}
