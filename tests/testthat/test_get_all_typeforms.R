test_that("Testing get_all_typeforms", {
  skip_on_cran()
  if(Sys.getenv("TRAVIS_PULL_REQUEST") != "false") return(invisible(TRUE))

  typeforms = get_all_typeforms()
  expect_equal(ncol(typeforms$content), 2)
}
)

test_that("Testing error handling", {
  skip_on_cran()
  testthat::expect_error(get_all_typeforms(api="XXXX"))
}
)
