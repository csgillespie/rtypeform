#' @export
print.rtypeform_all = function(x, ...) {
  print(x$content)
  cat("\nhttp_status:", x$http_status, "OK")
  cat("\n", nrow(x$content), "questionnaires")
  invisible(x)
}

#' @export
print.rtypeform_results = function(x, ...) {
  cat("http_status:", x$http_status, "OK")
  cat("\nQuestion statistics:")
  cat("\n\t\t Questions:", sum(!grepl("hidden", x$questions$id)))
  cat("\n\t\t Hidden:", sum(grepl("hidden", x$questions$id)))
  cat("\n\t Responses:", x$stats$total)
  cat("\n\t\t Completed:", x$stats$completed)
  cat("\n\t\t Uncompleted:", x$stats$total - x$stats$completed)
  cat("\n\t\t Response rate: ", signif(x$stats$completed/x$stats$total, 3)*100, "%", sep="")
  cat("\n")
  invisible(x)
}
