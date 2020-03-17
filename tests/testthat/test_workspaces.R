test_that("Testing teams", {
  skip_on_cran()
  # Hard coded for my system
  # Need a pro account
  if (nchar(Sys.getenv("typeform_api2_pro")) == 0) return(invisible(TRUE))
  w_old = get_workspaces()
  expect_gte(nrow(w_old), 1)
  ## Test create
  new_workspace = create_workspace("new workspace")
  w_new = get_workspaces()
  expect_equal(nrow(w_old) + 1, nrow(w_new))

  ## Test delete
  delete_workspace(new_workspace$id)
  w_new = get_workspaces()
  expect_equal(nrow(w_old), nrow(w_new))

})
