get_authorization = function(api) {
  api = get_api(api)
  httr::add_headers(authorization = glue("bearer {api}"))
}

#' @importFrom httr status_code
check_api_response = function(resp, content) {
  status_code = httr::status_code(resp)
  if (status_code %in% c(200, 201, 204)) return(invisible(NULL))

  msg = glue::glue("{status_code} - {content$code}: {content$description}")
  stop(msg, call. = FALSE)
}

#' @importFrom httr GET user_agent content add_headers
get_response = function(api, url) {
  authorization = get_authorization(api)
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")

  resp = httr::GET(url, authorization, ua)
  cont = httr::content(resp, "text", encoding = "UTF-8")
  content = jsonlite::fromJSON(cont)

  check_api_response(resp, content)
  content
}

#' @importFrom httr DELETE
delete_response = function(api, url) {
  authorization = get_authorization(api)
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")

  resp = httr::DELETE(url, authorization, ua)
  cont = httr::content(resp, "text", encoding = "UTF-8")
  content = jsonlite::fromJSON(cont)

  check_api_response(resp, content)
  return(invisible(TRUE))
}

#' @importFrom httr POST
post_response = function(api, url, body) {
  authorization = get_authorization(api)
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")

  resp = httr::POST(url, authorization, body = body, ua)
  cont = httr::content(resp, "text", encoding = "UTF-8")
  content = jsonlite::fromJSON(cont)

  check_api_response(resp, content)
  content
}

