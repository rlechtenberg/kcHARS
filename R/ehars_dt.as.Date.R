#'Convert eHARS-style dates from character to date values
#'
#'@description Convert eHARS-style dates ('YYYYMMDD' with missing
#'  day/month+day/date specified as '..'/'....'/'........') from character to
#'  date values. '........' are converted to NAs.
#'
#'@param x A character vector of eHARS-style date values: 'YYYYMMDD' with
#'  missing day/month+day/date specified as '..'/'....'/'........'.
#'@param ..to Two-digit (zero-padded, as needed) character value specifying the
#'  day to impute, where missing. Defaults to '15'.
#'@param ....to Four-digit (zero-padded, as needed) character value specifying
#'  the month+day to impute, where missing. Defaults to '0630'.
#'
#'@returns A vector of class `Date`
#'@export
#'
#' @examples
#' ehars_dt.as.Date("20191231")
#' ehars_dt.as.Date("201901..")
#' ehars_dt.as.Date("201901..", ..to = '01')
#' ehars_dt.as.Date("2019....")
#' ehars_dt.as.Date("2019....", ....to = '0615')

ehars_dt.as.Date <- function(
  x,
  ..to = "15",
  ....to = "0630"
) {
  # validate inputs
  checkmate::assert_character(
    x,
    pattern = "^(([0-9]{8})|([0-9]{6}\\.{2})|([0-9]{4}\\.{4})|(\\.{8}))$"
  )

  checkmate::assert_character(..to, pattern = "^[0-9]{2}$")
  checkmate::assert_numeric(as.integer(..to), lower = 1, upper = 31)

  checkmate::assert_character(....to, pattern = "^[0-9]{4}$")
  checkmate::assert_numeric(
    stringr::str_sub(....to, 1, 2) |> as.integer(),
    lower = 1,
    upper = 12
  )
  checkmate::assert_numeric(
    stringr::str_sub(....to, 3, 4) |> as.integer(),
    lower = 1,
    upper = 31
  )

  # impute missing dateparts, if any
  x <- dplyr::case_when(
    stringr::str_detect(x, pattern = "\\.{8}") ~ NA_character_,
    stringr::str_detect(x, pattern = "[0-9]{6}\\.{2}") ~ paste0(
      stringr::str_sub(x, 1, 6),
      ..to
    ),
    stringr::str_detect(x, pattern = "[0-9]{4}\\.{4}") ~ paste0(
      stringr::str_sub(x, 1, 4),
      ....to
    ),
    TRUE ~ x
  )

  x <- as.Date(
    paste(
      sep = "-",
      stringr::str_sub(x, 1, 4),
      stringr::str_sub(x, 5, 6),
      stringr::str_sub(x, 7, 8)
    ),
    format = '%Y-%m-%d'
  )

  return(x)
}
