sidebarPanel_2(
	span="span3",
	tags$head(
		tags$link(rel="stylesheet", type="text/css", href="styles_black_orange.css"),
		tags$link(rel="stylesheet", type="text/css", href="jquery.slider.min.css"),
		tags$style(type="text/css", "select { max-width: 180px; }"),
		tags$style(type="text/css", "textarea { max-width: 300px; }"),
		tags$style(type="text/css", ".jslider { max-width: 400px; }"),
		tags$style(type='text/css', ".well { max-width: 400px; }")
	),
	wellPanel(
		checkboxInput("showWP1",h5("Data selection"),FALSE),
		conditionalPanel(condition="input.showWP1",
			div(class="row-fluid",
				div(class="span11",uiOutput("loc")),
				div(class="span1",helpPopup('Choose location','Currently only Fairbanks, AK is available.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("yrs")),
				div(class="span1",helpPopup('Choose consecutive years','This is an initial subsetting of the data. Years refer to calendar years.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("mo")),
				div(class="span1",helpPopup('Choose 1st month of precipitation year','The annual precipitation cycle is defined as the 1st day of the selected month.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("ph1")),
				div(class="span1",helpPopup('Placeholder 1','This option currently has no functionality.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("var")),
				div(class="span1",helpPopup('Choose a variable','Currently, only precipitation is available.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("dailyColPal")),
				div(class="span1",helpPopup('Choose a color palette','Currently two options. I would like to add the ability for people to design their own.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("ph2")),
				div(class="span1",helpPopup('Placeholder 2','This option currently has no functionality.'))
			),
			div(class="row-fluid",
				div(class="span11",uiOutput("ph3")),
				div(class="span1",helpPopup('Placeholder 3','This option currently has no functionality.'))
			)
		)
	)
)
