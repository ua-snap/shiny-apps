sidebarPanel(
	tags$head(
		tags$style(type="text/css", "label.radio { display: inline-block; }", ".radio input[type=\"radio\"] { float: none; }"),
		tags$style(type="text/css", "select { max-width: 150px; }"),
		tags$style(type="text/css", "textarea { max-width: 150px; }"),
		tags$style(type="text/css", ".jslider { max-width: 500px; }"),
		tags$style(type='text/css', ".well { max-width: 500px; }"),
		tags$style(type='text/css', ".span4 { max-width: 500px; }")
	),
	wellPanel(
		checkboxInput("showDataPanel1",h5("Data Selection Panel"),TRUE),
		conditionalPanel(condition="input.showDataPanel1",
			div(class="row-fluid",
				div(class="span6", uiOutput("dat.name")),
				div(class="span6", includeHTML("www/js/locationSelect.js"),
								   selectInput(inputId = "locationSelect", label = "Select a community:", choices = communities, selected = NULL)
				)
			),
			div(class="row-fluid", div(class="span6", uiOutput("vars")), div(class="span6", uiOutput("units"))),
			div(class="row-fluid", div(class="span6", uiOutput("models")), div(class="span6", uiOutput("scens"))),
			div(class="row-fluid", div(class="span6", uiOutput("mos")), div(class="span6", uiOutput("decs"))),
			tags$style(type="text/css", '#vars {width: 150px}'),
			tags$style(type="text/css", '#units {width: 150px}'),
			tags$style(type="text/css", '#models {width: 150px}'),
			tags$style(type="text/css", '#scens {width: 150px}'),
			tags$style(type="text/css", '#mos {width: 150px}'),
			tags$style(type="text/css", '#decs {width: 150px}'),
			actionButton("goButton", "Subset Data / New Plot")
		)
	),
	wellPanel(
		checkboxInput("showDisplayPanel1",h5("Plot Options Panel"),TRUE),
		conditionalPanel(condition="input.showDisplayPanel1",
			div(class="row-fluid", div(class="span4", uiOutput("xtime")), div(class="span4", uiOutput("group")), div(class="span4", uiOutput("facet"))),
			div(class="row-fluid", div(class="span4", uiOutput("jitterXY")), div(class="span4", uiOutput("altplot")), div(class="span4", uiOutput("vert.facet"))),
			div(class="row-fluid", div(class="span6", h5(uiOutput("summarizeByXtitle"))), div(class="span6", p(uiOutput("pooled.var")))),
			div(class="row-fluid", div(class="span4", uiOutput("yrange")), div(class="span4", uiOutput("clbootbar")), div(class="span4", uiOutput("clbootsmooth"))),
			tags$style(type="text/css", '#xtime {width: 110px}'),
			tags$style(type="text/css", '#group {width: 110px}'),
			tags$style(type="text/css", '#facet {width: 110px}'),
			p(style="text-align:justify",em("Additional specific display options are available below the plot.")),
			actionButton("updateButton", "Update / Reformat Plot")
		)
	),
	h5(textOutput("pageviews"))
)
