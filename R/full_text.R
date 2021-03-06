# find most likely encoding, but remove "windows-1252" before, since
# sometimes UTF-8 has a slightly lesser confidence, although it is the right
# encoding
get_encoding <- function(filename) {
  readr::guess_encoding(filename) %>%
    dplyr::filter(encoding != "windows-1252") %>%
    dplyr::select(encoding) %>%
    dplyr::slice(1L) %>%
    as.character()
}

#' Import full-text
#'
#' This function imports the full_text contents of a JSTOR-article.
#'
#' @param filename The path to the file.
#' @return A `tibble`, containing the file-path as id, the full content of
#' the file, and the encoding which was used to read it.
#'
#' @export
jst_get_full_text <- function(filename) {
  validate_file_path(filename, "txt")

  id <- jst_get_file_name(filename)

  encoding <- get_encoding(filename)

  text <- read_file(filename, locale = locale(encoding = encoding))

  out <- list(
    file_name = id, full_text = text, encoding = encoding
  )
  
  nrow <- validate_tibble(out)
  
  new_tibble(out, nrow = nrow)
}
