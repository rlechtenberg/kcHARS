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

test_that("calc_KingCo_region() calculations work", {
  # reproduce the calculations performed within SAS for the 2026 epi report
  eoq_append <- read_eoq_append(
    date = "2026-07-01",
    col_select = c(
      ehars_uid,
      res_region_inc,
      rsd_zip_cd,
      rsd_county_name,
      rsd_state_cd,
      rsd_unstably_housed,

      res_region_dth,
      rad_zip_cd,
      rad_county_name,
      rad_state_cd,
      rad_unstably_housed,

      res_region_prev,
      n_PLWA_zip2025,
      n_PLWA_cnty2025,
      n_PLWA_state2025,
      unstably_housed_2025
    )
  ) |>
    dplyr::filter(ehars_uid != 'WA00S001465868-4')
  # b/c this person manually re-classified on the basis of an update to eHARS
  # after the data were frozen for analysis

  output <- eoq_append |>
    dplyr::rename(
      res_region_inc_BASE = res_region_inc,
      res_region_dth_BASE = res_region_dth,
      res_region_prev_BASE = res_region_prev
    ) |>
    calc_KingCo_region(
      region_var = "res_region_inc",
      zip_cd_var = "rsd_zip_cd",
      county_name_var = "rsd_county_name",
      state_cd_var = "rsd_state_cd",
      hml_var = "rsd_unstably_housed"
    ) |>
    calc_KingCo_region(
      region_var = "res_region_dth",
      zip_cd_var = "rad_zip_cd",
      county_name_var = "rad_county_name",
      state_cd_var = "rad_state_cd",
      hml_var = "rad_unstably_housed"
    ) |>
    calc_KingCo_region(
      region_var = "res_region_prev",
      zip_cd_var = "n_PLWA_zip2025",
      county_name_var = "n_PLWA_cnty2025",
      state_cd_var = "n_PLWA_state2025",
      hml_var = "unstably_housed_2025"
    )

  expect_equal(
    output |>
      dplyr::filter(res_region_inc_BASE != res_region_inc) |>
      nrow(),
    0
  )

  expect_equal(
    output |>
      dplyr::filter(res_region_prev_BASE != res_region_prev) |>
      nrow(),
    0
  )

  # see_diffs <- function(varname, pattern) {
  #   stopifnot(is.character(varname) & length(varname) == 1)
  #
  #   base_varname <- paste0(varname, "_BASE")
  #
  #   y <- output |>
  #     dplyr::select(c(
  #       matches(pattern),
  #       all_of(c(paste0(varname, "_ZIP_ONLY"), varname, base_varname))
  #     )) |>
  #     dplyr::mutate(
  #       diff = ifelse(.data[[base_varname]] != .data[[varname]], 'X', '')
  #     )
  #
  #   diffs <- y |>
  #     dplyr::filter(diff == 'X') |>
  #     dplyr::reframe(.by = dplyr::everything(), n = dplyr::n()) |>
  #     dplyr::arrange(.data[[varname]], .data[[base_varname]])
  #
  #   y |>
  #     dplyr::reframe(
  #       .by = c(.data[[base_varname]], .data[[varname]], diff),
  #       n = dplyr::n()
  #     ) |>
  #     View("N's")
  #
  #   if (nrow(diffs) > 0) {
  #     View(diffs, "Diffs")
  #   }
  # }
  #
  # see_diffs(varname = "res_region_inc", pattern = "rsd_.+")
  # see_diffs(varname = "res_region_prev", pattern = "n_PLWA_.+")
  # see_diffs(varname = "res_region_dth", pattern = "rad_.+")

  # x <- rbind(
  #   output |>
  #     dplyr::transmute(
  #       state_cd = rsd_state_cd,
  #       county_name = rsd_county_name,
  #       zip_cd = rsd_zip_cd,
  #       hml = rsd_unstably_housed,
  #       region = res_region_inc,
  #       region_adjusted = ifelse(
  #         res_region_inc != res_region_inc_ZIP_ONLY,
  #         'X',
  #         ''
  #       ),
  #       region_ZIP_ONLY = ifelse(
  #         region_adjusted == 'X',
  #         res_region_inc_ZIP_ONLY,
  #         ''
  #       )
  #     ),
  #   output |>
  #     dplyr::transmute(
  #       state_cd = rad_state_cd,
  #       county_name = rad_county_name,
  #       zip_cd = rad_zip_cd,
  #       hml = rad_unstably_housed,
  #       region = res_region_dth,
  #       region_adjusted = ifelse(
  #         res_region_dth != res_region_dth_ZIP_ONLY,
  #         'X',
  #         ''
  #       ),
  #       region_ZIP_ONLY = ifelse(
  #         region_adjusted == 'X',
  #         res_region_dth_ZIP_ONLY,
  #         ''
  #       )
  #     ),
  #   output |>
  #     dplyr::transmute(
  #       state_cd = n_PLWA_state2025,
  #       county_name = n_PLWA_cnty2025,
  #       zip_cd = n_PLWA_zip2025,
  #       hml = unstably_housed_2025,
  #       region = res_region_prev,
  #       region_adjusted = ifelse(
  #         res_region_prev != res_region_prev_ZIP_ONLY,
  #         'X',
  #         ''
  #       ),
  #       region_ZIP_ONLY = ifelse(
  #         region_adjusted == 'X',
  #         res_region_prev_ZIP_ONLY,
  #         ''
  #       )
  #     )
  # ) |>
  #   # abstract state, county, and zip into meaningfully different higher-level
  #   # categories to facilitate review
  #   dplyr::mutate(
  #     state_cd = state_cd |>
  #       dplyr::recode_values(
  #         '' ~ NA_character_,
  #         'WA' ~ 'WA',
  #         'FC' ~ 'Other Country',
  #         default = 'non-WA'
  #       ),
  #     county_name = county_name |>
  #       dplyr::recode_values(
  #         '' ~ NA_character_,
  #         'KING CO.' ~ 'KING CO.',
  #         default = 'non-KING CO.'
  #       ),
  #     zip_cd = zip_cd |>
  #       stringr::str_replace_all(pattern = "[0-9]", '#')
  #   ) |>
  #   dplyr::reframe(.by = dplyr::everything(), n = dplyr::n())

  # View(x)
})
