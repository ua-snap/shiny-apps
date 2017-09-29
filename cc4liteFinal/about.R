tabPanel("About",
  h2("About this application"),
  HTML(
  '<p style="text-align:justify">This R Shiny web application presents future climate outlooks for various Alaska and western Canada communities.
	The type of plot shown is a range bar, or column range, plot. 
  It shows the range of values (minimum to maximum) among SNAP\'s five downscaled CMIP5/AR5 climate models.
	This highlights uncertainty about the future rather than focusing on an average, and without having to clutter the plot with additional ink.
	A range is shown similarly for the 30-year historical baseline comparison period, which is inclusive of inter-annual variability, 
  but does not include other sources of uncertainty.
	This is the final of several versions of the R Shiny-based Community Charts application. 
  See the <a href="https://leonawicz.github.io/CommCharts4/">CommCharts4</a> documentation for more information.</p>'),
  h2("Contact information"),
  HTML('
    <div style="clear: left;"><img src="https://www.gravatar.com/avatar/5ab20ebc3829054f8af7b1ea4a317269?s=128"
    alt="" style="float: left; margin-right:5px" /></div>
    <p>Matthew Leonawicz<br/>
    Statistician | useR<br/>
    <a href="https://leonawicz.github.io" target="_blank">Github.io</a> |
    <a href="http://blog.snap.uaf.edu" target="_blank">Blog</a> |
    <a href="https://twitter.com/leonawicz" target="_blank">Twitter</a> |
    <a href="http://www.linkedin.com/in/leonawicz" target="_blank">Linkedin</a> <br/>
    <a href="http://www.snap.uaf.edu/", target="_blank">Scenarios Network for Alaska and Arctic Planning</a>
    </p>'
  ),
  p("For questions about this application, please email mfleonawicz@alaska.edu"),
  
  p("This app is written in the", 
  a("R programming language", href="https://www.r-project.org/", target="_blank"), "and built with the", 
  a("Shiny", href="https://shiny.rstudio.com/", target="_blank"), "web application framework for R.
  Is your organization looking for similar web applications or dashboards for your data and analytics needs?
  SNAP designs R Shiny apps and other web-based tools and software ranging from simple to complex
  and suitable for a variety of stakeholders whose purposes include
  public outreach and scientific communication, directly supporting scientific research,
  and organizational data access and analytics.", 
  a("Contact us", href="https://www.snap.uaf.edu/about/contact/", target="_blank"), "for details.",
  style="text-align: justify;"),
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
                    <li><a href="http://rcharts.io/" target="_blank">rCharts</a></li>
                    <li><a href="http://plyr.had.co.nz/" target="_blank">plyr</a></li>
                    <li><a href="http://rstudio.github.io/leaflet/" target="_blank">plyr</a></li>
				</ul>
				<li>Source code on <a href="https://github.com/ua-snap/shiny-apps/tree/master/cc4liteFinal/" target="_blank">GitHub</a></li>
			</ul>')
		)
	),
	value="about"
)
