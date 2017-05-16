#' @export
print.rtypeform_results = function(x, ...) {
  cat("http_status:", x$http_status)
  cat("\nQuestion statistics:\n")
  cat("\t Total:", x$stats$total)
  cat("\n\t Completed:", x$stats$completed)
  cat("\n\t Uncompleted:", x$stats$total - x$stats$completed)
  cat("\n\t Response rate: ", signif(x$stats$completed/x$stats$total, 3)*100, "%", sep="")
  invisible(x)
}

