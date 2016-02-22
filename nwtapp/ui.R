source("about.R", local=T)

# for shinyapps.io, use theme="spacelab.css" with file in www folder.
# for local/RStudio and shiny-server, use theme="http://bootswatch.com/spacelab/bootstrap.css" (this is ignored on shinyapps.io)
# shinytheme() from shinythemes package must be avoided because it conflicts with bsModal in shinyBS.

shinyUI(navbarPage(theme="http://bootswatch.com/spacelab/bootstrap.css", inverse=TRUE,
  title=HTML('<div><a href="http://snap.uaf.edu" target="_blank"><img src="./img/SNAP_acronym_100px.png" width="100%"></a></div>'),
  windowTitle="NT Climate",
  collapsible=TRUE,
  id="nb",
  tabPanel("Climate", value="vis",
  bsModal("modal_loc", "Community Insights", "btn_modal_loc", size = "large",
    fluidRow(
      column(3,
        selectInput("loc_variable", "", var.labels, var.labels[1]),
        checkboxInput("loc_deltas", "Display deltas", FALSE)
      ),
      column(3,
        selectInput("loc_rcp", "", rcp.labels, rcp.labels[1]),
        checkboxInput("loc_cru", "Show historical", FALSE)
      ),
      column(3,
        selectInput("loc_stat", "", c("All GCMs", "Mean GCM", "Both"), "All GCMs"),
        checkboxInput("loc_trend", "Smooth trend", FALSE)
      ),
      column(3,
        selectInput("loc_toy", "", toy_list, toy_list[[1]][1])
      )
    ),
    plotOutput("TS_Plot"),
    fluidRow(
      column(3, downloadButton("dl_tsplot", "Get Plot", class="btn-block")),
      column(3, downloadButton("dl_loc_data", "Get Data", class="btn-block"))
    )
  ),
  div(class="outer",
  tags$head(includeCSS("www/styles.css")),
  leafletOutput("Map", width="100%", height="100%"),
  absolutePanel(top=20, left=60, height=20, width=600, h4("Northwest Territories Future Climate Outlook")),
  absolutePanel(id="controls", top=20, right=-10, height=200, width=400,
    sliderInput("dec", "Decade", min=min(decades), max=max(decades), value=max(decades), step=10, sep="", post="s", width="100%"),
    wellPanel(
      fluidRow(
        column(6,
          selectInput("toy", "Time of year", toy_list, toy_list[[1]][1]),
          selectInput("rcp", "RCP", rcp.labels, rcp.labels[1])
        ),
        column(6,
          selectInput("variable", "Variable", var.labels, var.labels[1]),
          selectInput("mod_or_stat", "GCM data", maptype_list, maptype_list[[1]][1])
        )
      ),
      conditionalPanel("input.show_communities == true",
        selectInput("location", "Community", c("", locs$loc), selected="", width="100%"),
          conditionalPanel("input.location !== null && input.location !== ''",
            actionButton("btn_modal_loc", "Community Insights", class="btn-block"))
      )
    ),
    conditionalPanel("input.show_extent == true",
      sliderInput("lon_range", "Longitude", min=ext[1], max=ext[2], value=ext[1:2], step=1, sep="", post="°", width="100%"),
      sliderInput("lat_range", "Latitude", min=ext[3], max=ext[4], value=ext[3:4], step=1, sep="", post="°", width="100%"))
  ),
  absolutePanel(id="controls", top=60, left=-20, height=300, width=300, draggable=FALSE,
    plotOutput("sp_density_plot", width="100%", height="auto")
  ),
  absolutePanel(bottom=10, left=10,
    conditionalPanel(is_gcm_string, checkboxInput("deltas", "Display deltas", FALSE)),
    checkboxInput("show_communities", "Show communities", TRUE),
    checkboxInput("show_extent", "Show/crop extent", FALSE),
    checkboxInput("show_colpal", "Show color options", FALSE),
    checkboxInput("legend", "Show legend", TRUE),
    checkboxInput("ttips", "Show popup details", TRUE)
  ),
  absolutePanel(id="controls", bottom=240, left=-10, height=190, width=320,
    conditionalPanel("input.show_colpal == true",
    wellPanel(
      fluidRow(
        column(6, selectInput("colpal", "Palette", colpals_list, colpals_list[[1]][1])),
        column(6, conditionalPanel("input.colpal == 'Custom div'", colourInput("col_med", "Med", value = "#CEEBF0")))
      ),
      fluidRow(
        column(6, conditionalPanel("input.colpal == 'Custom div' || input.colpal == 'Custom seq'",
          colourInput("col_low", "Low", value = "#000470"))),
        column(6, conditionalPanel("input.colpal == 'Custom div' || input.colpal == 'Custom seq'",
          colourInput("col_high", "High", value = "#8C0050")))
      )
    )
    )
  )
  )
  ),
  about
))
