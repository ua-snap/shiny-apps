library(shiny)
pkgs <- c("assertive")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(assertive)
defaults_file <- "external/appSourceFiles/alfresco_fif_defaults.txt"
source(defaults_file, local=T)
fif_files <- list.files(pattern=".fif$")

user <- ""
server <- "atlas.snap.uaf.edu"
mainDir <- "/big_scratch/shiny"
exec <- "sbatch"
slurmfile <- "RunAlfresco.slurm"
