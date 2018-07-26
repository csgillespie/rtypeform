#' @importFrom glue glue
#' @rdname get_forms
#' @export
get_number_of_forms = function(api = NULL,
                               search = "",
                               workspace_id = NULL) {
  url = glue("https://api.typeform.com/forms?page_size={1}&search={search}")
  content = send_response(api = api, url)
  content$total_items
}

globalVariables(c("settings", "self", "theme", "href", "href1", "display", "last_updated_at"))
#' Fetch all available typeforms
#'
#' This function returns a two column data frame containing the typeform names and
#' their associated ids.
#' @importFrom jsonlite fromJSON
#' @param api Default \code{NULL}. Your private api key. If \code{api} is \code{NULL},
#' the environment variable \code{Sys.getenv("typeform_api")} is used.
#' @param search Returns items that contain the specified string.
#' @param page The page of results to retrieve. Default 1 is the first page of results.
#' @param page_size Number of results to retrieve per page. Default is 10. Maximum is 200.
#' @param workspace_id Retrieve typeforms for the specified workspace.
#' @return A list containing content and the response.
#' @import dplyr purrr
#' @importFrom tidyr unnest
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
  if (!is.null(workspace_id)) {
    stop("workspace_id's have not yet been implemented.", call. = FALSE)
  }

  url = glue("https://api.typeform.com/forms?page={page}&page_size={page_size}&search={search}")
  content = send_response(api = api, url)

  ## TODO: Use this to give use message for empty contents
  #total_items = content$total_items
  #page_count = content$page_count
  items = content$items
  if (length(items) == 0) {
    items  = tibble(id = "", title = "", last_updated = "", is_public = "",
                    is_trial = "", questions = "", theme = "", questionnaire_url = "")
    return(items)
  }

  items = items %>%
    select(-settings, -self, -theme, -"_links") %>%
    as_tibble() %>%
    bind_cols(items$settings,
              items$self,
              items$theme,
              items$`_links`) %>%
    rename(questions = href,
           theme = href1,
           questionnaire_url = display,
           last_updated = last_updated_at) %>%
    mutate(last_updated = lubridate::ymd_hms(items$last_updated))
  items
}

