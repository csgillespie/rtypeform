globalVariables(c("forms"))

#' @rdname get_workspaces
#' @export
get_number_of_workspace = function(api = NULL, search = NULL) {
  search = create_argument(search)
  url = glue("https://api.typeform.com/workspaces?{search}")
  content = get_response(api = api, url)
  content$total_items
}

#' Available workspaces
#'
#' A tibble containing details on workspaces
#' @export
#' @inheritParams get_api
#' @inheritParams get_forms
get_workspaces = function(api = NULL,
                          search = NULL,
                          page = 1,
                          page_size = 10) {
  search = create_argument(search)
  page = create_argument(page)
  page_size = create_argument(page_size)

  url = glue("https://api.typeform.com/workspaces?{search}&{page}&{page_size}")
  content = get_response(api = api, url)
  items = content$items
  workspaces = items %>%
    select(-matches("fields"), -forms, -self) %>%
    as_tibble() %>%
    bind_cols(items$fields, items$forms, items$self)
  workspaces
}

