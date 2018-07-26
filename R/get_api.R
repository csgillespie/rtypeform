#' Retrieve API key from Renviron
#'
#' If the entry \code{typeform_api_key} exists in your
#' \code{.Renviron} return that value. Otherwise, raise an error.
#' @inheritParams get_all_typeforms
#' @export
get_api = function(api = NULL){
  if(is.null(api)) api = Sys.getenv("typeform_api_key")

  if(nchar(api) != 0) return(api)
  if(nchar(Sys.getenv("typeform_api")) > 0)
    stop("Old key")
  stop("Invalid api key.")

}
