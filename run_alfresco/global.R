# @knitr global
library(shinyBS)
defaults_file <- "alfresco_json_defaults.txt"
source(defaults_file, local=TRUE)
all_json_files <- list.files(pattern=".JSON$")
names(all_json_files) <- gsub("\\.JSON", "", all_json_files)
