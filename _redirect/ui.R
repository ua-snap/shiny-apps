shinyUI(fluidPage(theme="cyborg_bootstrap.css",

HTML('
<p><h4>Apps have been moved to a new server. Access below.</h4></p>
<p style="text-align:justify">All R Shiny apps are now hosted at the UAF links below.
The apps always had UAF urls, but those urls temporarily redirected to Spark at RStudio.
Please refer to these original UAF urls and not the deprecated Spark urls.
Another way to access all apps from a permanent location is via my <a href="http://leonawicz/github.io" target="_blank">Github.io</a> page.
This is preferred since the page you are on now is not guaranteed to remain available.</p>'),

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
	column(3,
		p(HTML('<ul>'),
			HTML('<li>'),a("RV_distributions", href="http://shiny.snap.uaf.edu/RV_distributions/", target="_blank"),HTML('</li>'),
			HTML('<li>'),a("RV_distributionsV2", href="http://shiny.snap.uaf.edu/RV_distributionsV2/", target="_blank"),HTML('</li>'),
			HTML('<li>'),a("RV_distributionsV3", href="http://shiny.snap.uaf.edu/RV_distributionsV3/", target="_blank"),HTML('</li>'),
			HTML('<li>'),a("RV_distributionsV4", href="http://shiny.snap.uaf.edu/RV_distributionsV4/", target="_blank"),HTML('</li>'),
		HTML('</ul>'))
	),
	column(3,
		p(HTML('<ul>'),
			HTML('<li>'),a("gbm_example", href="http://shiny.snap.uaf.edu/gbm_example/", target="_blank"),HTML('</li>'),
			HTML('<li>'),a("random_forest_example", href="http://shiny.snap.uaf.edu/random_forest_example/", target="_blank"),HTML('</li>'),
			HTML('<li>'),a("tree_rings", href="http://shiny.snap.uaf.edu/tree_rings/", target="_blank"),HTML('</li>'),
			HTML('<li>'),a("monty_hall", href="http://shiny.snap.uaf.edu/monty_hall/", target="_blank"),HTML('</li>'),
		HTML('</ul>'))
	),
	column(3,
		p(HTML('<ul>'),
			HTML('<li>'),a("sea_ice_winds", href="http://shiny.snap.uaf.edu/sea_ice_winds/", target="_blank"),HTML('</li>'),
			HTML('<li>'),a("sea_ice_coverage", href="http://shiny.snap.uaf.edu/sea_ice_coverage/", target="_blank"),HTML('</li>'),
			HTML('<li>'),a("temp_wind_events", href="http://shiny.snap.uaf.edu/temp_wind_events/", target="_blank"),HTML('</li>'),
			HTML('<li>'),a("ak_ice_edge", href="http://shiny.snap.uaf.edu/ak_ice_edge/", target="_blank"),HTML('</li>'),
		HTML('</ul>'))
	),
	column(3,
		p(HTML('<ul>'),
			HTML('<li>'),a("ak_station_cru_eda", href="http://shiny.snap.uaf.edu/ak_station_cru_eda/", target="_blank"),HTML('</li>'),
			HTML('<li>'),a("akcan_climate", href="http://shiny.snap.uaf.edu/akcan_climate/", target="_blank"),HTML('</li>'),
			HTML('<li>'),a("ak_daily_precipitation", href="http://shiny.snap.uaf.edu/ak_daily_precipitation/", target="_blank"),HTML('</li>'),
		HTML('</ul>'))
	)
)

))
