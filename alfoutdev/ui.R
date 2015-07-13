# @knitr ui
tabPanelAbout <- source("about.R",local=T)$value

shinyUI(
    tagList(
    tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),
    navbarPage(theme=shinytheme("cosmo"),
	title=HTML('<div><a href="http://snap.uaf.edu" target="_blank"><img src="./img/SNAP_acronym_100px.png" width="80%"></a></div>'),
	windowTitle="Alf Out Dev",
	collapsible=TRUE,
	id="tsp",
    
    tabPanel("Site RAB", value="rab_ts"),
    tabPanel("Site CRAB", value="crab_ts"),
    tabPanel("Region TAB", value="tab_ts"),
    tabPanel("Region CTAB", value="ctab_ts"),
    tabPanel("Site FRP ~ Buffer", value="frp_buffer"),
    tabPanel("Site FRI Boxplots", value="fri_boxplot"),
    tabPanelAbout(),
	fluidRow(
		source("sidebar.R",local=T)$value,
		column(8,
            conditionalPanel("input.tsp=='rab_ts'", plotOutput("RAB_tsplot",height="auto"), br()),
            conditionalPanel("input.tsp=='crab_ts'", plotOutput("CRAB_tsplot",height="auto"), br()),
            conditionalPanel("input.tsp=='tab_ts'", plotOutput("RegTAB_tsplot",height="auto"), br()),
            conditionalPanel("input.tsp=='ctab_ts'", plotOutput("RegCTAB_tsplot",height="auto"), br()),
            conditionalPanel("input.tsp=='frp_buffer'", plotOutput("FRP_bufferplot",height="auto"), br()),
            conditionalPanel("input.tsp=='fri_boxplot'", plotOutput("FRI_boxplot",height="auto"), br())
		)
	)
)))
