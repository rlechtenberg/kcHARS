# calc_gender ----

test_that("calc_gender() fails with bad inputs", {
  expect_error(
    read_ehars_person(col_select = c(LF_TRANS, LF_GENDER, LF_GENDER_OTHER)) |>
      calc_gender()
  )

  expect_error(
    read_ehars_person(col_select = c(sex, LF_GENDER, LF_GENDER_OTHER)) |>
      calc_gender()
  )

  expect_error(
    read_ehars_person(col_select = c(sex, LF_TRANS, LF_GENDER_OTHER)) |>
      calc_gender()
  )

  expect_error(
    read_ehars_person(col_select = c(sex, LF_TRANS, LF_GENDER)) |>
      calc_gender()
  )

  expect_error(
    read_ehars_person(col_select = c(sex, LF_TRANS, LF_GENDER)) |>
      calc_gender(n_cat = 2)
  )

  expect_error(
    read_ehars_person(
      col_select = c(sex, LF_TRANS, LF_GENDER, LF_GENDER_OTHER)
    ) |>
      dplyr::mutate(sex = ifelse(sex == "F", "W", sex)) |>
      calc_gender()
  )
})

test_that("calc_gender() only adds two variables to `df`", {
  expect_equal(
    read_ehars_person(
      col_select = c(sex, LF_TRANS, LF_GENDER, LF_GENDER_OTHER)
    ) |>
      calc_gender() |>
      names(),
    c(
      "sex",
      "LF_TRANS",
      "LF_GENDER",
      "LF_GENDER_OTHER",
      "transgender_ever",
      "gender"
    )
  )
})

test_that("calc_gender() calculations work", {
  # generate test data with all possible combinations of inputs
  # dplyr::distinct(read_ehars_person(col_select = sex)) |>
  #   dplyr::cross_join(dplyr::distinct(read_ehars_person(col_select = LF_TRANS))) |>
  #   dplyr::cross_join(dplyr::distinct(read_ehars_person(col_select = LF_GENDER))) |>
  #   dplyr::cross_join(data.frame(LF_GENDER_OTHER = c("", "SOMETHING"))) |>
  #   saveRDS(testthat::test_path("testdata", "calc_gender_testdata.rds"))

  output <- readRDS(testthat::test_path(
    "testdata",
    "calc_gender_testdata.rds"
  )) |>
    calc_gender()
  # output |> write.csv(testthat::test_path("testdata", "tmp.csv")) # review manually just once

  expect_snapshot_value(output, style = "json2")

  output3 <- readRDS(testthat::test_path(
    "testdata",
    "calc_gender_testdata.rds"
  )) |>
    calc_gender(n_cat = 3)
  # output3 |> write.csv(testthat::test_path("testdata", "tmp.csv")) # review manually just once

  expect_snapshot_value(output3, style = "json2")
})

test_that("calc_race_eth_vars() calculations work", {
  # generate test data with all possible combinations of inputs
  # races <- data.frame(race = c("R1", "R2", 'R3', 'R4', 'R5', "UNK", ''))
  # dplyr::rename(races, race1 = race) |>
  #   dplyr::cross_join(dplyr::rename(races, race2 = race)) |>
  #   dplyr::cross_join(dplyr::rename(races, race3 = race)) |>
  #   dplyr::cross_join(dplyr::rename(races, race4 = race)) |>
  #   dplyr::cross_join(dplyr::rename(races, race5 = race)) |>
  #   dplyr::cross_join(data.frame(ethnicity1 = c("E1", "E2", "UNK", ''))) |>
  #   saveRDS(testthat::test_path("testdata", "calc_race_eth_vars_testdata.rds"))

  output <- readRDS(testthat::test_path(
    "testdata",
    "calc_race_eth_vars_testdata.rds"
  )) |>
    calc_race_eth_vars()
  # output |> write.csv(testthat::test_path("testdata", "tmp.csv")) # review manually just once

  expect_snapshot_value(output, style = "json2")
})

test_that("calc_nativity() calculations work", {
  # read_ehars_person(col_select = "birth_country_cd") |>
  #   dplyr::distinct() |>
  #   saveRDS(testthat::test_path("testdata", "calc_nativity_testdata.rds"))

  output <- readRDS(testthat::test_path(
    "testdata",
    "calc_nativity_testdata.rds"
  )) |>
    calc_nativity()
  # output |> write.csv(testthat::test_path("testdata", "tmp.csv")) # review manually just once

  expect_snapshot_value(output, style = "json2")
})

test_that("calc_age_groups() calculations work", {
  # read_ehars_person(col_select = c(hiv_aids_age_yrs)) |>
  #   dplyr::distinct() |>
  #   cbind(
  #     data.frame(
  #       dob = seq.Date(
  #         from = as.Date("1900-01-01"),
  #         to = as.Date("2026-09-09"),
  #         by = 1
  #       ) |>
  #         as.character() |>
  #         stringr::str_remove_all("-")
  #     ) |>
  #       dplyr::slice_sample(n = 86)
  #   ) |>
  #   saveRDS(testthat::test_path("testdata", "calc_age_groups_testdata.rds"))

  output <- readRDS(testthat::test_path(
    "testdata",
    "calc_age_groups_testdata.rds"
  )) |>
    calc_age_groups(cur_age_as_of = as.Date("2026-09-14"))
  # output |> write.csv(testthat::test_path("testdata", "tmp.csv")) # review manually just once

  expect_snapshot_value(output, style = "json2")
})

test_that("calc_trans_categ() calculations work", {
  # read_ehars_person(
  #   col_select = dplyr::all_of(c(
  #     'trans_categ',
  #     'sex_male',
  #     'sex_female',
  #     'idu',
  #     'sex',
  #     "LF_TRANS",
  #     "LF_GENDER",
  #     "LF_GENDER_OTHER"
  #   ))
  # ) |>
  #   dplyr::distinct() |>
  #   calc_gender() |>
  #   dplyr::select(-transgender_ever) |>
  #   calc_trans_categ() |>
  #   saveRDS(testthat::test_path("testdata", "calc_trans_categ_testdata.rds"))

  output <- readRDS(testthat::test_path(
    "testdata",
    "calc_trans_categ_testdata.rds"
  )) |>
    calc_trans_categ() |>
    dplyr::distinct(
      gender,
      sex_male,
      sex_female,
      idu,
      trans_categ,
      trans_categ_exp,
      msm
    )
  # output |> write.csv(testthat::test_path("testdata", "tmp.csv")) # review manually just once

  expect_snapshot_value(output, style = "json2")
})
