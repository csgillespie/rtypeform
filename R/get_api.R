#' Retrieve API key from Renviron
#'
#' If the entry \code{typeform_api} exist in your
#' \code{.Renviron} return that value. Otherwise, raise an error.
#' @inheritParams get_results
#' @export
get_api = function(api=NULL){
  if(is.null(api))
    api = Sys.getenv("typeform_api")
  if(nchar(api) == 0)
    stop("Invalid api key.")
  api
}
