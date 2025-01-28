test_that("Testing teams", {
  skip_on_cran()
  # Hard coded for my system
  # Need a pro account
  if (nchar(Sys.getenv("typeform_api2_pro")) == 0) return(invisible(TRUE))

  api = Sys.getenv("typeform_api2_pro")
  no_of_teams = get_number_of_seats(api)
  expect_gte(no_of_teams, 1)

  teams = get_teams(api)
  expect_s3_class(teams, "tbl_df")
  expect_equal(ncol(teams), 3)
})
