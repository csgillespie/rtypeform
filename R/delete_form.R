#' Deletes a typeform
#'
#' Delete the specified typeform.
#' @inheritParams get_api
#' @inheritParams get_responses
#' @export
delete_form = function(form_id, api = NULL) {
  url = glue("https://api.typeform.com/forms/{form_id}")
  delete_response(api, url)
}
