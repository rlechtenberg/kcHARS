#'Confirm no stateno invalidly-formatted
#'
#'@description Throws an error if the specified variable in the specified
#'  data frame contains any values that do no adhere to Washington State's
#'  formatting conventions for stateno and so appear to be invalid
#'
#'@param df A data frame
#'@param stateno_var name (unquoted) of a variable in `df` containing stateno
#'
#'@returns The input data frame `df` (if no invalid stateno are found)
#'@export
#'
#' @examples
#' read_ehars_person(col_select = stateno) |> assert_stateno_format_valid() |> View() # opens listing of stateno in R's Data Viewer
#' data.frame(stateno = c('12345')) |> assert_stateno_format_valid() |> View() # generates an error
#'
assert_stateno_format_valid <- function(df, stateno_var = stateno) {
  invalid_stateno <- df |>
    dplyr::distinct({{ stateno_var }}) |>
    dplyr::filter(
      !stringr::str_detect(
        string = {{ stateno_var }},
        pattern = "^(([0-9]{6}C?)|(A[0-9]{1,3}C?)|(B[0-9]{3,4}C?)|())$"
      )
    )

  if (nrow(invalid_stateno) > 0) {
    stop(paste(
      nrow(invalid_stateno),
      "distinct stateno appear to be invalid based on their format: ",
      paste0(invalid_stateno |> dplyr::pull({{ stateno_var }}), collapse = ", ")
    ))
  }
  return(df)
}

#'Re-add leading 0 to stateno where dropped (e.g., by Excel)
#'
#'@param df A data frame
#'@param stateno_var name (unquoted) of a variable in `df` containing stateno
#'
#'@returns The input data frame `df` with the leading 0 added back to 5-digit
#'  values of column `stateno_var`
#'@export
#'
#' @examples
#' data.frame(stateno = c("12345")) |> fix_5digit_stateno() # leading 0 added
fix_5digit_stateno <- function(df, stateno_var = stateno) {
  # if 5 digits, presumes a leading zero was dropped and re-adds it

  # identify if any stateno consist of just 5 digits
  stateno_missing_leading0 <- df |>
    dplyr::distinct({{ stateno_var }}) |>
    dplyr::filter(
      stringr::str_detect(
        string = {{ stateno_var }},
        pattern = "^[0-9]{5}C?$"
      )
    )

  # if so, warn the user that they exist and that leading zeros are presumed to have been dropped and will be re-added
  if (nrow(stateno_missing_leading0) > 0) {
    warning(
      paste(
        nrow(stateno_missing_leading0),
        'stateno appear to be missing a leading zero and will have it re-added:',
        paste(
          stateno_missing_leading0 |>
            dplyr::pull({{ stateno_var }}),
          collapse = ", "
        )
      ),
      immediate. = TRUE
    )

    # re-add the leading zero
    df <- df |>
      dplyr::mutate(
        {{ stateno_var }} := dplyr::if_else(
          stringr::str_detect(
            string = {{ stateno_var }},
            pattern = "^[0-9]{5}C?$"
          ),
          paste0('0', {{ stateno_var }}),
          {{ stateno_var }}
        )
      )
  }

  return(df)
}
