test_that("Testing get_questionnaire_typeforms", {
  skip_on_cran()
  if (nchar(Sys.getenv("typeform_api2")) == 0) return(invisible(TRUE))
  form_id = get_forms()$form_id[1]
  form = get_responses(form_id = form_id)
  expect_s3_class(form$meta, "tbl_df")
  expect_equal(ncol(form$meta), 11)
})
