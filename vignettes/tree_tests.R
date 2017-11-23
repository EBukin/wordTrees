#

# Setup -------------------------------------------------------------------


# Instaling the package with the tree functionality:
devtools::install_github("AdeelK93/collapsibleTree")
library(collapsibleTree)
library(tidyverse)
library(stringr)
library(googlesheets)

# Functions
source("R/read_lit_gs.R")
source("R/split_tag_groups.R")
source("R/split_tag_nodes.R")
source("R/prepare_network_tree_data.R")

# Pages with the mind map builders
#  https://github.com/pzhaonet/mindr
#  https://gojs.net/latest/samples/mindMap.html
# https://github.com/NorthwoodsSoftware/GoJS/blob/master/samples/mindMap.html
# See this https://www.npmjs.com/browse/keyword/mindmap


# Play -------------------------------------------------------------------
# 
# Geography <- readxl::read_excel("data/Geography Table - Data.World.xlsx")
# 
# collapsibleTree(
#   Geography,
#   hierarchy = c("continent", "type", "country"),
#   width = 800
# )
# 
# research <- read_delim("data/Research questions.txt", delim = ";")
# collapsibleTree(
#   research,
#   root = "Research questions",
#   hierarchy = c("level1", "level2", "level3"),
#   width = 800,
#   collapsed = F
# )
# 
# collapsibleTreeNetwork(research,collapsed = FALSE)
# 
# Geography %>%
#   group_by(continent, type) %>%
#   mutate(`Number of Countries` = n()) %>% 
#   collapsibleTreeSummary(
#     hierarchy = c("continent", "type", "country"),
#     root = "Geography",
#     width = 800,
#     attribute = "Number of Countries",
#     zoomable = FALSE
#   )
# 
# 
# org <- data.frame(
#   Manager = c(
#     NA, "Ana", "Ana", "Bill", "Bill", "Bill", "Claudette", "Claudette", "Danny",
#     "Fred", "Fred", "Grace", "Larry", "Larry", "Nicholas", "Nicholas"
#   ),
#   Employee = c(
#     "Ana", "Bill", "Larry", "Claudette", "Danny", "Erika", "Fred", "Grace",
#     "Henri", "Ida", "Joaquin", "Kate", "Mindy", "Nicholas", "Odette", "Peter"
#   ),
#   Title = c(
#     "President", "VP Operations", "VP Finance", "Director", "Director", "Scientist",
#     "Manager", "Manager", "Jr Scientist", "Operator", "Operator", "Associate",
#     "Analyst", "Director", "Accountant", "Accountant"
#   )
# )
# 
# collapsibleTree(org, c("Manager", "Employee"), collapsed = FALSE)
# 
# collapsibleTreeNetwork(org, attribute = "Title", collapsed = FALSE)




# Testing own GS data -----------------------------------------------------

litData <- read_lit_gs()

# Creating a tree ---------------------------------------------------------


Methods <- 
  litData[8,] %>% 
  prepare_network_tree_data(rootVar = "Methods", "methTags", "meth") %>% 
  data.frame() %>% 
  collapsibleTreeNetwork(
    tooltipHtml = "text",
    nodeSize = "leafCount",
    collapsed = FALSE)


tree <- 
  litData %>% 
  prepare_network_tree_data(rootVar = "Methods", "methTags", "meth") 

treeNames <- names(tree)[str_detect(names(tree), "node")] %>% sort()


  collapsibleTreeSummary(
    tree,
    treeNames, tooltip = TRUE,
    nodeSize = "count",
    collapsed = FALSE)

Question <- 
  litData %>% 
  prepare_network_tree_data(rootVar = "Question", "questTags", "quest") %>% 
  data.frame() %>% 
  collapsibleTreeNetwork(
    tooltipHtml = "text",
    nodeSize = "leafCount",
    collapsed = FALSE)

Data <- 
  litData %>% 
  prepare_network_tree_data(rootVar = "Data", "dataTags", "data") %>% 
  data.frame() %>% 
  collapsibleTreeNetwork(
    tooltipHtml = "text",
    nodeSize = "leafCount",
    collapsed = FALSE)

