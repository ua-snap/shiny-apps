# @knitr global
library(shinythemes)
library(markdown)
library(DT)
load("meta.RData",envir=.GlobalEnv)

#### If overriding these region and city file path objects from files_meta.RData ####
if(Sys.info()["sysname"]=="Windows"){ # for local devl/testing
	print(paste("Local file path swap (devel testing only)"))
	topDir <- "C:/leonawicz/qaqcAppData"
	region.gcm.stats.path <- list.files(file.path(topDir, "region_files_GCM/stats"), full=T)
	region.gcm.stats.files <- lapply(region.gcm.stats.path, list.files, full=T)
	region.cru.stats.path <- list.files(file.path(topDir, "region_files_CRU32/stats"), full=T)
	region.cru.stats.files <- lapply(region.cru.stats.path, list.files, full=T)
	
	region.gcm.samples.path <- list.files(file.path(topDir, "region_files_GCM/samples"), full=T)
	region.gcm.samples.files <- lapply(region.gcm.samples.path, list.files, full=T)
	region.cru.samples.path <- list.files(file.path(topDir, "region_files_CRU32/samples"), full=T)
	region.cru.samples.files <- lapply(region.cru.samples.path, list.files, full=T)
	names(region.cru.stats.files) <- names(region.gcm.stats.files) <- names(region.cru.samples.files) <- names(region.gcm.samples.files) <- basename(region.gcm.stats.path)
	
	city.gcm.files.path <- file.path(topDir, "city_files_GCM")
	city.gcm.files.2km <- list.files(file.path(city.gcm.files.path, "akcan2km"), full=T)
	city.gcm.files.10min <- list.files(file.path(city.gcm.files.path, "world10min"), full=T)
	city.cru.files.path <- file.path(topDir, "city_files_CRU32")
	city.cru.files.2km <- list.files(file.path(city.cru.files.path, "akcan2km"), full=T)
	city.cru.files.10min <- list.files(file.path(city.cru.files.path, "world10min"), full=T)
    city.gcm.files <- city.gcm.files.10min # using only 10-minute resolution files
    city.cru.files <- city.cru.files.10min # using only 10-minute resolution files
}
###############################################################

region.names <- c(names(region.names.out), "Cities") # Hardcode for sidebar input

help_tabpanel_conditional <- conditionalPanel(
	condition=
	"(input.tsp == 'plot_heatmap' || input.tsp == 'plot_ts' || input.tsp == 'plot_scatter' || input.tsp == 'plot_variability' || input.tsp == 'plot_spatial') && (input.goButton == null || input.goButton == 0)",
	includeMarkdown("www/intro.md")
)
