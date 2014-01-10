# Inputs for mainPanel tabsetPanel tabPanel with tabPanel id "pd"
output$responseclass <- renderUI({ if(!is.null(rf1()) & !is.null(responseclasses())) selectInput("responseclass","Response class",responseclasses(),selected=responseclasses()[1]) })

output$predictor <- renderUI({ if(!is.null(rf1()) & !is.null(input$explanatory)) selectInput("predictor","Explanatory variable",input$explanatory,selected=input$explanatory[1]) })

# Inputs for mainPanel tabsetPanel tabPanel with tabPanel id "outliers"
output$n.outliers <- renderUI({ if(!is.null(rf1())) sliderInput("n.outliers","N largest outliers",1,10,5,1) })

# Inputs for mainPanel tabsetPanel tabPanel with tabPanel id "numVar"
output$n.reps <- renderUI({ if(!is.null(rf1())) sliderInput("n.reps","Number of CV replicates",1,10,5,1) })

output$cvRepsButton <- renderUI({ if(!is.null(rf1())) actionButton("cvRepsButton", "Run 5-fold nested CV\nwith replication") })

# TabPanel titles
output$tp.classError <- renderUI({ if(!is.null(rf1())) h4("Mean class error and confusion matrix") })
output$tp.impAcc <- renderUI({ if(!is.null(rf1())) h4("Variable importance: Mean decrease in OOB prediction error") })
output$tp.impGini <- renderUI({ if(!is.null(rf1())) h4("Variable importance: Mean decrease in node impurity (Gini index)") })
output$tp.impTable <- renderUI({ if(!is.null(rf1())) h4("Variable importance: Predictor-response class importance matrix") })
output$tp.mds <- renderUI({ if(!is.null(rf1())) h4("2-D multi-dimensional scaling plot") })
output$tp.margins <- renderUI({ if(!is.null(rf1())) h4("Classification margins by response class (majority vote)") })
output$tp.pd <- renderUI({ if(!is.null(rf1())) h4("Partial dependence (marginal effect) of a given explanatory variable on a given response class") })
output$tp.outliers <- renderUI({ if(!is.null(rf1())) h4("Outlier measure for all countries") })
output$tp.errorRate <- renderUI({ if(!is.null(rf1())) h4("Response class and OOB error rates") })
output$tp.varsUsed <- renderUI({ if(!is.null(rf1())) h4("Total splits at nodes across all tress") })
output$tp.numVar <- renderUI({ if(!is.null(rf1())) h4("Error reduction performance from nested 5-fold CV on sequentially reduced predictor sets takes approximately one minute per replicate") })

output$mpContent <- renderUI({ mpContent() })

mpContent <- reactive({
	x <- NULL
	if(!is.null(input$nlp)){
		id <- input$nlp
		if(id=="classError"){
		x <- tabPanel("Class Error", 
				div(class="row-fluid",
					div(class="span10", uiOutput("tp.classError")),
					div(class="span2", downloadButton("dl_classErrorPlot","Download graphic"))
				),
				plotOutput("classErrorPlot",height="auto"), value="classError")
		} else if(id=="impAcc") {
		x <- tabPanel("Importance: OOB",
				div(class="row-fluid",
					div(class="span10", uiOutput("tp.impAcc")),
					div(class="span2", downloadButton("dl_impAccPlot","Download graphic"))
				),
				plotOutput("impAccPlot",height="auto"), value="impAcc")
		} else if(id=="impGini") {
		x <- tabPanel("Importance: Gini",
				div(class="row-fluid",
					div(class="span10", uiOutput("tp.impGini")),
					div(class="span2", downloadButton("dl_impGiniPlot","Download graphic"))
				),
				plotOutput("impGiniPlot",height="auto"), value="impGini")
		} else if(id=="impTable") {
		x <- tabPanel("Importance: Table",
				div(class="row-fluid",
					div(class="span10", uiOutput("tp.impTable")),
					div(class="span2", downloadButton("dl_impTablePlot","Download graphic"))
				),
				plotOutput("impTablePlot",height="auto"), value="impTable")
		} else if(id=="mds") {
		x <- tabPanel("2-D MDS",
				div(class="row-fluid",
					div(class="span10", uiOutput("tp.mds")),
					div(class="span2", downloadButton("dl_mdsPlot","Download graphic"))
				),
				plotOutput("mdsPlot",height="auto"), value="mds")
		} else if(id=="margins") {
		x <- tabPanel("Class Margins",
				div(class="row-fluid",
					div(class="span10", uiOutput("tp.margins")),
					div(class="span2", downloadButton("dl_marginPlot","Download graphic"))
				),
				plotOutput("marginPlot",height="auto"), value="margins")
		} else if(id=="pd") {
		x <- tabPanel("Partial Dependence",
				div(class="row-fluid",
					div(class="span6", uiOutput("tp.pd")),
					div(class="span2", uiOutput("responseclass")),
					div(class="span2", uiOutput("predictor")),
					div(class="span2", downloadButton("dl_pdPlot","Download graphic"))
				),
				plotOutput("pdPlot",height="auto"), value="pd")
		} else if(id=="outliers") {
		x <- tabPanel("Outliers",
				div(class="row-fluid",
					div(class="span8", uiOutput("tp.outliers")),
					div(class="span2", uiOutput("n.outliers")),
					div(class="span2", downloadButton("dl_outlierPlot","Download graphic"))
				),
				plotOutput("outlierPlot",height="auto"), value="outliers")
		} else if(id=="errorRate") {
		x <- tabPanel("Error Rate",
				div(class="row-fluid",
					div(class="span10", uiOutput("tp.errorRate")),
					div(class="span2", downloadButton("dl_errorRatePlot","Download graphic"))
				),
				plotOutput("errorRatePlot",height="auto"), value="errorRate")
		} else if(id=="varsUsed") {
		x <- tabPanel("Variable Use",
				div(class="row-fluid",
					div(class="span10", uiOutput("tp.varsUsed")),
					div(class="span2", downloadButton("dl_varsUsedPlot","Download graphic"))
				),
				plotOutput("varsUsedPlot",height="auto"), value="varsUsed")
		} else if(id=="numVar") {
		x <- tabPanel("# of Variables",
				div(class="row-fluid",
					div(class="span6", uiOutput("tp.numVar")),
					div(class="span2", uiOutput("n.reps")),
					div(class="span2", uiOutput("cvRepsButton")),
					div(class="span2", downloadButton("dl_numVarPlot","Download graphic"))
				),
				plotOutput("numVarPlot",height="auto"), value="numVar")
		} else if(id=="about")  x <- tabPanelAbout()
	}
	print(input$nlp)
	x
})
