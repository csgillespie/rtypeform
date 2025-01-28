test_that("Testing get_forms", {
  skip_on_cran()
  if (nchar(Sys.getenv("typeform_api2")) == 0) return(invisible(TRUE))

  no_of_forms = get_number_of_forms()
  expect_gte(no_of_forms, 1)

  forms = get_forms(page_size = 200)
  expect_equal(nrow(forms), min(no_of_forms, 200))
  expect_equal(ncol(forms), 11L)
  expect_s3_class(forms, "tbl_df")

  expect_error(get_forms(api = "XXX"), regexp = "403")
}
)
