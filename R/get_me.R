#' Retrieve your own account information.
#'
#' Returns alias, email and language.
#' @inheritParams get_api
#' @export
get_me = function(api = NULL) {
  url = "https://api.typeform.com/me"
  content = get_response(api = api, url)
  unlist(content)
}
