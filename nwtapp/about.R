about <- tabPanel("About",
  HTML(
    '<p style="text-align:justify">This R Shiny web application presents future climate outlooks for Northwest Territories (NT), Canada.
    Decadal maps show spatially explicit projections of temperature and precipitation based on SNAP\'s downscaled CMIP5 global climate models (GCMs) for three emissions scenarios.
    Climate trends are available as raw values or as changes from 1961-1990 baseline averages.
    Historical baselines are based on SNAP\'s downscaled historical data from the Climatological Research Unit (CRU) version 3.2 time series
    and the CRU 10-minute resolution climatology 2.0, to which the GCMs are also downscaled.
    When viewing raw values, available maps consist of individual GCMs or maps which aggregate or compare those models.</p>
    <p style="text-align:justify">NT communities are also available. When viewing a community summary, a time series plot will appear highlighting trends for the community.
    Even though the maps are at a decadal resolution, community data is annual.
    NT communities in the app are a small subset of those found in the Alaska and western Canada <a href="http://shiny.snap.uaf.edu/cc4liteFinal/">Community Charts R app</a>.</p>'
  ),
  HTML(
    '<strong>Notes</strong>
    <p></p>
    <p style="text-align:justify">RCP stands for Representative Concentration Pathways.
    RCPs 4.5, 6.0 and 8.5 cover a range of possible future climates based on atmospheric greenhouse gas concentrations.</p>
    <p style="text-align:justify">Deltas are changes from 1961-1990 downscaled CRU 3.2 historical baseline averages.
    Changes in temperature are differences whereas changes in precipitation are proportional.</p>'
  ),
  fluidRow(
    column(3, actionButton("btn_help_rcps", "More About RCPs", class="btn-block"), br()),
    column(3, actionButton("btn_help_locs", "About communities", class="btn-block"), br())
  ),
  bsModal("modal_help_rcps", "Representative Concentration Pathways", "btn_help_rcps", size="large",
    HTML('
      <p style="text-align:justify">Together the RCPs show a range of possible future atmospheric greenhouse gas concentrations driven by human activity.
      The RCP values represent radiative forcing (W/m^2) in 2100 relative to pre-industrial levels.
      For example, greenhouse gas concentrations in 2100 which lead to the net solar energy absorbed by each square meter of Earth
      averaging 4.5 W/m^2 greater than pre-industrial levels is referred to as RCP 4.5.</p>

      <p style="text-align:justify">RCP 4.5 can be thought of as the "low" scenario.
      It assumes peak emissions around 2040 with radiative forcing stabilizing around 2100.
      RCP 6.0 (medium) assumes peak emissions around 2080, then decline due to future technology and management, with radiative forcing similarly stabilizing around 2100.
      RCP 8.5 (high) assumes increasing emissions through 2100.
      RCP 2.6 assumes peak emissions between 2010 and 2020 - essentially that we are already there - and then decline substantially. This is unrealistic so it is not included.</p>
      More information on these RCPs can be found in the 2014 IPCC fifth Assessment Report.'
    )
  ),
  bsModal("modal_help_locs", "Northwest Territories communities", "btn_help_locs", size="large",
    HTML('
      <p style="text-align:justify">The Northwest Territories communities in this app are a small subset of about 4,000 communities
      in the Alaska and western Canada <a href="http://shiny.snap.uaf.edu/cc4liteFinal/">Community Charts app</a>.
      Communities are not truly point data, e.g., weather station data.
      Rather, they are based on SNAP\'s downscaled climate data sets and a "community" refers to the <em>grid cell</em> which contains a community\'s coordinates.</p>

      <p style="text-align:justify">Downscaled climate for the Northwest Territories is restricted to a 10-minute by 10-minute resolution.
      The community data cannot be thought of as true community-level data.
      There are other minor annoyances with the data such as some communities not having the most precise coordinates.
      However, this is a negligible source of error compared to the uncertainty in future climate.</p>'
    )
  ),
  HTML('
    <div style="clear: left;"><img src="http://www.gravatar.com/avatar/52c27b8719a7543b4b343775183122ea.png" alt="" style="float: left; margin-right:5px" /></div>
    <p>Matthew Leonawicz<br/>
    Statistician | useR<br/>
    <a href="http://leonawicz.github.io" target="_blank">Github.io</a> |
    <a href="http://blog.snap.uaf.edu" target="_blank">Blog</a> |
    <a href="https://twitter.com/leonawicz" target="_blank">Twitter</a> |
    <a href="http://www.linkedin.com/in/leonawicz" target="_blank">Linkedin</a> <br/>
    <a href="http://www.snap.uaf.edu/", target="_blank">Scenarios Network for Alaska and Arctic Planning</a>
    </p>'
  ),
  fluidRow(
    column(4,
      HTML('<strong>References</strong>
        <p></p>
        </ul>
        <li>Source code on <a href="https://github.com/ua-snap/shiny-apps/tree/master/ntwapp/" target="_blank">GitHub</a></li>
        </ul>')
      )
   ),
 value="about"
)
