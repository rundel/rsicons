#' @export

available_icons = function() {

}

fs::dir_ls(system.file("icons/icons/", package="rsicons"))
