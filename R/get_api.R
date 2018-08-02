#' Retrieve API key from Renviron
#'
#' If the entry \code{typeform_api2} exists in your
#' \code{.Renviron} return that value. Otherwise, raise an error.
#' @param api Default \code{NULL}. Your private api key. If \code{api} is \code{NULL},
#' the environment variable \code{Sys.getenv("typeform_api2")} is used.
#' @details In version 1 of the typeform API, rtypeform looked for the key \code{typeform_api},
#' @export
get_api = function(api = NULL){
  if(is.null(api)) api = Sys.getenv("typeform_api2")

  if(nchar(api) != 0) return(api)
  if(nchar(Sys.getenv("typeform_api")) > 0)
    stop("Old key")
  stop("Invalid api key.", call. = FALSE)
}
