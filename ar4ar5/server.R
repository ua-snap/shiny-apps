source("external/serverHead.R", local = TRUE)
shinyServer(function(input, output, session) source("external/app.R", local = TRUE))
