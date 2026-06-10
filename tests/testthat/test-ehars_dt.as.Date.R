test_that("conversion of complete dates works", {
  expect_equal(ehars_dt.as.Date("20191231"), as.Date("2019-12-31"))
})

test_that("imputation works", {
  expect_equal(ehars_dt.as.Date("........"), as.Date(NA))

  expect_equal(ehars_dt.as.Date("2019...."), as.Date("2019-06-30"))
  expect_equal(
    ehars_dt.as.Date("2019....", ....to = "0615"),
    as.Date("2019-06-15")
  )

  expect_equal(ehars_dt.as.Date("201901.."), as.Date("2019-01-15"))
  expect_equal(
    ehars_dt.as.Date("201901..", ..to = "01"),
    as.Date("2019-01-01")
  )
})

#' @param x A character vector of eHARS-style date values: 'YYYYMMDD' with
#'   missing day/month+day/date specified as '..'/'....'/'........'.
#' @param ..to Two-digit (zero-padded, as needed) character value specifying the
#'   day to impute, where missing. Defaults to '15'.
#' @param ....to Four-digit (zero-padded, as needed) character value specifying the
#'   month+day to impute, where missing. Defaults to '0630'.

test_that("validation of x works", {
  expect_error(ehars_dt.as.Date(x = "201901..."))
  expect_error(ehars_dt.as.Date(x = "201901."))
  expect_error(ehars_dt.as.Date(x = "2019..01"))
  expect_error(ehars_dt.as.Date(x = "201901.. "))
})

test_that("validation of ..to works", {
  expect_error(ehars_dt.as.Date(x = "201901..", ..to = 01))
  expect_error(ehars_dt.as.Date(x = "201901..", ..to = '1'))
  expect_error(ehars_dt.as.Date(x = "201901..", ..to = '00'))
  expect_error(ehars_dt.as.Date(x = "201901..", ..to = '32'))
})

test_that("validation of ....to works", {
  expect_error(ehars_dt.as.Date(x = "2019....", ....to = 0101))
  expect_error(ehars_dt.as.Date(x = "2019....", ....to = '101'))

  # bad day
  expect_error(ehars_dt.as.Date(x = "2019....", ....to = '0100'))
  expect_error(ehars_dt.as.Date(x = "2019....", ....to = '0132'))

  # bad month
  expect_error(ehars_dt.as.Date(x = "2019....", ....to = '0015'))
  expect_error(ehars_dt.as.Date(x = "2019....", ....to = '1315'))
})
