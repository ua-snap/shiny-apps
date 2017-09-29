# @knitr about
function(){
	tabPanel("About",
		HTML(
		'<p style="text-align:justify">This R Shiny web application displays relative area burned and relative cumulative area burned time series,
        fire rotation period by buffer size, and fire return interval boxplots, around various geographic sites.
        It also shows regional totals for area burned and cumulative area burned, which can be conditioned on underlying vegetation class.
        The modeled outputs come from ALFRESCO simulation replicates and are compared with observational fire scar data.</p>
        <p style="text-align:justify">The app currently makes use of ALFRESCO output R workspace files which contain annual vegetation-specific individual fire sizes,
        though this fully disaggregated data is not implemented in an app graphs yet, such as fire size distribution plots.</p>'),
		br(),

		HTML('
		<div style="clear: left;"><img src="http://www.gravatar.com/avatar/52c27b8719a7543b4b343775183122ea.png" alt="" style="float: left; margin-right:5px" /></div>
		<p>Matthew Leonawicz<br/>
		Statistician | useR<br/>
		<a href="https://leonawicz.github.io" target="_blank">Github.io</a> | 
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
                    <li><a href="http://rstudio.github.io/shinythemes/" target="_blank">shinythemes</a></li>
                    <li><a href="http://cran.r-project.org/web/packages/ggplot2/index.html" target="_blank">ggplot2</a></li>
                    <li><a href="http://cran.r-project.org/web/packages/data.table/index.html" target="_blank">data.table</a></li>
                    <li><a href="http://cran.r-project.org/web/packages/dplyr/index.html" target="_blank">dplyr</a></li>
                    </ul>
                    <li>Source code on <a href="https://github.com/ua-snap/shiny-apps/tree/master/alfoutdev/" target="_blank">GitHub</a></li>
                </ul>')
            )
        ),
		value="about"
	)
}
