

library(shiny)
library(collapsibleTree)
library(tidyverse)
library(stringr)
library(googlesheets)

source("R/read_lit_gs.R")
source("R/split_tag_groups.R")
source("R/split_tag_nodes.R")
source("R/prepare_network_tree_data.R")

# Define UI for application that draws a collapsible tree
ui <- fluidPage(
  
  # Application title
  titlePanel("Mind maps from literature Reviews"),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Methodology", 
               actionButton("reloadData", "Reload literature data"),
               collapsibleTreeOutput("methodology", height = "600px")),
      tabPanel("Reseqrch question", 
               actionButton("reloadData", "Reload literature data"),
               collapsibleTreeOutput("question", height = "600px"))
    )
  )

)

# Define server logic required to draw a collapsible tree diagram
server <- function(input, output) {
  
  value <- reactiveVal(read_lit_gs())
  
  observeEvent(input$reloadData, {
    newValue <- read_lit_gs()
    value(newValue)
  })
  
  output$methodology <- renderCollapsibleTree({
    
    tree <- 
      value() %>% 
      prepare_network_tree_data(rootVar = "Methods", "methTags", "meth") 
    
    treeNames <- 
      names(tree)[str_detect(names(tree), "node")] %>% 
      sort()
    
    collapsibleTreeSummary(
      tree,
      treeNames, tooltip = TRUE,
      nodeSize = "count",
      collapsed = FALSE, 
      height = "700px")
  })  
  
  output$question <- renderCollapsibleTree({
    
    tree <- 
      value() %>% 
      prepare_network_tree_data(rootVar = "Question", "questTags", "quest") 
    
    treeNames <- 
      names(tree)[str_detect(names(tree), "node")] %>% 
      sort()
    
    collapsibleTreeSummary(
      tree,
      treeNames, tooltip = TRUE,
      nodeSize = "count",
      collapsed = FALSE, 
      height = "700px")
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)