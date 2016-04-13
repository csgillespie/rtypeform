#' Fetch all available typeforms
#'
#' This function returns a data frame containing your typeforms and their
#' associated UIDs.
#' @importFrom jsonlite fromJSON
#' @param api Default \code{NULL}. Your private api key. If \code{api} is \code{NULL}
#' we use the environment variable \code{Sys.getenv("typeform_api")}.
#' @return A list containing content and the response.
#' @importFrom httr user_agent GET status_code content
#' @export
#' @examples
#' \dontrun{
#' api = "XXXXX"
#' tf = get_all_typeforms(api)
#' tf$content
#' }
get_all_typeforms = function(api=NULL) {
  api = get_api(api)
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")
  url = "https://api.typeform.com/v1/forms"
  resp = httr::GET(url,query=list(key=api), ua)
  cont = httr::content(resp, "text")

  check_api_response(resp, cont)
  structure(
    list(
      content = jsonlite::fromJSON(cont),
      response = resp
    ),
    class = "rtypeform_all_typeforms"
  )
}
