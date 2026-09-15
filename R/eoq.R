#' Read EOQ datasets (eoqrep_<YYYYMM>_newcr) into R
#'
#' @param YYYYMM 6-digit character value specifying the year and month of the
#'   dataset (e.g., "202607"). If NULL (the default), the latest EOQ dataset is
#'   read
#' @param ... Optional parameters passed to haven::read_sas()
#'
#' @returns A data frame
#' @export
#'
#' @examples
#' read_eoq(col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#' read_eoq(YYYYMM = "202607", col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#' read_eoq(YYYYMM = "202511", col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#' read_eoq(YYYYMM = "190001", col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()

read_eoq <- function(YYYYMM = NULL, ...) {
  stopifnot(is.null(YYYYMM) | stringr::str_detect(YYYYMM, "[0-9]{6}"))

  eoq_dir_path <- '//dphcifs/Prevention/HIV/Epi/surv/EOQ'

  if (is.null(YYYYMM)) {
    # get name of latest eoq dataset
    fn <- list.files(path = eoq_dir_path) |>
      tolower() |>
      stringr::str_subset("eoqrep_[0-9]{6}_newcr\\.sas7bdat") |>
      max()

    eoq_file_path <- file.path(
      '//dphcifs/Prevention/HIV/Epi/surv/EOQ',
      fn
    )
  } else if (
    stringr::str_sub(YYYYMM, 1, 4) == stringr::str_sub(Sys.Date(), 1, 4) # requesting an earlier dataset from this year
  ) {
    eoq_file_path <- file.path(
      '//dphcifs/Prevention/HIV/Epi/surv/EOQ',
      paste0("eoqrep_", YYYYMM, "_newcr.sas7bdat")
    )
  } else if (
    stringr::str_sub(YYYYMM, 1, 4) != stringr::str_sub(Sys.Date(), 1, 4) # requesting an earlier dataset from this year) # requesting a dataset from an earlier year
  ) {
    eoq_file_path <- file.path(
      '//dphcifs/Prevention/HIV/Epi/surv/EOQ',
      paste0("Eoq", stringr::str_sub(YYYYMM, 1, 4)),
      paste0("eoqrep_", YYYYMM, "_newcr.sas7bdat")
    )
  }

  if (!file.exists(eoq_file_path)) {
    (stop(paste0("Could not find an EOQ dataset for ", YYYYMM)))
  }

  haven::read_sas(
    data_file = eoq_file_path,
    catalog_file = "//dphcifs/prevention/HIV/Epi/surv/EHARS/Reference Documents/Current Reference Materials/eharsfmt_32.sas7bcat",
    ...
  )
}
