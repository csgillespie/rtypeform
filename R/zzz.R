.onAttach <- function(...) {
  packageStartupMessage("This is intended to be the final release of rtypeform using the data API (version 1).")
  packageStartupMessage("The next version of this package will use the response API (version 2) and will break all current functions (not my fault!). See https://github.com/csgillespie/rtypeform/issues/14 for progress.")
}
