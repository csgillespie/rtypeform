get_linux_time = function(x) {
  if(class(x) == "Date") x = as.POSIXct(x)
  as.integer(x)
}

get_order_by = function(order_by) {
  if(is.null(order_by)) return("")

  order_bys = c("completed", "date_land_desc", "date_land_incr",
                "date_submit_desc", "date_submit_incr")
  if(!(order_by %in% order_bys))
    stop("order_by should be one of:\n", paste(order_bys, collapse = "\n"))

  end = switch(order_by,
               completed = "completed",
               date_land_desc = "[date_land,desc]",
               date_land_incr = "date_land",
               date_submit_desc = "[date_submit,desc]",
               date_submit_incr = "date_submit")
  paste0("&order_by=", end)
}

# For uncompleted, questions aren't returned, so questions == NULL
check_empty = function(responses, questions = NULL) {

  if(NCOL(responses) == 0) { # Handle edge case of no responses
    q = questions$id
    q = q[!grepl("group_", q)] # Remove group labels
    col_names = c("token", "completed", "browser", "platform",
                  "date_land", "date_submit", "user_agent",
                  "referer", "network_id", q)

    responses = tibble::as_tibble(read.csv(text=paste(col_names, collapse = ",")))
  }
  responses
}

#' @importFrom purrr map
split_hidden = function(responses, questions) {

  ## Check for NULL responses
  hidden = map(responses, "hidden") %>%
    map(
      function(element)
        map(element, function(element) {element[is.null(element)] = NA; element})
    ) %>%
    purrr::map_df(purrr::flatten_df)

  res = map(responses, function(element) element[names(element) != "hidden"]) %>%
    purrr::map_df(purrr::flatten_df)

  if(NROW(hidden) > 0)
    res = cbind(res, hidden)
  check_empty(res, questions)
}

#' Download questionnaire results
#'
#' Download results for a particular typeform questionnaire.
#' @inheritParams get_all_typeforms
#' @param uid The UID (unique identifier) of the typeform you want the results for.
#' @param completed default \code{NULL}, return all results.
#' Fetch only completed results (\code{TRUE}), or only not-completed results
#' (=\code{FALSE}). If \code{NULL} return all results.
#' @param since default \code{NULL}. Fetch only the results after a specific date and
#' time. If \code{NULL} return all results.
#' @param until default \code{NULL}. Fetch only the results before a specific date and
#' time. If \code{NULL} return all results.
#' @param offset Fetch all results except the first \code{offset}.
#' i.e. Start listing results from result #\code{offset} onwards.
#' @param limit default \code{NULL}. Fetch only \code{limit} results.
#' If \code{NULL} return all results.
#' @param order_by One of "completed", "date_land_desc", "date_land_incr",
#' "date_submit_desc", or "date_submit_incr".
#' @return A list containing questions, stats, completed responses,
#' and uncompleted responses and http status.
#' @importFrom purrr flatten_df map_df keep
#' @importFrom utils read.csv
#' @importFrom tibble as_tibble
#' @importFrom purrr %>%
#' @seealso https://www.typeform.com/help/data-api/
#' @export
#' @examples
#' \dontrun{
#' uid = "XXXX"
#' api = "YYYY"
#' results = get_results(uid, api)
#' results$stats
#' results$questions
#' results$responses
#' }
get_questionnaire = function(uid, api = NULL,
                             completed = NULL, since = NULL, until = NULL, offset = NULL,
                             limit = NULL, order_by = NULL) {
  api = get_api(api)
  url = paste0("https://api.typeform.com/v1/form/", uid, "?key=", api)

  ## Argument checking
  if(!is.null(completed)) {
    if(isTRUE(completed)) url = paste0(url, "&completed=true")
    else url = paste0(url, "&completed=false")
  }

  if(!is.null(since)) url = paste0(url, "&since=", get_linux_time(since))
  if(!is.null(until)) url = paste0(url, "&until=", get_linux_time(until))
  if(!is.null(offset)) url = paste0(url, "&offset=", offset)
  if(!is.null(limit)) url = paste0(url, "&limit=", limit)

  ## Form the REST URL & query
  url = paste0(url, get_order_by(order_by))

  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")
  resp = httr::GET(url, ua)
  cont = httr::content(resp, "text")
  check_api_response(resp)
  parsed = jsonlite::fromJSON(cont, simplifyVector = FALSE)

  ## Extract questions
  questions = purrr::map_df(parsed$questions, purrr::flatten_df)

  ## Extract completed
  q_keep = purrr::keep(parsed$responses, ~.$completed == 1)
  completed  = split_hidden(q_keep, questions)

  ## Extract non-completed
  q_keep = purrr::keep(parsed$responses, ~.$completed == 0)
  uncompleted  = split_hidden(q_keep, NULL)

  ## Return object
  structure(
    list(
      http_status = parsed$http_status,
      stats = parsed$stats$responses,
      questions = questions,
      completed = completed,
      uncompleted = uncompleted
    ),
    class = "rtypeform_results"
  )
}

#' @importFrom utils type.convert
#' @rdname get_questionnaire
#' @param stringsAsFactors default \code{FALSE}. When converting response, should
#' characters be treated as factors.
#' @export
get_results = function(uid, api = NULL,
                       completed = NULL, since = NULL, until = NULL, offset = NULL,
                       limit = NULL, order_by = NULL,
                       stringsAsFactors = FALSE) {
  .Deprecated("get_questionnaire") #nocov
  api = get_api(api) #nocov
  url = paste0("https://api.typeform.com/v1/form/", uid, "?key=", api) #nocov

  ## Argument checking
  if(!is.null(completed)) { #nocov
    if(isTRUE(completed)) url = paste0(url, "&completed=true") #nocov
    else url = paste0(url, "&completed=false") #nocov
  } #nocov

  if(!is.null(since)) url = paste0(url, "&since=", get_linux_time(since))  #nocov
  if(!is.null(until)) url = paste0(url, "&until=", get_linux_time(until)) #nocov
  if(!is.null(offset)) url = paste0(url, "&offset=", offset) #nocov
  if(!is.null(limit)) url = paste0(url, "&limit=", limit) #nocov

  ## Form the REST URL & query
  url = paste0(url , get_order_by(order_by)) #nocov

  ua = httr::user_agent("https://github.com/csgillespie/rtypeform") #nocov
  resp = httr::GET(url, ua) #nocov
  cont = httr::content(resp, "text") #nocov
  check_api_response(resp) #nocov

  parsed = jsonlite::fromJSON(cont) #nocov

  ## Convert arguments
  parsed$responses$answers = as.data.frame( #nocov
    lapply( #nocov
      parsed$responses$answers, function(x) type.convert(x, as.is = stringsAsFactors) #nocov
    ), stringsAsFactors = FALSE #nocov
  )  #nocov

  ## Return object
  structure( #nocov
    list(#nocov
      stats = parsed$stats, #nocov
      questions = parsed$questions, #nocov
      responses = parsed$responses, #nocov
      response = resp #nocov
    ), #nocov
    class = "rtypeform_results" #nocov
  )  #nocov
}


