load("external/gcm_meta.RData",envir=.GlobalEnv)
load("external/data_CRU31.RData", envir=.GlobalEnv)
load("external/data_cities_CRU31.RData", envir=.GlobalEnv)

region.gcm.files.path <- "/workspace/Shared/Users/mfleonawicz/AR4_AR5_Comparisons/region_files_GCM"
region.gcm.files <- list.files(region.gcm.files.path, full=T)
region.names <- gsub("--", ", ", basename(substr(region.gcm.files, 1, nchar(region.gcm.files) - 6)))

city.gcm.files.path <- "/workspace/Shared/Users/mfleonawicz/AR4_AR5_Comparisons/city_files_GCM"
city.gcm.files <- list.files(city.gcm.files.path, full=T)
city.names <- gsub("--", ", ", basename(substr(city.gcm.files, 1, nchar(city.gcm.files) - 6)))
