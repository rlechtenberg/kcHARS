# construct_cache_file_path ----

withr::with_options(list(kcHARS.ehars_dt = "2025-07-01"), {
  test_that("construct_cache_file_path() works", {
    test_fun <- function(x = 1, y = 2, z = 3) {
      construct_cache_file_path()
    }

    # use all defaults
    expect_equal(
      test_fun(),
      "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/test_fun__x_1__y_2__z_3.rds"
    )

    # override one default
    expect_equal(
      test_fun(x = 2),
      "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/test_fun__x_2__y_2__z_3.rds"
    )

    # one argument is NA
    expect_equal(
      test_fun(x = 2, z = NA_character_),
      "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/test_fun__x_2__y_2__z_NA.rds"
    )

    # argument contains characters not allowed in Windows file names
    expect_equal(
      test_fun(x = 1, y = '3:*?"<>|', z = 3),
      "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/test_fun__x_1__y_3_________z_3.rds"
    )

    # get name and args for function calling the calling function
    test_inner_fun <- function(x, y, z) {
      construct_cache_file_path(n_frames_up = 2)
    }

    test_outer_fun <- function(x = 1, y = 2, z = 3) {
      test_inner_fun(x, y, z)
    }
    expect_equal(
      test_outer_fun(),
      "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/test_outer_fun__x_1__y_2__z_3.rds"
    )
    expect_equal(
      test_outer_fun(x = "a", y = "b", z = "c"),
      "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/test_outer_fun__x_a__y_b__z_c.rds"
    )
  })
})

# write_to_cache ----

withr::with_options(list(kcHARS.ehars_dt = "2025-07-01"), {
  temp_fun <- function(n, cache) {
    df <- data.frame(x = 1:n)
    write_to_cache(x = df, cache = cache)
    return(df)
  }

  # cache has invalid value
  expect_error(write_to_cache(cache = TRUE))

  # when cache == "use" and neither dir nor file exist, create dir and file
  expect_true(
    !dir.exists(
      "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived"
    )
  )
  df <- temp_fun(10, cache = "use")
  expect_true(
    file.exists(
      "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/temp_fun__n_10.rds"
    )
  )

  # when cache == "use" and dir exists but file doesn't, create file
  expect_true(
    !file.exists(
      "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/temp_fun__n_100.rds"
    )
  )
  df <- temp_fun(100, cache = "use")
  expect_true(
    file.exists(
      "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/temp_fun__n_100.rds"
    )
  )

  # when cache == "use" and file exists, do nothing
  orig_mtime <- file.info(
    "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/temp_fun__n_100.rds"
  )$mtime
  # sleep for 2 seconds, ensuring that if the below overwrite the file already
  # created, it would have a different (more recent) value for mtime
  Sys.sleep(2)
  df <- temp_fun(100, cache = "use")

  new_mtime <- file.info(
    "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/temp_fun__n_100.rds"
  )$mtime
  expect_equal(orig_mtime, new_mtime)

  # when cache == "overwrite", overwrite file
  orig_mtime <- file.info(
    "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/temp_fun__n_100.rds"
  )$mtime
  # sleep for 2 seconds, ensuring that if the below overwrite the file already
  # created, it would have a different (more recent) value for mtime
  Sys.sleep(2)
  df <- temp_fun(100, cache = "overwrite")

  new_mtime <- file.info(
    "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived/temp_fun__n_100.rds"
  )$mtime
  expect_gt(new_mtime, orig_mtime)

  unlink(
    "//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/2025-07-01/derived",
    recursive = TRUE
  )
})
