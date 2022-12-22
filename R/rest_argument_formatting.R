format_date_time = function(date_time) {
  if (is.null(date_time)) return(NULL)
  obj_name = deparse(substitute(date_time))
  if (!lubridate::is.POSIXct(date_time)) {
    stop(obj_name, " is not a date time object", call. = FALSE)
  }
  if (lubridate::tz(date_time) != "UTC") {
    message("Converting ", obj_name, "'s timezone to UTZ.")
    date_time = lubridate::with_tz(date_time, "UTC")
  }
  gsub(pattern = " ", "T", as.character(date_time))
}

create_argument = function(arg) {
  if (is.null(arg) || nchar(arg) == 0) return("")
  obj_name = deparse(substitute(arg)) # nolint
  glue::glue("{obj_name}={arg}")
}

format_completed = function(completed) {
  if (is.null(completed)) return(NULL)
  if (completed) "true" else "false"
}
