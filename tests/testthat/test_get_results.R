test_that("Testing get_questionnaire_typeforms", {
  skip_on_cran()
  if(nchar(Sys.getenv("typeform_api")) == 0) return(invisible(TRUE))
  uid = "COBOws"
  res = get_questionnaire(uid)
  expect_true(is.list(res))
  expect_true(is.list(res$stats))
  expect_true(is.data.frame(res$questions))
  expect_true(is.data.frame(res$completed))
  expect_true(is.data.frame(res$uncompleted))

  no_completed = res$stats$completed
  total = res$stats$total

  ## Completed results
  Sys.sleep(1.5 + runif(1))# rate limit
  expect_equal(nrow(res$completed) + nrow(res$uncompleted), total)
  res = get_questionnaire(uid, completed = FALSE)
  expect_equal(nrow(res$completed) + nrow(res$uncompleted), total - no_completed)

  res = get_questionnaire(uid, completed = TRUE)
  expect_equal(nrow(res$completed) + nrow(res$uncompleted), no_completed)

  ## since = NULL, until = NULL,
  Sys.sleep(1)# rate limit


  ## offset = NULL
  # Sys.sleep(1.5 + runif(1))# rate limit
  # offset = 100
  # res = get_questionnaire(uid, offset = offset)
  # expect_equal(nrow(res$completed) + nrow(res$uncompleted), total - offset)

  ## limit = NULL
  limit = 5
  res = get_questionnaire(uid, limit = limit)
  expect_equal(nrow(res$completed) + nrow(res$uncompleted), limit)

  ## order_by = NULL
  expect_error(get_questionnaire(uid, order_by = "XXXX"))


  }
)
