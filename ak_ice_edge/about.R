tabPanel("About",
	HTML(
	'<p style="text-align:justify">This R Shiny web application displays estimated sea ice edge.
	It is a work in progress and may feed into other projects with an expanded scope.</p>
	
	<p style="text-align:justify;">Displaying annual ice edges shows variability around the mean.
	Some plots reveal limitations of the estimator as averaged over a decadal time frame,
	where the decadal mean line does not always look subjectively like it is in the "middle" of the annual estimated 15% concentration contours.
	Annual edges use semi-transparent color so that inter-annual variability is visible without obstructing the decadal mean.</p>
	
	<p style="text-align:justify;">Colors come from <code>RColorBrewer</code>. Sequential and divergent palettes are most appropriate.
	Qualitative colors may be helpful when viewing few levels, so I have chosen to offer them. With too many levels the qualitative palette will repeat.
	However, it would be difficult to view these data with a high number of colors from any palette.
	I recommend reducing the number of levels of the primary (coloring) variable to something manageable and readable for a single plot.
	When using sequential or divergent palettes, the app attempts to remove the whitest color level (first or middle, respectively) from the current palette to reduce competition from the white plot background.</p>
	
	<p style="text-align:justify;">Due to the amount of layering required, plotting may take several seconds, higher quality downloads somewhat longer.
	Generate a map in the browser and/or download a PNG using the buttons above.
	PNG formatting differs slightly from browser formatting.</p>'),
		
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
			strong('References'),
			p(HTML('<ul>'),
				HTML('<li>'),a('Coded in R', href="http://www.r-project.org/", target="_blank"),HTML('</li>'),
				HTML('<li>'),a('Built with the Shiny package', href="http://www.rstudio.com/shiny/", target="_blank"),HTML('</li>'),
				HTML('<li>'),"Additional supporting R packages",HTML('</li>'),
				HTML('<ul>'),
				HTML('<li>'),a('shinyIncubator', href="https://github.com/rstudio/shiny-incubator", target="_blank"),HTML('</li>'),
				HTML('<li>'),a('raster', href="http://cran.r-project.org/web/packages/raster/index.html", target="_blank"),HTML('</li>'),
				HTML('<li>'),a('rasterVis', href="http://cran.r-project.org/web/packages/rasterVis/index.html", target="_blank"),HTML('</li>'),
				HTML('<li>'),a('png', href="http://cran.r-project.org/web/packages/png/index.html", target="_blank"),HTML('</li>'),
				HTML('<li>'),a('gridExtra', href="http://cran.r-project.org/web/packages/gridExtra/index.html", target="_blank"),HTML('</li>'),
				HTML('</ul>'),
				HTML('<li>Source code on <a href="https://github.com/ua-snap/shiny-apps/tree/master/ak_ice_edge/" target="_blank">GitHub</a></li>'),
			HTML('</ul>'))
		)
	),
	value="about"
)
