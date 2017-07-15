#' Fetch all available typeforms
#'
#' This function returns a two column data frame containing the typeform names and
#' their associated ids.
#' @importFrom jsonlite fromJSON
#' @param api Default \code{NULL}. Your private api key. If \code{api} is \code{NULL},
#' the environment variable \code{Sys.getenv("typeform_api")} is used.
#' @return A list containing content and the response.
#' @importFrom httr user_agent GET status_code content
#' @export
#' @examples
#' \dontrun{
#' api = "XXXXX"
#' tf = get_all_typeforms(api)
#' tf$content
#'
#' ## Use the system variable
#' get_all_typeforms()
#' }
get_all_typeforms = function(api=NULL) {
  api = get_api(api)
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")
  url = "https://api.typeform.com/v1/forms"
  resp = httr::GET(url, query = list(key = api), ua)
  cont = httr::content(resp, "text")

  # Sanity check
  check_api_response(resp, cont)

  # The returned object
  structure(
    list(
      content = jsonlite::fromJSON(cont),
      http_status = 200 ## Must be 200 otherwise error
    ),
    class = "rtypeform_all"
  )
}
