flatten_answers = function(a) {
  tibs = map(a, as_tibble)
  tibs %>%
    map2(names(tibs), function(i, j) {
      colnames(i) = paste0(j, "_", colnames(i))
      i
    }) %>%
    bind_cols()
}

globalVariables(c("answers", "metadata", "hidden", "calculated",
                  "landed_at", "submitted_at"))
#' @importFrom dplyr matches
get_meta = function(content) {
  items = content$items
  if (length(items) == 0) {
    empty_meta = tibble("landing_id" = "", "token" = "",
                        "landed_at" = "", "submitted_at" = "", "user_agent" = "",
                        "platform" = "", "referer" = "", "network_id" = "",
                        "browser" = "", "score" = "")[0, ]
    return(empty_meta)
  }
  meta = items %>%
    select(-answers, -metadata, -matches("hidden"), -matches("calculated")) %>%
    as_tibble() %>%
    bind_cols(items$metadata, items$hidden, items$calculated) %>%
    mutate(landed_at = ymd_hms(landed_at),
           submitted_at = ymd_hms(submitted_at))

  attr(meta, "total_items") = content$total_items
  attr(meta, "page_count") = content$page_count
  meta
}


globalVariables(".")
#' Download questionnaire results
#'
#' Download results for a particular typeform questionnaire.
#' @inheritParams get_api
#' @param form_id The form id of the typeform you want the results for.
#' @param page_size Maximum number of responses.
#' Default value is 25. Maximum value is 1000.
#' @param since default \code{NULL}. Fetch only the results after a specific date and
#' time. If \code{NULL} return all results. This should be a date time object.
#' The timezone of the object will be converted to UTC.
#' @param until default \code{NULL}. Similar to \code{since}.
#' @param after default \code{NULL}. Fetch only the results after a specific date and
#' time. If \code{NULL} return all results. If you use the after parameter, the responses
#' will be sorted in the order that our system processed them
#' (instead of the default order, submitted_at).
#' This ensures that you can traverse the complete set of responses without repeating entries.
#' @param before default \code{NULL}. Similar to \code{after}
#' @param completed default \code{NULL}, return all results.
#' Fetch only completed results (\code{TRUE}), or only not-completed results
#' (=\code{FALSE}). If \code{NULL} return all results. Warning. It's not
#' possible to determine completed/non-completed results.
#' @param query Limit request to only responses that that include the specified term.
#' @param fields Not implemented. Pull requests welcome
#' @return A list. The first value is meta information. Subsequent elements are
#' questions..
#' @importFrom purrr flatten_df map_df keep
#' @importFrom utils read.csv
#' @importFrom tibble as_tibble
#' @importFrom purrr %>%
#' @seealso https://developer.typeform.com/responses/reference/retrieve-responses/
#' @export
get_responses = function(form_id, api = NULL,
                         page_size = 25,
                         since = NULL, until = NULL, after = NULL, before = NULL,
                         completed = NULL, query = NULL, fields = NULL) {
  # Format dates
  since = format_date_time(since)
  until = format_date_time(until)
  after = format_date_time(after)
  before = format_date_time(before)

  # Format complete
  completed = format_completed(completed)

  # Construct REST points
  page_size = create_argument(page_size)
  since = create_argument(since)
  until = create_argument(until)
  after = create_argument(after)
  before = create_argument(before)
  completed = create_argument(completed)
  query = create_argument(query)
  fields = create_argument(fields)

  url = glue("https://api.typeform.com/forms/{form_id}/responses?\\
             {page_size}&{since}&{until}&{after}&{before}\\
             {completed}&{query}&{fields}")
  content = get_response(api = api, url)

  meta = get_meta(content)
  if (nrow(meta) == 0L) { # No responses
    return(list(meta = meta))
  }

  items = content$items
  answers = items$answers

  # all_answers: list where each element is a question
  all_answers = answers %>%
    map(flatten_answers) %>%
    map2(items$landing_id, ~mutate(.x, landing_id = .y)) %>%
    bind_rows() %>%
    split(.$field_id)

  question_types = all_answers %>%
    map(~select(.x, type_value)) %>%
    map(~slice(.x, 1)) %>%
    bind_rows() %>%
    pull()

  all_answers = all_answers %>%
    map2(question_types,
         ~select(.x,
                 "field_type", "landing_id", starts_with(paste0(.y, "_")))) %>%
    map(~unnest(.x, cols = c())) %>%
    map(~rename(.x, type = 1, value = 3))

  c(list(meta = meta), all_answers)
}
