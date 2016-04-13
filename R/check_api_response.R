check_api_response = function(resp, cont) {
  if (httr::status_code(resp) != 200) {
    parsed = jsonlite::fromJSON(cont, simplifyVector = FALSE)
    stop(
      sprintf(
        "rtypeform API request failed [%s]\n%s\n<%s>",
        status_code(resp),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }
}
