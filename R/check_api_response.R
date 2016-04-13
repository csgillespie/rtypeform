check_api_response = function(resp, cont) {
  if (httr::status_code(resp) != 200) {
    stop(
      sprintf(
        "rtypeform API request failed [%s]\n",
        status_code(resp)
      ),
      call. = FALSE
    )
  }
}
