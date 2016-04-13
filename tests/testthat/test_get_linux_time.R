test_that("Testing get_linux_time", {
  skip_on_cran()
  x = as.Date("1970-03-01")
  expect_equal(rtypeform:::get_linux_time(x), 5097600)
}
)
