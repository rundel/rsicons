#' @rdname available
#' @name available
#'
#' @title List available icons or types
#'
#' @description Helper functions for providing a list of available icons or types.
#' Both functions support the use of regular expressions to subset the results to make
#' them more manageable.
#'
#'
#' @param pattern A regular expression pattern
#' @param ... Additional arguments that are passed to [grepl()].
#'
NULL

#' @rdname available
#' @return - `available_icons()` returns a named (by type) list of icons.
#' @examples
#' available_icons("vcs")
#'
#' @export
available_icons = function(pattern = NULL, ...) {
  if (!is.null(pattern))
    sub = grepl(pattern, rsicons::icons$name, ...)
  else
    sub = TRUE


  tapply(rsicons::icons$name[sub], rsicons::icons$type[sub], c) %>%
    lapply(unique)
}

#' @rdname available
#' @return - `available_types()` returns a vector of icon types matching the given pattern.
#' @examples
#'
#' available_types("Common")
#'
#' @export
available_types = function(pattern = NULL, ...) {
  if (!is.null(pattern))
    sub = grepl(pattern, rsicons::icons$type, ...)
  else
    sub = TRUE

  unique(rsicons::icons$type[sub])
}
