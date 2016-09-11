#' Retrieve API key from Renviron
#'
#' If the entry \code{typeform_api} exists in your
#' \code{.Renviron} return that value. Otherwise, raise an error.
#' @inheritParams get_all_typeforms
#' @export
get_api = function(api=NULL){
  if(is.null(api))
    api = Sys.getenv("typeform_api")
  if(nchar(api) == 0)
    stop("Invalid api key.")
  api
}
