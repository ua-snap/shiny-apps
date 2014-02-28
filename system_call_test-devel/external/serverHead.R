library(shiny)
#pkgs <- c("randomForest","ggplot2","plyr","reshape2","gridExtra","gtable")
#pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
#if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
#library(randomForest); library(ggplot2); library(plyr); library(reshape2); library(gridExtra); library(gtable); library(parallel) # parallel experimental
datasets <- c("iris","cars")
defaults_file <- "external/appSourceFiles/alfresco_fif_defaults.txt"
source(defaults_file, local=T)
fif_files <- list.files(pattern=".fif$")

user <- "sudo -u shiny"
server <- "atlas.snap.uaf.edu"
mainDir <- "~shiny/mfleonawicz"
exec <- "sbatch"
slurmfile <- "RunAlfresco_Noatak.slurm"
