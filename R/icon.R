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
