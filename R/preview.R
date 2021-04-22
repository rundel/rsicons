# Apply across and concatenate the result
# Useful for creating image vectors
map_img = function(x, fun, ...) {
  m = lapply(x, fun, ...)
  do.call(c, m)
}


#' @rdname preview
#' @name preview
#'
#' @title Preview icons
#'
#' @description Helper functions for previewing specific icons, icon types, or all available icons.
#'
#' @param name Icon name to preview.
#' @param type Icon type to preview.
#' @param max_size Maximum size of icon to include in preview, checks height and width.
#' @param n_col Number of columns to use when displaying all icons.
#' @param display Should the preview be displayed, via `print()` method of "magick-image".
#' @param inc_label Should the icons name be include in the preview.
#'
#' @return Returns a "magick-image" object.
#'
#' @examples
#'
#' preview_icon("rstudio")
#'
#' preview_type("File")
#'
NULL

#' @rdname preview
#' @export
preview_icon = function(name, max_size = 256, display = TRUE, inc_label = FALSE) {
  stopifnot(length(name) == 1)

  df = rsicons::icons[rsicons::icons$name == name,]

  if (nrow(df) == 0)
    stop("No icons with name `", name, "`", call. = FALSE)

  df = df[df$height < max_size & df$width < max_size,]

  label = magick::image_blank(
    width = 300, height = max(df$height, 36), color = "none"
  ) %>%
    magick::image_annotate(
      name, gravity = "northwest",
      font = "mono", size = 20,
      location = "+10+5"
    )

  img = map_img(df$data, magick::image_read) %>%
    magick::image_border(color="grey", geometry = "1x1") %>%
    magick::image_border(color="none", geometry = "5x5") %>%
    magick::image_background(color="none") %>%
    magick::image_append()

  if (inc_label) {
    img = c(label, img) %>%
      magick::image_background(color="none") %>%
      magick::image_append()
  }

  if (display)
    print(img, info = FALSE)
  else
    img
}

#' @rdname preview
#' @export
preview_type = function(type, max_size = 128, display = TRUE) {
  stopifnot(length(type) == 1)

  df = rsicons::icons[rsicons::icons$type == type,]

  if (nrow(df) == 0)
    stop("No icons with type `", type, "`", call. = FALSE)

  df = df[df$height < max_size & df$width < max_size,]

  icons = map_img(
    unique(df$name),
    preview_icon,
    max_size = max_size,
    display = FALSE,
    inc_label = TRUE
  )

  w = max(magick::image_info(icons)$width)

  img = magick::image_blank(width=w, height = 60, color = "none") %>%
    magick::image_annotate(
      paste0('"', type, '" icons'), gravity = "west",
      font = "mono", size = 26, weight = 700
    ) %>%
    magick::image_background(color = "none") %>%
    c(icons) %>%
    magick::image_append(stack = TRUE) %>%
    magick::image_border(color = "none", geometry = "10x")

  if (display)
    print(img, info = FALSE)
  else
    img
}

#' @rdname preview
#' @export
preview_all = function(n_col = 4, max_size = 128, display = TRUE) {
  types = unique(rsicons::icons$type)

  img = map_img(types, preview_type, max_size = max_size, display = FALSE)

  info = magick::image_info(img)
  tot_height = sum(info$height)
  col_height = tot_height/n_col

  cols = c()
  for(i in seq_len(n_col)) {
    cum_height = cumsum(info$height)

    i = which.min((col_height - cum_height)^2)
    sub = seq_len(i)

    col = magick::image_append(img[sub], stack = TRUE)
    if (is.null(cols))
      cols = col
    else
      cols = c(cols, col)

    img = img[-sub]
    info = info[-sub,]
  }

  img = magick::image_border(cols, color = "none", geometry = "+10+0") %>%
    magick::image_append()

  if (display)
    return( print(img, info = FALSE) )
  else
    return( img )
}









