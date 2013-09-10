# Color/size rescaling, etc.
output$tfColCir <- renderUI({
	selectInput("tfColCir","Circle size and color gradient:",choices=0:3,selected=0)
})

output$tfCirCexMult <- renderUI({
	selectInput("tfCirCexMult","Circle size cex multiplier:",choices=1:20,selected=10)
})

output$tfColMar <- renderUI({
	selectInput("tfColMar","Historical mean color gradient:",choices=0:10,selected=0)
})

output$tfColBar <- renderUI({
	selectInput("tfColBar","Barplot color gradient:",choices=0:5,selected=0)
})

output$htCompress <- renderUI({
	selectInput("htCompress","Vertical plot compression factor",choices=seq(0.5,2,by=0.25),selected=1.5)
})

#output$tfColCir <- renderUI({
#	sliderInput("tfColCir","Circle size and color gradient:",0,3,0)
#})

#output$tfCirCexMult <- renderUI({
#	sliderInput("tfCirCexMult","Circle size cex multiplier:",1,20,10)
#})

#output$tfColMar <- renderUI({
#	sliderInput("tfColMar","Historical mean color gradient:",0,10,0)
#})

#output$tfColBar <- renderUI({
#	sliderInput("tfColBar","Barplot color gradient:",0,5,0)
#})

#output$htCompress <- renderUI({
#	sliderInput("htCompress","Vertical plot compression factor",min=0.5,max=2,value=1.5,step=0.25)
#})
