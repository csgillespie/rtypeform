send_response = function(api, url) {
  api = get_api(api)
  authorization = httr::add_headers(authorization = glue("bearer {api}"))
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")

  resp = httr::GET(url,
                   authorization,
                   ua)


  cont = httr::content(resp, "text", encoding = "UTF-8")
  content = jsonlite::fromJSON(cont)
  content
}



#' @export
get_number_of_forms = function(api = NULL,
                               search = "",
                               workspace_id = NULL) {
  url = glue("https://api.typeform.com/forms?page_size={1}&search={search}")
  content = send_response(api = api, url)
  content$total_items
}


#' Fetch all available typeforms
#'
#' This function returns a two column data frame containing the typeform names and
#' their associated ids.
#' @importFrom jsonlite fromJSON
#' @param api Default \code{NULL}. Your private api key. If \code{api} is \code{NULL},
#' the environment variable \code{Sys.getenv("typeform_api")} is used.
#' @return A list containing content and the response.
#' @importFrom httr user_agent GET status_code content add_headers
#' @importFrom glue glue
#' @import dplyr
#' @export
#' @examples
#' \dontrun{
#' }
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

