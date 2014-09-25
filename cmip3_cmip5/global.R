library(shinyIncubator)
library(shinysky)
library(markdown)
load("external/gcm_meta.RData",envir=.GlobalEnv)
load("external/files_meta.RData",envir=.GlobalEnv)
load("external/data_CRU31.RData", envir=.GlobalEnv)
load("external/data_cities_CRU31.RData", envir=.GlobalEnv)

#### If overriding these four objects from files_meta.RData ####
if(Sys.info()["sysname"]=="Windows"){ # for local devl/testing
	region.gcm.files.path <- "Y:/Users/mfleonawicz/AR4_AR5_Comparisons/region_files_GCM"
	region.gcm.files <- list.files(region.gcm.files.path, full=T)
	city.gcm.files.path <- "Y:/Users/mfleonawicz/AR4_AR5_Comparisons/city_files_GCM"
	city.gcm.files <- list.files(city.gcm.files.path, full=T)
}
###############################################################

help_tabpanel_conditional <- conditionalPanel(
	condition=
	#"input.vars == null || (input.doms == null && input.cities == '') ||
	#( (input.cmip3scens == null || input.cmip3models == null) && (input.cmip5scens == null || input.cmip5models == null) )",
	"input.tsp !== 'about' && input.tsp !== 'home' && (input.goButton == null || input.goButton == 0)",
	includeMarkdown("intro.md")
)
