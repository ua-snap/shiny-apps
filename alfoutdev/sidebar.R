# @knitr sidebar
column(4,
	conditionalPanel(condition="input.tsp!=='about'",
        selectInput("workspace", "Alfresco run", choices=wsfiles, selected=wsfiles[1])
	),
	conditionalPanel(condition="input.tsp!=='fri_boxplot' && input.tsp!=='about' && input.tsp!=='tab_ts' && input.tsp!=='ctab_ts'",
		wellPanel(
			h5("Define subjects, groups, and panels"),
			fluidRow(
				column(4, uiOutput("Group_choices")),
				column(4, uiOutput("FacetBy_choices")),
				column(4, selectInput("facetcols", "Columns", choices=1:4, selected=1))
			),
            checkboxInput("facetScalesFree", "Free y-axes")
		)
	),
    conditionalPanel(condition="input.tsp=='tab_ts' || input.tsp=='ctab_ts'",
		wellPanel(
			h5("Define subjects, groups, and panels"),
			fluidRow(
				column(4, uiOutput("Reg_group_choices")),
				column(4, uiOutput("Reg_facetBy_choices")),
				column(4, selectInput("reg_facetcols", "Columns", choices=1:4, selected=1))
			),
            checkboxInput("reg_facetScalesFree", "Free y-axes")
		)
	),
	conditionalPanel(condition="input.tsp==='rab_ts' || input.tsp==='crab_ts' || input.tsp==='tab_ts' || input.tsp==='ctab_ts'",
		wellPanel(
			fluidRow(
				column(9, h5("Time series options")),
				column(3,
					conditionalPanel(condition="input.tsp==='rab_ts'",
						downloadButton("dl_RAB_tsplotPDF","Get Plot")
					),
					conditionalPanel(condition="input.tsp==='crab_ts'",
						downloadButton("dl_CRAB_tsplotPDF","Get Plot")
					),
                    conditionalPanel(condition="input.tsp==='tab_ts'",
						downloadButton("dl_RegTAB_tsplotPDF","Get Plot")
					),
					conditionalPanel(condition="input.tsp==='ctab_ts'",
						downloadButton("dl_RegCTAB_tsplotPDF","Get Plot")
					)
				)
			),
			fluidRow(
				conditionalPanel(condition="input.tsp==='rab_ts' || input.tsp==='crab_ts'",
                    column(6, selectInput("buffersize", "Buffer radius (km)", choices=buffersize, selected=buffersize[6]))),
                conditionalPanel(condition="input.tsp==='tab_ts' || input.tsp==='ctab_ts'",
                    column(12, selectInput("reg_vegetation", "Select vegetation", choices=vegclasses, selected=vegclasses, multiple=TRUE),
                        checkboxInput("reg_aggveg", "Combine vegetation", FALSE)))
			),
			fluidRow(
				conditionalPanel(condition="input.tsp==='rab_ts' || input.tsp==='tab_ts'", sliderInput("yearsrab", "Years", mod.years.range[1], mod.years.range[2], c(max(mod.years.range[1], 1901), mod.years.range[2]), step=1, sep="")),
				conditionalPanel(condition="input.tsp==='crab_ts' || input.tsp==='ctab_ts'", sliderInput("yearscrab", "Years", obs.years.range[1], obs.years.range[2], obs.years.range, step=1, sep=""))
			)
		)
	),
	conditionalPanel(condition="input.tsp==='frp_buffer'",
		wellPanel(
			fluidRow(
				column(9, h5("FRP options")),
				column(3, downloadButton("dl_FRP_bufferplotPDF","Get Plot"))
			),
			fluidRow(
				column(6, selectInput("minbuffersize", "Min. buffer radius (km)", choices=buffersize[-length(buffersize)], selected=buffersize[6]))#,
				
			)
		)
	),
	conditionalPanel(condition="input.tsp==='fri_boxplot'",
		wellPanel(
			fluidRow(
				column(9, h5("Boxplot options")),
				column(3, downloadButton("dl_FRI_boxplotPDF","Get Plot"))
			),
			fluidRow(
				column(6, uiOutput("Boxplot_X_choices")),
				column(6, uiOutput("Boxplot_group_choices"))
			),
			fluidRow(
				column(6, uiOutput("Boxplot_facetBy_choices")),
				column(6, selectInput("boxplot_facetcols", "Columns", choices=1:4, selected=1))
			),
			fluidRow(
                column(4, checkboxInput("boxplot_facetScalesFree", "Free y-axes")),
				column(4, checkboxInput("boxplot_log", "Log scale", FALSE)),
                column(4, checkboxInput("boxplot_points", "Show points", FALSE))
			),
            fluidRow(
				column(4, selectInput("points_alpha", "Alpha level", choices=seq(0.1, 1, by=0.1), selected="0.1")),
				column(8, uiOutput("Boxplot_Locgroup_choices"))
			)
		)
	)
)
