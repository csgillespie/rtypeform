test_that("Testing print method", {
  skip_on_cran()
  if(nchar(Sys.getenv("typeform_api")) == 0) return(invisible(TRUE))
  uid = "COBOws"
  all_typeforms = get_all_typeforms()
  expect_identical(print(all_typeforms), all_typeforms)
  res = get_questionnaire(uid)
  expect_identical(print(res), res)

})
