library(shinyIncubator)
library(shinysky)
library(markdown)
load("external/gcm_meta.RData",envir=.GlobalEnv)
load("external/files_meta.RData",envir=.GlobalEnv)
load("external/data_CRU31.RData", envir=.GlobalEnv)
load("external/data_cities_CRU31.RData", envir=.GlobalEnv)

#### If overriding these four objects from files_meta.RData ####
if(Sys.info()["sysname"]=="Windows"){ # for local devl/testing
	load("X:/Leonawicz/Projects/2014/AR4_AR5_comparisons/data/final/gcm_meta.RData",envir=.GlobalEnv)
	#region.gcm.stats.path <- "Y:/Users/mfleonawicz/AR4_AR5_Comparisons/region_files_GCM"
	region.gcm.stats.path <- list.files("X:/Leonawicz/Projects/2014/AR4_AR5_comparisons/data/final/region_files_GCM/stats", full=T)
	region.gcm.stats.files <- lapply(region.gcm.stats.path, list.files, full=T)
	region.cru.stats.path <- list.files("X:/Leonawicz/Projects/2014/AR4_AR5_comparisons/data/final/region_files_CRU/stats", full=T)
	region.cru.stats.files <- lapply(region.cru.stats.path, list.files, full=T)
	
	region.gcm.samples.path <- list.files("X:/Leonawicz/Projects/2014/AR4_AR5_comparisons/data/final/region_files_GCM/samples", full=T)
	# Hardcode for sidebar input
	region.names <- c(names(region.names.out), "Cities")
	region.gcm.samples.files <- lapply(region.gcm.samples.path, list.files, full=T)
	region.cru.samples.path <- list.files("X:/Leonawicz/Projects/2014/AR4_AR5_comparisons/data/final/region_files_CRU/samples", full=T)
	region.cru.samples.files <- lapply(region.cru.samples.path, list.files, full=T)
	names(region.cru.stats.files) <- names(region.gcm.stats.files) <- names(region.cru.samples.files) <- names(region.gcm.samples.files) <- basename(region.gcm.stats.path)
	
	city.gcm.files.path <- "Y:/Users/mfleonawicz/AR4_AR5_Comparisons/city_files_GCM"
	city.gcm.files <- list.files(city.gcm.files.path, full=T)
}
###############################################################

help_tabpanel_conditional <- conditionalPanel(
	condition=
	"(input.tsp == 'plot_heatmap' || input.tsp == 'plot_ts' || input.tsp == 'plot_scatter' || input.tsp == 'plot_variability' || input.tsp == 'plot_spatial') && (input.goButton == null || input.goButton == 0)",
	includeMarkdown("www/intro.md")
)
