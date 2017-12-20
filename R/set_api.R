#' Set typeform api key
#'
#' A wrapper around \code{Sys.setenv} for setting the typeform api key for the current session.
#'
#' @inheritParams get_all_typeforms
#' @export
set_api = function(api = NULL){
  if(is.null(api) || nchar(api) == 0){
    stop("Not a valid api key")
  }
  Sys.setenv("typeform_api" = api)
}
