#' Read EOQ datasets (eoqrep_<YYYYMM>_newcr) into R
#'
#' @param date Character string specifying the date of the eoq_append dataset to
#'   read (formatted as YYYY-MM-DD)
#' @param ... Optional parameters passed to haven::read_sas()
#'
#' @returns A data frame
#' @export
#'
#' @examples
#' read_eoq_append(col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#' read_eoq_append(date = "2026-07-01", col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#' read_eoq_append(date = "2024-04-08", col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#' read_eoq_append(date = "1900-07-01", col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()

read_eoq_append <- function(date = NULL, ...) {
  stopifnot(
    is.null(date) | stringr::str_detect(date, "[0-9]{4}\\-[0-9]{2}\\-[0-9]{2}")
  )

  eoq_append_dir_path <- '//dphcifs/Prevention/HIV/Epi/surv/EOQ/EOQ_append/Data'

  if (is.null(date)) {
    # get name of latest eoq dataset
    eoq_append_file_path <- list.dirs(
      path = eoq_append_dir_path,
      recursive = FALSE
    ) |>
      stringr::str_subset("[0-9]{4}\\-[0-9]{2}\\-[0-9]{2}") |>
      max() |>
      file.path("eoq_append.sas7bdat")
  } else {
    eoq_append_file_path <- file.path(
      eoq_append_dir_path,
      date,
      "eoq_append.sas7bdat"
    )
  }

  if (!file.exists(eoq_append_file_path)) {
    (stop(paste0("Could not find an EOQ_append dataset dated ", date)))
  }

  haven::read_sas(
    data_file = eoq_append_file_path,
    catalog_file = "//dphcifs/prevention/HIV/Epi/surv/EHARS/Reference Documents/Current Reference Materials/eharsfmt_32.sas7bcat",
    ...
  )
}
