# Inputs for mainPanel tabsetPanel tabPanel with tabPanel id "pd"
output$responseclass <- renderUI({ if(!is.null(rf1()) & !is.null(responseclasses())) selectInput("responseclass","Response class",responseclasses(),selected=responseclasses()[1]) })

output$predictor <- renderUI({ if(!is.null(rf1()) & !is.null(input$explanatory)) selectInput("predictor","Explanatory variable",input$explanatory,selected=input$explanatory[1]) })

# Inputs for mainPanel tabsetPanel tabPanel with tabPanel id "outliers"
output$n.outliers <- renderUI({ if(!is.null(rf1())) sliderInput("n.outliers","N largest outliers",1,10,5,1) })

# Inputs for mainPanel tabsetPanel tabPanel with tabPanel id "numVar"
output$n.reps <- renderUI({ if(!is.null(rf1())) sliderInput("n.reps","Number of CV replicates",1,10,5,1) })

output$cvRepsButton <- renderUI({ if(!is.null(rf1())) actionButton("cvRepsButton", "RUN CV [SLOW!]", class="btn-block btn-danger") })

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
