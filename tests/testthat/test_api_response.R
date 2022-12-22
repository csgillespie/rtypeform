test_that("Testing api response", {
  skip_on_cran()
  expect_error(get_forms("XXX"), regexp = "403")
}
)

test_that("Testing get_api", {
  skip_on_cran()
  api2 = Sys.getenv("typeform_api2", "an_api_test_key")
  expect_equal(get_api(), Sys.getenv("typeform_api2"))
  Sys.unsetenv("typeform_api2")

  expect_error(get_api())
  Sys.setenv("typeform_api" = 10)

  expect_error(get_api(), regexp = "Old")
  expect_equal(get_api("test"), "test")

  Sys.setenv("typeform_api2" = api2)

})
