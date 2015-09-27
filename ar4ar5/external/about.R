# @knitr about
function(){
	tabPanel("About",
		HTML('<p style="text-align:justify">This R Shiny web app compares downscaled outputs from AR4 (CMIP3) and AR5 (CMIP5) global climate models (GCMs) in a variety of ways.
		Downscaled observation-based historical data from the Climatological Research Unit (CRU 3.2) can be included in comparisons as well.</p>
		
		<p style="text-align:justify">Currently, there are five main plot types focusing on exploratory data analysis:
		basic time series plots (not time series analysis), scatter plots, heat maps, various plots designed to highlight variability, and distributional plots.
		See the help section for more details on app usage, features, and limitations. Visit the Github page if you find a bug or other issue.
        It may already be filed and I am not actively working on this project, but it is worth checking.</p>'),

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
				HTML('<strong>References</strong>
                <p><ul>
                    <li><a href="http://www.r-project.org/" target="_blank">Coded in R</a></li>
                    <li><a href="http://www.rstudio.com/shiny/" target="_blank">Built with the Shiny package</a></li>
                    <li>Additional supporting R packages</li>
				<ul>
                    <li><a href="http://cran.r-project.org/web/packages/plyr/index.html" target="_blank">plyr</a></li>
                    <li><a href="http://cran.r-project.org/web/packages/reshape2/index.html" target="_blank">reshape2</a></li>
                    <li><a href="https://cran.r-project.org/web/packages/data.table/index.html" target="_blank">data.table</a></li>
                    <li><a href="https://cran.r-project.org/web/packages/RColorBrewer/index.html" target="_blank">RColorBrewer</a></li>
                    <li><a href="http://cran.r-project.org/web/packages/ggplot2/index.html" target="_blank">ggplot2</a></li>
                    <li><a href="http://cran.r-project.org/web/packages/gridExtra/index.html" target="_blank">gridExtra</a></li>
                    <li><a href="http://cran.r-project.org/web/packages/png/index.html" target="_blank">png</a></li>
                    <li><a href="http://cran.r-project.org/web/packages/Hmisc/index.html" target="_blank">Hmisc</a></li>
                    <li><a href="https://cran.r-project.org/web/packages/markdown/index.html" target="_blank">markdown</a></li>
                    <li><a href="https://rstudio.github.io/DT/" target="_blank">DT</a></li>
                    <li><a href="http://rstudio.github.io/shinythemes/" target="_blank">shinythemes</a></li>
				</ul>
                    <li>Source code on <a href="https://github.com/ua-snap/shiny-apps/tree/master/ar4ar5/" target="_blank">GitHub</a></li>
			</ul>')
			)
		),
		value="about"
	)
}
