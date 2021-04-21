#' @export
available_icons = function(pattern = NULL, ...) {
  if (!is.null(pattern))
    sub = grepl(pattern, rsicons::icons$name, ...)
  else
    sub = TRUE


  tapply(rsicons::icons$name[sub], rsicons::icons$type[sub], c)
}

#' @export
available_types = function(pattern = NULL, ...) {
  if (!is.null(pattern))
    sub = grepl(pattern, rsicons::icons$type, ...)
  else
    sub = TRUE

  unique(rsicons::icons$type[sub])
}
