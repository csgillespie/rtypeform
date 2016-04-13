test_that("Testing get_results_typeforms", {
  skip_on_cran()
  uid = "o99fIa"
  res = get_results(uid)
  expect_true(is.list(res))
  expect_true(is.list(res$stats))
  expect_true(is.data.frame(res$responses))
  expect_true(is.data.frame(res$questions))


  }
)
