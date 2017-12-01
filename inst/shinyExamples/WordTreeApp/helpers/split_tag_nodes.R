
split_tag_nodes <- function(tags, name, text, tree = FALSE, table = TRUE, rootName = "Methods", tagsSeparators = "[,;:]") {
  
  tagsSet <-
    str_split(tags, tagsSeparators) %>%
    unlist %>%
    str_trim() %>% 
    c(name)
  
  if (table) {
    output <- 
      bind_cols(
        tibble(node_00 = rootName),
        lapply(1:length(tagsSet), function(x) {
          resultDF <- data_frame(tagsSet[x])
          if (x < 10 & x != length(tagsSet)) x <- paste0('0',x)
          if (x < length(tagsSet)) {
            names(resultDF) <- paste0("node_",x)
          } 
          else {
            names(resultDF) <- paste0("node_99")
          }
          resultDF
        }),
        tibble(text = text)
      )
    
  }
  
  
  if (tree) {
    output <-
      bind_rows(tibble(
        root = NA,
        branch = rootName,
        text = NA
      ),
      seq(1, length(tagsSet)) %>%
        map_df(function(.x) {
          # browser()
          if (.x == 1)
            newLine <- tibble(root = rootName,
                              branch = tagsSet[.x],
                              text = NA)
          if (.x > 1 &&
              .x < length(tagsSet))
            newLine <-
              tibble(root = tagsSet[.x - 1],
                     branch = tagsSet[.x],
                     text = NA)
          if (.x == length(tagsSet))
            newLine <-
              tibble(root = tagsSet[.x - 1],
                     branch = tagsSet[.x],
                     text = text)
          newLine
        }))
  }
  
  output

}
