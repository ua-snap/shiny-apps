library(shinythemes)
library(Hmisc)
library(png)

load("external/wind_ice.RData",envir=.GlobalEnv)
sea.images <- lapply(list.files("www/img", pattern="^sea_.*.png$", full=TRUE), readPNG)

f <- function(z, x, y, size){
  d <- dim(z)[1:2]
  a <- d[1]/d[2]
  par(mai=c(0,0,0,0), usr=c(0,1,0,1))
  plot(0, 0, xlim=c(-0.92, 0.92), ylim=c(-0.65, 0.65), type="n", axes=F, xlab="", ylab="")
  rasterImage(z, x - (size), y - (a*size), x + (size), y + (a*size), interpolate=TRUE)
}

cuts <- rev(unique(w.beaufort.GFDL$Cut))
varlevels <- as.character(unique(w.beaufort.GFDL$Var))
years <- unique(w.beaufort.GFDL$Year)
decades <- years[years%%10==0]
dec.lab <- paste0(decades,"s")
seas <- capitalize(unique(sapply(strsplit(ls(pattern="^w.*.c$",envir=.GlobalEnv),"\\."),"[[",2)))
models <- unique(sapply(strsplit(ls(pattern="^w.*.c$",envir=.GlobalEnv),"\\."),"[[",3))
dpm <- c(31,28,31,30,31,30,31,31,30,31,30,31)
