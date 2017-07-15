check_api_response = function(resp, cont) {
  status_code = httr::status_code(resp)
  if(status_code == 200) return(invisible(NULL))

  msg = if(status_code == 400) {
    "400: Invalid date in query"
  } else if(status_code == 403) {
    "403: Expired token, invalid token, or token does not have access permission"
  } else if(status_code == 404) {
    "404: Type in URL/ Invalid typeform id"
  } else {
    sprintf("rtypeform API request failed [%s]\n",
            status_code)
  }

  stop(msg, call. = FALSE)

}
