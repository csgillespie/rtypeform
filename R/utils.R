check_package_loaded = function (package_name) {
  if (!requireNamespace(package_name, quietly = TRUE)) {
    stop(paste0(package_name, " needed for this function to work. Please install it"),
         call. = FALSE)
  }
}
