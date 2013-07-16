library(shinyIncubator)

tabPanelAbout <- source("external/about.R",local=T)$value

headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}

sidebarPanel_2 <- function(span,...) {
  div(class=span,
    tags$form(class="well",
      ...
    )
  )
}

mainPanel_2 <- function(span,...) {
  div(class=span,
    ...
  )
}
