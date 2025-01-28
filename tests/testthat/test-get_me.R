test_that("multiplication works", {
  skip_on_cran()
  if (nchar(Sys.getenv("typeform_api2")) == 0) return(invisible(TRUE))
  expect_length(get_me(), 4)
})
