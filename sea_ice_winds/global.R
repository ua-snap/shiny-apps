library(shiny)
load("wind_ice.RData")

cuts <- rev(unique(w.beaufort.GFDL$Cut))
varlevels <- as.character(unique(w.beaufort.GFDL$Var))
years <- unique(w.beaufort.GFDL$Year)
decades <- years[years %% 10 == 0]
dec.lab <- paste0(decades, "s")
seas <- c("Beaufort", "Bering", "Chukchi")
models <- unique(sapply(strsplit(ls(pattern = "^w.*.c$"), "\\."), "[[", 3))
dpm <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
