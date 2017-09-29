about <- tabPanel("About",
  HTML(
  '<p style="text-align:justify">This Shiny app displays plots made using the <em>plot3D</em> and <em>rglwidgets</em> packages. Four datasets are currently available.
  The classic volcano dataset is provided in base <strong><span style="color:#3366ff;">R</span></strong> and the hypsometry data are loaded from the <em>plot3D</em> package.
  The latter is a larger dataset and will take longer to draw, especially 3D renderings. It is best to explore the <em>rgl</em> settings using the volcano dataset.
  The other two datasets include a sinc function (sampling function, or cardinal sine function) and a Lorenz attractor.
  The Lorenz attractor dataset is only available for plotting in 3D with RGL. Other plotting options will not appear in the plot type menu when this dataset is selected.</p>
  
  <p style="text-align:justify">The app also features a pdf download button for any of the static (non-RGL) graphics.
  The plots have a dark theme to blend with the the app CSS theme. Plot background can be set to white, e.g. for printing.</p>'),

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
      HTML('<h5>References</h5>
        <p></p>
        </ul>
        <li>Source code on <a href="https://github.com/ua-snap/shiny-apps/tree/master/plot3D/" target="_blank">GitHub</a></li>
        </ul>')
      )
   ),
  value="about"
)
