# @knitr global
library(RJSONIO)
library(shinyBS)
library(apputils)
defaults_file <- "alfresco_json_defaults.txt"
source(defaults_file, local=TRUE)
all_json_files <- list.files(pattern=".JSON$")
names(all_json_files) <- gsub("\\.JSON", "", all_json_files)
default_prev_run_name <- "fmo00s00i_historical_CRU32"