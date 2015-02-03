function(){
	tabPanel("About",
		HTML('<p style="text-align:justify">This R Shiny web app compares downscaled outputs from CMIP3 and CMIP5 global climate models (GCMs) in a variety of ways.
		Downscaled observation-based historical data from the Climatological Research Unit (CRU 3.1) can be included in comparisons as well.</p>
		
		<p style="text-align:justify">Currently, there are five main plot types focusing on exploratory data analysis:
		basic time series plots (not time series analysis), scatter plots, heat maps, various plots designed to highlight variability, and distributional plots.
		A help section is under development.</p>'),

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
				strong('References'),
				p(HTML('<ul>'),
					HTML('<li>'),a('Coded in R', href="http://www.r-project.org/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('Built with the Shiny package', href="http://www.rstudio.com/shiny/", target="_blank"),HTML('</li>'),
					HTML('<li>'),"Primary supporting R packages",HTML('</li>'),
					HTML('<ul>'),
						HTML('<li>'),a('plyr', href="http://cran.r-project.org/web/packages/plyr/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('reshape2', href="http://cran.r-project.org/web/packages/reshape2/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('ggplot2', href="http://cran.r-project.org/web/packages/ggplot2/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('gridExtra', href="http://cran.r-project.org/web/packages/gridExtra/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('png', href="http://cran.r-project.org/web/packages/png/index.html", target="_blank"),HTML('</li>'),
						HTML('<li>'),a('Hmisc', href="http://cran.r-project.org/web/packages/Hmisc/index.html", target="_blank"),HTML('</li>'),
					HTML('</ul>'),
					HTML('<li>Source code on <a href="https://github.com/ua-snap/shiny-apps/tree/master/cmip3_cmip5/" target="_blank">GitHub</a></li>'),
				HTML('</ul>'))
			)
		),
		value="about"
	)
}
