globalVariables(c("forms", "name1"))

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
    select(-forms, -self) %>%
    as_tibble() %>%
    bind_cols(items$forms, items$self)
  attr(workspaces, "page_count") = content$page_space
  attr(workspaces, "total_items") = content$total_items
  workspaces
}

#' @importFrom httr content_type_json
#' @param workspace_name The name workspace name
#' @rdname get_workspaces
#' @export
create_workspace = function(workspace_name, api = NULL) {
  # Simple json
  body = glue('{"name": "<workspace_name>"}',.open = "<", .close = ">")
  url = "https://api.typeform.com/workspaces"
  content = post_response(api = api, url, body = body, content_type_json())
  content %>%
    flatten_dfc() %>%
    rename(workspace_name = name1)
}

#' @rdname get_workspaces
#' @export
get_workspace = function(workspace_id, api = NULL) {
  url = glue("https://api.typeform.com/workspaces/{workspace_id}")
  content = get_response(api, url)
  items = content$items
  workspace = items %>%
    select(-matches("forms"), -matches("self")) %>%
    as_tibble() %>%
    bind_cols(items$forms, items$self)
  attr(workspace, "page_count") = content$page_space
  attr(workspace, "total_items") = content$total_items
  workspace
}

#' @importFrom jsonlite toJSON unbox
#' @param add_members Email address
#' @param remove_members Email address
#' @rdname get_workspaces
#' @export
update_workspace = function(workspace_id, api = NULL, workspace_name = NULL,
                            add_members = NULL, remove_members = NULL) {

  url = glue("https://api.typeform.com/workspaces/{workspace_id}")

  l = list(); i = 0
  if (!is.null(workspace_name))
    l[[i <- i + 1]] = list(op = unbox("replace"),
                           path = unbox("/name"),
                           value = unbox(workspace_name))
  if (!is.null(add_members))
    l[[i <- i + 1]] = list(op = unbox("add"),
                           path = unbox("/members"),
                           value = list(email = unbox(add_members)))

  if (!is.null(remove_members))
    l[[i <- i + 1]] = list(op = unbox("remove"),
                           path = unbox("/members"),
                           value = list(email = unbox(remove_members)))

  patch_response(api, url, body = toJSON(l), content_type_json())
}

#' @export
#' @rdname get_workspaces
delete_workspace = function(workspace_id, api = NULL) {
  url = glue("https://api.typeform.com/workspaces/{workspace_id}")
  delete_response(api, url)
}
