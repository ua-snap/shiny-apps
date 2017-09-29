tabPanel("About",
	HTML(
	'<p style="text-align:justify">This R Shiny web application highlights analysis of historical and projected trends in Alaska growing season onset.</p>'),
		
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
			<p></p><ul>
				<li><a href="http://www.r-project.org/" target="_blank">Coded in R</a></li>
				<li><a href="http://www.rstudio.com/shiny/" target="_blank">Built with the Shiny package</a></li>
				<li>Additional supporting R packages</li>
				<ul>
                    <li><a href="http://rstudio.github.io/shinythemes/" target="_blank">shinythemes</a></li>
                    <li><a href="https://github.com/ebailey78/shinyBS" target="_blank">shinyBS</a></li>
				</ul>
				<li>Source code on <a href="https://github.com/ua-snap/shiny-apps/tree/master/cc4liteFinal/" target="_blank">GitHub</a></li>
			</ul>')
		)
	),
	value="about"
)
