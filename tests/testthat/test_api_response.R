test_that("Testing api response", {

  res = httr::GET(url = "http://httpbin.org/status/400")
  expect_error(check_api_response(res), regexp = "Invalid date in query")

  res = httr::GET(url = "http://httpbin.org/status/403")
  expect_error(check_api_response(res), regexp = "Expired token, invalid token")

  res = httr::GET(url = "http://httpbin.org/status/404")
  expect_error(check_api_response(res), regexp = "Invalid typeform id")

  res = httr::GET(url = "http://httpbin.org/status/405")
  expect_error(check_api_response(res), regexp = "rtypeform API request failed")
}
)
