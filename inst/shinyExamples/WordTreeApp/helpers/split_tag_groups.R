#' Split tags indicated in the brackets into separate lines of the dataframe.
#' 
#' @param tags,text atomic vectors of tags and corresponding text
#' 
#' @example 
#' oneSubset %>% 
#'   rowwise() %>% 
#'   do({
#'       split_tag_groups(.$tags, .$text)
#'         }) %>% 
#'   ungroup()
split_tag_groups <- function(tags, name, text) {
  if (str_detect(tags, "\\(|\\)")) {
    line <-
      tags %>%
      str_extract_all(pattern = "\\((.*?)\\)") %>%
      unlist() %>%
      str_sub(2, -2) %>%
      map_df(function(.x) {
        tibble(tags = .x, text = text, name = name)
      })
  } else {
    line <-tibble(tags = tags, text = text, name = name)
  }
  line
}