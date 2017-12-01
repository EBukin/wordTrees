#' Prepare network data for creating a tree
prepare_network_tree_data <- function(litData, rootVar = "meth", tagVar = "methTags", textVar = "meth") {
  
  textExpr <- 
    lazyeval::interp(
      ~ str_c('<div align="Left"><p>',idFull,"</br>", x,"</p></div>"), 
      x = as.name(textVar))
  
  # browser()
  outData <- 
    litData %>%
    # Text is the text of the lest node.
    mutate(name = idName) %>% 
    mutate_(.dots = setNames(list(textExpr), "text")) %>% 
    mutate_(.dots = setNames(list(lazyeval::interp(~x, x = as.name(tagVar))),"tags")) %>% 
    select(name, tags, text ) %>% 
    mutate(tags = ifelse(is.na(tags), "TBD", tags)) %>% 
    rowwise() %>%
    do({
      #browser()
      split_tag_groups(.$tags, .$name, .$text)
    }) %>%
    do({
      #browser()
      split_tag_nodes(.$tags, .$name, .$text, rootName = rootVar)
    }) %>% 
    ungroup() %>% 
    distinct() 
  outData
}
