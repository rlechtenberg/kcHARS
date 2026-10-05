df <- kcHARS::read_eoq_append(
  date = "2026-07-01",
  col_select = all_of(c("n_PLWA_cnty2025", "excludeP_2025"))
)

test_that("filter_KC_PLWH() generates an error if n_PLWA_cnty`yr` not found", {
  expect_error(df |> dplyr::select(-n_PLWA_cnty2025) |> filter_KC_PLWH(2025))
})

test_that("filter_KC_PLWH() generates warning if excpludeP_`yr` not found", {
  #
  expect_warning(
    df |> dplyr::select(-excludeP_2025) |> filter_KC_PLWH(2025) |> nrow()
  )
})

test_that("filter_KC_PLWH() reproduces count from 2026 epi report for KC PLWH at year-end 2025", {
  #
  expect_equal(df |> filter_KC_PLWH(2025) |> nrow(), 7657)
  expect_equal(df |> filter_KC_PLWH("2025") |> nrow(), 7657)
})
