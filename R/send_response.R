#' @importFrom httr user_agent GET status_code content add_headers
check_api_response = function(resp) {
  status_code = httr::status_code(resp)
  if(status_code == 200) return(invisible(NULL))

  msg = if(status_code == 400) {
    "400: Invalid date in query"
  } else if(status_code == 403) {
    "403: Expired token, invalid token, or token does not have access permission"
  } else if(status_code == 404) {
    "404: Typo in URL/ Invalid typeform id"
  } else {
    sprintf("rtypeform API request failed [%s]\n",
            status_code)
  }
  stop(msg, call. = FALSE)
}

send_response = function(api, url) {
  api = get_api(api)
  authorization = httr::add_headers(authorization = glue("bearer {api}"))
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")

  resp = httr::GET(url,
                   authorization,
                   ua)
  check_api_response(resp)

  cont = httr::content(resp, "text", encoding = "UTF-8")
  content = jsonlite::fromJSON(cont)
  content
}

