#' @title Create an icon
#'
#' @description Creates an icon using based on the provided `name`. The icon will be returned
#' either as a "magick-image" object (if `output = "img"`) or as a text string containing an
#' html img tag (if `output = "tag"`).
#'
#' The height and the width can be specified, the function will try to match the icon with the
#' closest possible size and can resize if necessary.
#'
#' @param name Icon name.
#' @param height Icon height in pixels.
#' @param width Icon width in pixels.
#' @param resize Should the icon be resized to the provided height and/or width.
#' @param output Return either a "magick-image" object or img tag text string.
#'
#' @return The return type is determined by the value of `output` selected.
#'
#' @examples
#'
#' icon("rstudio", 64)
#' icon("rstudio", 72)
#' icon("rstudio", 72, resize = TRUE)
#'
#' icon("rstudio", 64, output = "tag")
#'
#' @export
icon = function(name, height = NULL, width = NULL, resize = FALSE, output = c("img", "tag")) {
  stopifnot(length(height) <= 1)
  stopifnot(length(width) <= 1)

  output = match.arg(output)

  if (length(name) > 1) {
    tags = vapply(name, icon, character(), height = height, width = width)
    return(tags)
  }

  df = rsicons::icons[rsicons::icons$name == name,]

  if (nrow(df) == 0)
    stop("No icons with name `", name, "`", call. = FALSE)


  if (is.null(height) && is.null(width)) {
    info = icon_info(name)
    stop("Either height or width must be specified.\n  Icon `", name,
         "` has the following sizes available: ", paste(info$sizes, collapse=", "))
  }

  dist = 0
  if (!is.null(height)) {
    dist = dist + (df$height-height)^2
  }
  if (!is.null(width)) {
    dist = dist + (df$width-width)^2
  }

  best_size = which.min( dist )

  if (!resize) {
    height = NULL
    width = NULL
  }

  if (output == "tag") {
    img_type = df$format[best_size] %>% tolower()

    htmltools::img(
      src = paste0(src='data:image/', img_type, ';base64,',
                   base64enc::base64encode(df$data[[best_size]])
      ),
      alt = paste0('RStudio Icon ', name),
      height = height,
      width = width
    )
  } else if (output == "img") {
    img = magick::image_read(
      df$data[[best_size]]
    )
    if (!is.null(height) | !is.null(width))
      img = magick::image_resize(img, geometry = paste0(height, "x", width))

    img
  }
}

#' @title Icon details
#'
#' @description Retrieves basic useful information about the requested icon, including its type,
#' available sizes, and image formats.
#'
#' @param name Icon name.
#'
#' @return A named list.
#'
#' @examples
#'
#' icon_info("rstudio")
#'
#' @export
icon_info = function(name) {
  stopifnot(length(name) == 1)

  df = rsicons::icons[rsicons::icons$name == name,]

  if (nrow(df) == 0)
    stop("No icons with name `", name, "`", call. = FALSE)

  list(
    type = unique(df$type),
    sizes = paste0(df$height, "x", df$width),
    formats = unique(df$format)
  )
}
