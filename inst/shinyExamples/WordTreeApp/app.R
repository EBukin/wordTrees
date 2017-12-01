
# This is a shiny word tree app

library(shiny)
library(collapsibleTree)
library(tidyverse)
library(stringr)
library(googlesheets)

source("helpers/read_lit_gs.R")
source("helpers/split_tag_groups.R")
source("helpers/split_tag_nodes.R")
source("helpers/prepare_network_tree_data.R")

biuldBigTree <- function(value, rootName = "Methods", tag1 = "methTags", tag2 = "meth") {
  treeRoot <-
    value %>%
    prepare_network_tree_data(rootVar = rootName, tag1, tag2) %>%
    select(-node_00)
  treeNames <-
    names(treeRoot)[str_detect(names(treeRoot), "node")] %>%
    sort()
  collapsibleTreeSummary(
    treeRoot,
    treeNames,
    root = rootName,
    tooltip = TRUE,
    nodeSize = "count",
    collapsed = FALSE
  )
}

# Define UI for application that draws a collapsible tree
ui <- fluidPage(# Application title
  titlePanel("Mind maps from literature Reviews"),
  
  mainPanel(
    tabsetPanel(
      tabPanel(
        "Methodology",
        actionButton("click", "Reload literature data", icon("refresh")),
        collapsibleTreeOutput("methodology", height = "800px", width = "1200px")
        ),
      tabPanel(
        "Question",
        actionButton("click1", "Reload literature data", icon("refresh")),
        collapsibleTreeOutput("question", height = "800px", width = "1200px"))
      ,
      tabPanel(
        "Data",
        actionButton("click2", "Reload literature data", icon("refresh")),
        collapsibleTreeOutput("dataTree", height = "800px", width = "1200px")
        )
      )
    )
  )

# Define server logic required to draw a collapsible tree diagram
server <- function(input, output) {
  values <- reactiveValues()
  values$methodsPlot <-
    eventReactive(input$click,
                  {
                    withProgress(message = '(Re-) Generating tree', value = 0.1, {
                      incProgress(0.1, detail = paste(" Loading data from Google"))
                      value <- read_lit_gs()
                      incProgress(0.2, detail = paste(" Loading data from Google"))
                      incProgress(0.5, detail = paste(" Building the tree"))
                      biuldBigTree(value)
                      })
                    })
  values$questionPlot <-
    eventReactive(input$click1,
                  {
                    withProgress(message = '(Re-) Generating tree', value = 0.1, {
                      incProgress(0.1, detail = paste(" Loading data from Google"))
                      value <- read_lit_gs()
                      incProgress(0.2, detail = paste(" Loading data from Google"))
                      incProgress(0.1, detail = paste(" Building the tree"))
                      biuldBigTree(value,"Question", "questTags", "quest")
                    })
                  })
  values$dataPlot <-
    eventReactive(input$click2,
                  {
                    withProgress(message = '(Re-) Generating tree', value = 0.1, {
                      incProgress(0.1, detail = paste(" Loading data from Google"))
                      value <- read_lit_gs()
                      incProgress(0.2, detail = paste(" Loading data from Google"))
                      incProgress(0.1, detail = paste(" Building the tree"))
                      biuldBigTree(value,"Data", "dataTags", "data")
                    })
                  })
  
  output$methodology <- renderCollapsibleTree({values$methodsPlot()})
  output$question <- renderCollapsibleTree({values$questionPlot()})
  output$dataTree <- renderCollapsibleTree({values$dataPlot()})
  
}

# Run the application
shinyApp(ui = ui, server = server)