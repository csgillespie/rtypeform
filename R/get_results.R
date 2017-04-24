get_linux_time = function(x) {
  if(class(x) == "Date") x = as.POSIXct(x)
  if(any(class(x) %in% c("POSIXct","POSIXt"))) x = as.numeric(x)
  x
}

get_order_by = function(order_by) {
  if(is.null(order_by)) return("")

  order_bys = c("completed", "date_land_desc", "date_land_incr",
                "date_submit_desc", "date_submit_incr")
  if(!(order_by %in% order_bys))
    stop("order_by should be one of:\n", paste(order_bys, collapse = "\n"))

  end = switch(order_by,
               completed="completed",
               date_land_desc = "[date_land,desc]",
               date_land_incr = "date_land",
               date_submit_desc = "[date_submit,desc]",
               date_submit_incr = "date_submit")
  paste0("&order_by=", end)
}

#' Download questionnaire results
#'
#' Download results for a particular typeform questionnaire.
#' @inheritParams get_all_typeforms
#' @param uid The UID (unique identifier) of the typeform you want the results for.
#' @param completed, default \code{NULL}, return all results.
#' Fetch only completed results (\code{TRUE}), or only not-completed results
#' (=\code{FALSE}). If \code{NULL} return all results.
#' @param since, default \code{NULL}. Fetch only the results after a specific date and
#' time. If \code{NULL} return all results.
#' @param until, default \code{NULL}. Fetch only the results before a specific date and
#' time. If \code{NULL} return all results.
#' @param offset Fetch all results except the first \code{offset}.
#' i.e. Start listing results from result #\code{offset} onwards.
#' @param limit, default \code{NULL}. Fetch only \code{limit} results.
#' If \code{NULL} return all results.
#' @param order_by One of "completed", "date_land_desc", "date_land_incr",
#' "date_submit_desc", or "date_submit_incr".
#' @param stringsAsFactors default \code{FALSE}. When converting response, should
#' characters be treated as factors.
#' @return A list containing questions, stats, responses and http response.
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
get_results = function(uid, api = NULL,
                       completed = NULL, since = NULL, until = NULL, offset = NULL,
                       limit = NULL, order_by = NULL,
                       stringsAsFactors = FALSE) {
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
  url = paste0(url , get_order_by(order_by))

  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")
  resp = httr::GET(url, ua)
  cont = httr::content(resp, "text")
  check_api_response(resp, cont)

  parsed = jsonlite::fromJSON(cont)

  ## Convert arguments
  parsed$responses$answers = as.data.frame(
    lapply(
      parsed$responses$answers, function(x) type.convert(x, as.is = stringsAsFactors)
      ), stringsAsFactors = FALSE
  )

  ## Return object
  structure(
    list(
      stats = parsed$stats,
      questions = parsed$questions,
      responses = parsed$responses,
      response = resp
    ),
    class = "rtypeform_results"
  )
}

