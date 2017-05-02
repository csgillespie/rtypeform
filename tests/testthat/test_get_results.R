test_that("Testing get_results_typeforms", {
  skip_on_cran()
  if(Sys.getenv("TRAVIS_PULL_REQUEST") != "false") return(invisible(TRUE))
  uid = "COBOws"
  res = get_results(uid)
  expect_true(is.list(res))
  expect_true(is.list(res$stats))
  expect_true(is.data.frame(res$questions))
  expect_true(is.data.frame(res$completed_responses))
  expect_true(is.data.frame(res$uncompleted_responses))

  no_completed = res$stats$completed
  total = res$stats$total

  ## Completed results
  Sys.sleep(1)# rate limit
  expect_equal(nrow(res$completed) + nrow(res$uncompleted), total)
  res = get_results(uid, completed = FALSE)
  expect_equal(nrow(res$completed) + nrow(res$uncompleted), total - no_completed)

  res = get_results(uid, completed = TRUE)
  expect_equal(nrow(res$completed) + nrow(res$uncompleted), no_completed)

  ## since = NULL, until = NULL,
  #Sys.sleep(1)# rate limit


  ## offset = NULL
  Sys.sleep(1)# rate limit
  offset = 5
  res = get_results(uid, offset = offset)
  expect_equal(nrow(res$completed) + nrow(res$uncompleted), total - offset)

  ## limit = NULL
  limit = 5
  res = get_results(uid, limit = limit)
  expect_equal(nrow(res$completed) + nrow(res$uncompleted), limit)

  ## order_by = NULL


  }
)
