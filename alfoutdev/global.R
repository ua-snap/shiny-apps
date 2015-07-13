library(shinythemes)
wsfiles <- list.files(pattern=".*.AB_FRP.*.RData$", full=T)
load(wsfiles[1], envir=.GlobalEnv)
vegclasses <- c("Alpine", "Forest", "Shrub", "Graminoid", "Wetland")
