function(){
	tabPanel("About",
		HTML('
		<p style="text-align:justify">In the classic Monty Hall problem, there are three doors. Behind one of these doors is a car. Behind the other two stand goats.
		Monty Hall tells you to choose a door. You hope to win the car obviously, by randomly choose the correct door.
		After you make your choice, the door remains closed. Monty Hall then opens one of the other two doors, always to reveal a goat.
		After all, if you have not chosen the correct door, and  the car is behind one of the other two,
		what point is there in Monty showing you the car? That would end the game.
		After he shows you a goat, he gives you a simple choice. Do you want to stick to your guns and open the door you originally chose
		or do you want to switch the other unopened door? Does it make a difference in your chances of winning? It certainly does.</p>
		
		<p style="text-align:justify">This web application displays plots of probabilities of winning the car in more general versions of the Monty Hall game.
		There can be three or more doors. The Monty Hall function I wrote in R will allow any combination of numbers of doors selected (but unopened) by the player,
		and subsequently a mutually exclusive set of doors opened to reveal goats by Monty Hall,
		so long as the doors chosen by the player and by Monty leave at least one door unchosen by the player and unopened by Monty.
		However, for simplicity, time management, and a general interest in avoiding overkill at least for now,
		I have currently restricted the app to plotting probability heat maps of n x n grids where n is just less than half of N, the total number of doors.
		This way you get a square heat map of probabilities that at least pertain to somewhat more interesting games,
		rather than the full triangular matrix of all possible games, e.g., there are 25 doors, you select one,
		then Monty opens 23 doors to reveal goats and asks if you want to switch to the last remaining door. (You better switch! ALWAYS switch! But especially now!)</p>
		
		<p style="text-align:justify">One important point of clarification is that when the player and Monty both have multiple options,
		and not necessarily the same number of options either, the notion of switching is no longer trivial.
		Here I have chosen to simplify the idea of switching by what I am calling maximum switching.
		If the player chooses to switch, this means switching to as many of the initially unselected doors that remain closed after Monty hall reveals goats as possible.
		For example, say there are ten doors. The player chooses three, Monty opens three others. This leaves four doors to which the player can switch.
		Similar to the original Monty Hall problem, the player either sticks with the original three or completely switches to an alternative remaining three.
		Since there are four to choose from, the player simply chooses three of these four at random.
		Say there are ten doors, the player selects four, and Monty opens three. This leaves three.
		Switching in this scenario means the player will automatically select all three remaining doors, and then retain one at random from the original selection.
		Maximum switching means abandoning the original selection of doors as much as possible.'),

		HTML('
		<div style="clear: left;"><img src="http://www.gravatar.com/avatar/52c27b8719a7543b4b343775183122ea.png" alt="" style="float: left; margin-right:5px" /></div>
		<p>Matthew Leonawicz<br/>
		Statistician | useR<br/>
		<a href="http://leonawicz/github.io" target="_blank">Github.io</a> | 
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
				HTML('</ul>')),
				strong('Code'),
				p('Source code available at',
				a('GitHub', href="https://github.com/ua-snap/shiny-apps/tree/master/monty_hall/", target="_blank")),
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
						HTML('<li>'),"[None]",HTML('</li>'),
					HTML('<ul>'),
				HTML('</ul>'))
			)
		),
		value="about"
	)
}
