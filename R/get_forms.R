#' @rdname get_forms
#' @export
get_number_of_forms = function(api = NULL,
                               search = "",
                               workspace_id = NULL) {
  page_size = 1
  page_size = create_argument(page_size)
  search = create_argument(search)
  workspace_id = create_argument(workspace_id)
  url = glue::glue("https://api.typeform.com/forms?{page_size}&{search}&{workspace_id}")
  content = get_response(api = api, url)
  content$total_items
}

#' Fetch all available typeforms
#'
#' This function returns a two column data frame containing the typeform names and
#' their associated ids.
#' @param api Default \code{NULL}. Your private api key. If \code{api} is \code{NULL},
#' the environment variable \code{Sys.getenv("typeform_api")} is used.
#' @param search Returns items that contain the specified string.
#' @param page The page of results to retrieve. Default 1 is the first page of results.
#' @param page_size Number of results to retrieve per page. Default is 10. Maximum is 200.
#' @param workspace_id Retrieve typeforms for the specified workspace.
#' @return A list containing content and the response.
#' @export
get_forms = function(api = NULL,
                     page = 1,
                     page_size = 10,
                     search = "",
                     workspace_id = NULL) {
  if (page_size > 200) {
    warning("Maximum size is 200. Setting page size to 200")
    page_size = 200
  }

  page = create_argument(page)
  page_size = create_argument(page_size)
  search = create_argument(search)
  workspace_id = create_argument(workspace_id)

  url = glue::glue("https://api.typeform.com/forms?{page}&{page_size}&{search}&{workspace_id}")
  content = get_response(api = api, url)

  items = content$items
  if (length(items) == 0) {
    items  = dplyr::tibble(form_id = "", title = "", last_updated = "", is_public = "",
                           is_trial = "", questions = "", theme = "", questionnaire_url = "")[0, ]
    return(items)
  }

  theme = dplyr::select(items$theme, theme = "href")
  self = dplyr::rename(items$self, questions = .data$href)

  items = items %>%
    dplyr::select(-"settings", -"self", -"theme", -.data[["_links"]]) %>%
    dplyr::as_tibble() %>%
    dplyr::bind_cols(items$settings,
                     self,
                     theme,
                     items$`_links`) %>%
    dplyr::rename(questionnaire_url = .data$display,
                  last_updated = .data$last_updated_at,
                  form_id = .data$id) %>%
    dplyr::mutate(last_updated = lubridate::ymd_hms(items$last_updated_at))
  attr(items, "total_items") = content$total_items
  attr(items, "page_count") = content$page_count
  items
}
