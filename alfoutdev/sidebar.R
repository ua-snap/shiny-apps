# @knitr sidebar
column(4,
	conditionalPanel(condition="input.tsp!=='about'",
        selectInput("workspace", "Alfresco run:", choices=wsfiles, selected=wsfiles[1], width="100%")
	),
	conditionalPanel(condition="input.tsp!=='fri_boxplot' && input.tsp!=='about' && input.tsp!=='tab_ts' && input.tsp!=='ctab_ts'",
		wellPanel(
			h5("Define subjects, groups, and panels"),
			fluidRow(
				#column(6, selectInput("interact", "Subject (factor interaction):", choices=c("Replicate", "Location"), selected=c("Replicate", "Location"), multiple=T)),
				column(4, selectInput("grp", "Group by:", choices=c("", "Location"), selected="", width="100%")),
			#),
			#fluidRow(
				column(4, selectInput("facetby", "Facet by:", choices=c("", "Location"), selected="", width="100%")),
				column(4, selectInput("facetcols", "Facet cols:", choices=1:4, selected=1, width="100%"))
			)
		)
	),
    conditionalPanel(condition="input.tsp=='tab_ts' || input.tsp=='ctab_ts'",
		wellPanel(
			h5("Define subjects, groups, and panels"),
			fluidRow(
				#column(6, selectInput("reg_interact", "Subject (factor interaction):", choices=c("Replicate", "Vegetation"), selected=c("Replicate", "Vegetation"), multiple=T)),
				column(4, selectInput("reg_grp", "Group by:", choices=c("", "Vegetation"), selected="")),
			#),
			#fluidRow(
				column(4, selectInput("reg_facetby", "Facet by:", choices=c("", "Vegetation"), selected="")),
				column(4, selectInput("reg_facetcols", "Facet cols:", choices=1:4, selected=1))
			)
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
                    column(6, selectInput("buffersize", "Buffer radius (km):", choices=buffersize, selected=buffersize[6], width="100%"))),
                conditionalPanel(condition="input.tsp==='tab_ts' || input.tsp==='ctab_ts'",
                    column(12, selectInput("reg_vegetation", "Select vegetation:", choices=vegclasses, selected=vegclasses, multiple=TRUE),
                        checkboxInput("reg_aggveg", "Combine vegetation", FALSE)),
                        HTML('<p style="text-align:justify">Integrating across vegetation classes removes Vegetation from the data frame.
                            Therefore, Vegetation cannot remain as a selected option above for Grouping or Faceting.</p>
                            <p style="text-align:justify">Under certain restrictive conditions such as limited years and spatial extent, some vegetation classes may cause problems for plotting and must be deselected.</p>'))
			),
			fluidRow(
				conditionalPanel(condition="input.tsp==='rab_ts' || input.tsp==='tab_ts'", sliderInput("yearsrab", "Years", mod.years.range[1], mod.years.range[2], c(max(mod.years.range[1], 1901), mod.years.range[2]), step=1, sep="", width="100%")),
				conditionalPanel(condition="input.tsp==='crab_ts' || input.tsp==='ctab_ts'", sliderInput("yearscrab", "Years", obs.years.range[1], obs.years.range[2], obs.years.range, step=1, sep="", width="100%"))
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
				column(6, selectInput("minbuffersize", "Min. buffer radius (km):", choices=buffersize[-length(buffersize)], selected=buffersize[6], width="100%"))#,
				
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
				column(6, selectInput("boxplot_X", "X-axis:", choices=c("Source", "Replicate", "Buffer_km", "Location"), selected="Source", width="100%")),
				column(6, selectInput("boxplot_grp", "Group by:", choices=c("", "Source", "Buffer_km", "Location"), selected="", width="100%"))
			),
			fluidRow(
				column(6, selectInput("boxplot_facetby", "Facet by:", choices=c("", "Source", "Buffer_km", "Location"), selected="", width="100%")),
				column(6, selectInput("boxplot_facetcols", "Columns if faceting:", choices=1:4, selected=1, width="100%"))
			),
			fluidRow(
				column(6, selectInput("points_alpha", "Point transparency:", choices=seq(0.1, 1, by=0.1), selected="0.1", width="100%")),
				column(6, checkboxInput("boxplot_points", "Show points", FALSE))
			),
			fluidRow(
				column(6, checkboxInput("boxplot_log", "Log scale", FALSE))#,
			)#,
			#fluidRow(
			#	sliderInput("yearsfri", "Years", mod.years.range[1], mod.years.range[2], c(max(mod.years.range[1], 1901), mod.years.range[2]), step=1, format="#", width="100%")
			#)
		)
	)
)
