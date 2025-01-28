#' Get Authorization
#'
#' A function to get authorization
#' @param api An authentication key
#' @export
get_authorization = function(api) {
  api = get_api(api)
  httr::add_headers(authorization = glue::glue("bearer {api}"))
}

#' Check api response
#'
#' A function that checks the api response
#' @param resp A response
#' @param content The content
#' @export
check_api_response = function(resp, content) {
  status_code = httr::status_code(resp)
  if (status_code %in% c(200, 201, 204)) return(invisible(TRUE))

  msg = glue::glue("{status_code} - {content$code}: {content$description}")
  stop(msg, call. = FALSE)
}

#' Get response
#'
#' A function that allows you to get a response from the
#' server.
#' @param api An authentication key
#' @param url The URL of the site
#' @export
get_response = function(api, url) {
  authorization = get_authorization(api)
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")

  resp = httr::GET(url, authorization, ua)
  cont = httr::content(resp, "text", encoding = "UTF-8")
  content = jsonlite::fromJSON(cont)

  check_api_response(resp, content)
  content
}

put_response = function(api, url, ...) {
  authorization = get_authorization(api)
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")

  resp = httr::PUT(url, authorization, body = body, ua, ...)
  cont = httr::content(resp, "text", encoding = "UTF-8")

  if (nchar(cont) > 0) content = jsonlite::fromJSON(cont)
  else content = ""

  check_api_response(resp, content)
}

delete_response = function(api, url) {
  authorization = get_authorization(api)
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")

  resp = httr::DELETE(url, authorization, ua)
  cont = httr::content(resp, "text", encoding = "UTF-8")

  if (nchar(cont) > 0) content = jsonlite::fromJSON(cont)
  else content = ""

  check_api_response(resp, content)
}

#' Post response
#'
#' A function that allows you to post an update to the
#' server
#' @param api An authentication key
#' @param url The URL of the site
#' @param body The information sent out to the server. e.g. the title
#' @param ... Other arguments
#' @export
post_response = function(api, url, body = NULL, ...) {
  authorization = get_authorization(api)
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")

  resp = httr::POST(url, authorization, body = body, ua, ...)
  cont = httr::content(resp, "text", encoding = "UTF-8")
  content = jsonlite::fromJSON(cont)

  check_api_response(resp, content)
  content
}

patch_response = function(api, url, body = NULL, ...) {
  authorization = get_authorization(api)
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")

  resp = httr::PATCH(url, authorization, body = body, ua, ...)
  content = httr::content(resp, "text", encoding = "UTF-8")

  check_api_response(resp, content)
  content
}
