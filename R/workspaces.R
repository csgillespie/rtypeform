#' @rdname get_workspaces
#' @export
get_number_of_workspace = function(api = NULL, search = NULL) {
  search = create_argument(search)
  url = glue::glue("https://api.typeform.com/workspaces?{search}")
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

  url = glue::glue("https://api.typeform.com/workspaces?{search}&{page}&{page_size}")
  content = get_response(api = api, url)
  items = content$items
  workspaces = items %>%
    dplyr::select(-"forms", -"self") %>%
    dplyr::as_tibble() %>%
    dplyr::bind_cols(items$forms, items$self)
  attr(workspaces, "page_count") = content$page_space
  attr(workspaces, "total_items") = content$total_items
  workspaces
}


#' @param workspace_name The name workspace name
#' @rdname get_workspaces
#' @export
create_workspace = function(workspace_name, api = NULL) {
  # Simple json
  body = glue::glue('{"name": "<workspace_name>"}', .open = "<", .close = ">")
  url = "https://api.typeform.com/workspaces"
  content = post_response(api = api, url, body = body, httr::content_type_json())
  content %>%
    purrr::flatten_dfc() %>%
    dplyr::rename(workspace_name = .data$name1)
}

#' @rdname get_workspaces
#' @export
get_workspace = function(workspace_id, api = NULL) {
  url = glue::glue("https://api.typeform.com/workspaces/{workspace_id}")
  content = get_response(api, url)
  workspace = dplyr::tibble(default = content$default,
                            id = content$id,
                            name = content$name,
                            self = content$self,
                            forms_count = content$forms$count,
                            forms_href = content$forms$href,
                            members_email = content$members$email,
                            members_id = content$members$id,
                            members_name = content$members$name,
                            members_role = content$members$role)

  workspace
}

#' @param add_members Email address
#' @param remove_members Email address
#' @rdname get_workspaces
#' @export
update_workspace = function(workspace_id, api = NULL, workspace_name = NULL,
                            add_members = NULL, remove_members = NULL) {

  url = glue::glue("https://api.typeform.com/workspaces/{workspace_id}")

  l = list()
  i = 0
  if (!is.null(workspace_name))
    l[[i <- i + 1]] = list(op = jsonlite::unbox("replace"), #nolint
                           path = jsonlite::unbox("/name"),
                           value = jsonlite::unbox(workspace_name))
  if (!is.null(add_members))
    l[[i <- i + 1]] = list(op = jsonlite::unbox("add"), #nolint
                           path = jsonlite::unbox("/members"),
                           value = list(email = jsonlite::unbox(add_members)))

  if (!is.null(remove_members))
    l[[i <- i + 1]] = list(op = jsonlite::unbox("remove"), #nolint
                           path = jsonlite::unbox("/members"),
                           value = list(email = jsonlite::unbox(remove_members)))

  patch_response(api, url, body = jsonlite::toJSON(l), httr::content_type_json())
}

#' @export
#' @rdname get_workspaces
delete_workspace = function(workspace_id, api = NULL) {
  url = glue::glue("https://api.typeform.com/workspaces/{workspace_id}")
  delete_response(api, url)
}
