library(tidyverse)

read_bin = function(f) {
  con = file(f, "rb")
  z = readBin(con, what = "raw", n = file.size(f))
  close(con)

  z
}

get_name = function(path) {
  fs::path_file(path) %>%
    fs::path_ext_remove() %>%
    stringr::str_remove("_2x$")
}


process_file_icons = function() {
  files = fs::dir_ls(here::here("data-raw/icons/"), recurse = TRUE, type = "file")

  tibble::tibble(
    path = files
  ) %>%
    mutate(
      name = get_name(path),
      type = "File",
      data = purrr::map(path, read_bin),
      info = purrr::map(
        data,
        ~ magick::image_read(.x) %>% magick::image_info()
      )
    ) %>%
    unnest_wider(info) %>%
    relocate(name, type) %>%
    select(-colorspace, -matte, -density, -path)
}




process_command_icons = function() {
  dir = here::here("data-raw/commands/")
  cats = parse_categories(file.path(dir, "Commands.java"))

  tibble::tibble(
    path = fs::dir_ls(dir, type = "file", glob = "*.png")
  ) %>%
    mutate(
      name = get_name(path),
      type = cats[name],
      type = ifelse(is.na(type), "Other", type),
      data = purrr::map(path, read_bin),
      info = purrr::map(
        data,
        ~ magick::image_read(.x) %>% magick::image_info()
      )
    ) %>%
    unnest_wider(info) %>%
    relocate(name, type) %>%
    select(-colorspace, -matte, -density, -path)
}


parse_categories = function(file) {
  icon_pat = "public abstract AppCommand ([A-Za-z0-9]+)\\(\\);"
  header_pat = "^   // ([A-Za-z0-9 ]+)$"

  cur_header = "???"
  res = character()

  for(line in readLines(file)) {
    if (stringr::str_detect(line, header_pat)) {
      cur_header = stringr::str_match(line, header_pat)[2]
    } else if (stringr::str_detect(line, icon_pat)) {
      icon = stringr::str_match(line, icon_pat)[2]
      if (!is.na(res[icon]))
        warning("Icon ", icon, " already exits.")
      res[icon] = cur_header
    }
  }

  res
}

process_icon_folder = function(path) {
  files = fs::dir_ls(path, recurse = TRUE, type = "file", glob = "*.png")

  prefix = fs::path_file(path)
  cat = purrr::map_chr(
    fs::path_split(files),
    ~ .x[-length(.x)] %>%
      { .[seq_along(.) >= which(. == prefix)]} %>%
      paste(collapse= " - ") %>%
      stringr::str_to_title()
  )


  tibble::tibble(
    path = files,
    type = cat,
  ) %>%
    mutate(
      name = get_name(path),
      data = purrr::map(path, read_bin),
      info = purrr::map(
        data,
        ~ magick::image_read(.x) %>% magick::image_info()
      )
    ) %>%
    unnest_wider(info) %>%
    relocate(name, type) %>%
    select(-colorspace, -matte, -density, -path)

}



icons = bind_rows(
  process_file_icons(),
  process_command_icons(),
  process_icon_folder(here::here("data-raw/common"))
) %>%
  arrange(type, name, width, height)


usethis::use_data(icons, overwrite=TRUE)

