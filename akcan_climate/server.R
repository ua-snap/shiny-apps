source("external/serverHead.R", local = TRUE)
shinyServer(function(input, output) source("external/app.R", local = TRUE))
