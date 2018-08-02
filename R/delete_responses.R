#' Delete Responses
#'
#' Delete entries in a type form- use with care!
#' @inheritParams get_api
#' @inheritParams get_responses
#' @param included_tokens A vector of tokens to delete. Maximum 1000. Token ids
#' can be extracted from the meta data frame via \code{get_form}.
#' @return If successful, the function will return (invisibily) \code{TRUE}
#' @importFrom glue glue_collapse
#' @export
delete_responses = function(form_id, api = NULL, included_tokens = NULL) {
  included_tokens = glue_collapse(included_tokens, sep = ",")
  included_tokens = create_argument(included_tokens)

  url = glue("https://api.typeform.com/forms/{form_id}/responses?\\
             {included_tokens}")
  delete_response(api = api, url)
}

