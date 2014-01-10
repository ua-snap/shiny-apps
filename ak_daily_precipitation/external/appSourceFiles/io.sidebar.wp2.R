# Color/size rescaling, etc.
output$TfColCir <- renderUI({
	selectInput("tfColCir","Circle size and color gradient:",choices=0:3,selected=0)
})

output$TfCirCexMult <- renderUI({
	selectInput("tfCirCexMult","Circle size cex multiplier:",choices=1:20,selected=10)
})

output$TfColMar <- renderUI({
	selectInput("tfColMar","Historical mean color gradient:",choices=0:10,selected=0)
})

output$TfColBar <- renderUI({
	selectInput("tfColBar","Barplot color gradient:",choices=0:5,selected=0)
})

output$HtCompress <- renderUI({
	selectInput("htCompress","Vertical plot compression factor",choices=seq(0.5,2,by=0.25),selected=1.5)
})
