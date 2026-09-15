test_that("invalid stateno generate an error", {
  expect_error(
    data.frame(stateno = c("12345")) |> assert_stateno_format_valid()
  )

  expect_error(
    data.frame(bp_stateno = c("12345")) |>
      assert_stateno_format_valid(stateno_var = bp_stateno)
  )
})

test_that("`df` returned unchanged (and without error) when all stateno valid", {
  valid_stateno <- data.frame(
    stateno = c(
      "123456",
      "123456C",
      "A1",
      "A12",
      "A123",
      "A1C",
      "A12C",
      "A123C",
      "B123",
      "B1234",
      "B123C",
      "B1234C",
      ""
    )
  )

  expect_equal(
    valid_stateno |>
      assert_stateno_format_valid(),
    valid_stateno
  )

  # works with other columns containing stateno but not named `stateno`
  expect_equal(
    valid_stateno |>
      dplyr::rename(bp_stateno = stateno) |>
      assert_stateno_format_valid(stateno_var = bp_stateno),
    valid_stateno |>
      dplyr::rename(bp_stateno = stateno)
  )
})


test_that("5-digit stateno have a leading 0 added", {
  expect_warning(
    expect_equal(
      data.frame(stateno = c("12345")) |> fix_5digit_stateno(),
      data.frame(stateno = c("012345"))
    )
  )

  # works with other columns containing stateno but not named `stateno`
  expect_warning(
    expect_equal(
      data.frame(bp_stateno = c("12345")) |>
        fix_5digit_stateno(stateno_var = bp_stateno),
      data.frame(bp_stateno = c("012345"))
    )
  )
})

test_that("Validly-formatted stateno are unchanged", {
  valid_stateno <- data.frame(
    stateno = c(
      "123456",
      "123456C",
      "A1",
      "A12",
      "A123",
      "A1C",
      "A12C",
      "A123C",
      "B123",
      "B1234",
      "B123C",
      "B1234C",
      ""
    )
  )

  expect_equal(
    valid_stateno |>
      fix_5digit_stateno(),
    valid_stateno
  )

  # works with other columns containing stateno but not named `stateno`
  expect_equal(
    valid_stateno |>
      dplyr::rename(bp_stateno = stateno) |>
      fix_5digit_stateno(stateno_var = bp_stateno),
    valid_stateno |>
      dplyr::rename(bp_stateno = stateno)
  )
})
