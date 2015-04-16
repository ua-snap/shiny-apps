library(shinythemes)
library(shinyIncubator)
library(markdown)
print(paste("metadata .RData file load time:"))
print(system.time( load("meta.RData",envir=.GlobalEnv) ))

#### If overriding these region and city file path objects from files_meta.RData ####
print(paste("Local file path swap (devel testing only):"))
print(system.time({
if(Sys.info()["sysname"]=="Windows"){ # for local devl/testing
	topDir <- "C:/leonawicz/AR4_AR5_Comparisons"
	region.gcm.stats.path <- list.files(file.path(topDir, "region_files_GCM/stats"), full=T)
	region.gcm.stats.files <- lapply(region.gcm.stats.path, list.files, full=T)
	region.cru.stats.path <- list.files(file.path(topDir, "region_files_CRU/stats"), full=T)
	region.cru.stats.files <- lapply(region.cru.stats.path, list.files, full=T)
	
	region.gcm.samples.path <- list.files(file.path(topDir, "region_files_GCM/samples"), full=T)
	region.gcm.samples.files <- lapply(region.gcm.samples.path, list.files, full=T)
	region.cru.samples.path <- list.files(file.path(topDir, "region_files_CRU/samples"), full=T)
	region.cru.samples.files <- lapply(region.cru.samples.path, list.files, full=T)
	names(region.cru.stats.files) <- names(region.gcm.stats.files) <- names(region.cru.samples.files) <- names(region.gcm.samples.files) <- basename(region.gcm.stats.path)
	
	city.cru.files.path <- file.path(topDir, "city_files_CRU32")
	city.cru.files <- list.files(city.cru.files.path, full=T)
	city.gcm.files.path <- file.path(topDir, "city_files_GCM")
	city.gcm.files <- gsub("city_files_CRU32", "city_files_GCM", city.cru.files)
}
}))
###############################################################

region.names <- c(names(region.names.out), "Cities") # Hardcode for sidebar input

help_tabpanel_conditional <- conditionalPanel(
	condition=
	"(input.tsp == 'plot_heatmap' || input.tsp == 'plot_ts' || input.tsp == 'plot_scatter' || input.tsp == 'plot_variability' || input.tsp == 'plot_spatial') && (input.goButton == null || input.goButton == 0)",
	includeMarkdown("www/intro.md")
)
