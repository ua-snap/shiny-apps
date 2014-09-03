load("external/data.RData",envir=.GlobalEnv)
load("external/data_CRU31.RData", envir=.GlobalEnv)
############################## TESTING
#load("external/data_cities.RData", envir=.GlobalEnv)
load("external/data_cities_CRU31.RData", envir=.GlobalEnv)
city.gcm.files.path <- "/workspace/Shared/Users/mfleonawicz/AR4_AR5_Comparisons/city_files_GCM"
city.gcm.files <- list.files(city.gcm.files.path, full=T)
city.names <- gsub("--", ", ", basename(substr(city.gcm.files, 1, nchar(city.gcm.files) - 6)))
