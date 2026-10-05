#'Generate a logical expression for filtering to PLWH in King County at the end
#'of some specified year
#'
#'@param df a data.frame to filter
#'@param year the year for which you'd like to filter to PLWH at year-end,
#'  specified as an integer or string
#'
#'@returns a data.frame
#'@export
#'
#' @examples
#'...
filter_KC_PLWH <- function(df, year) {
  varname_n_PLWA_cnty <- paste0("n_PLWA_cnty", year)
  varname_excludeP <- paste0("excludeP_", year)

  # confirm relevant n_PLWA_ var exists in `df`
  stopifnot(varname_n_PLWA_cnty %in% names(df))

  if (!varname_excludeP %in% names(df)) {
    # warn if excludeP_`yr` not in `df` and so will be ignored
    warning(glue::glue(
      'Column `{varname_excludeP}` not found in `df`. Filtering will be based on column `{varname_n_PLWA_cnty}` only and so may overestimate PLWH.'
    ))

    y <- df |>
      dplyr::filter(stringr::str_detect(
        string = .data[[varname_n_PLWA_cnty]],
        pattern = "\\bKING CO\\."
      ))
  } else {
    y <- df |>
      dplyr::filter(
        stringr::str_detect(
          string = .data[[varname_n_PLWA_cnty]],
          pattern = "\\bKING CO\\."
        ) &
          dplyr::coalesce(.data[[varname_excludeP]], 0) != 1 # treat NAs as 0s
      )
  }

  return(y)
}

# filter_KC_dx <- function() {
# confirm variables to filter by exists
# warning if neither ... nor excludei in `df` and will be ignored
# best_first_pos_dt =
#   min(HIV1STPOSDATE_DATE_num /*from PCRS*/
#         ,th_first_pos_dt_num
#       ,LF_PT_DT_FRST_POS_num
#   ); *NOTE: a limitation of this calculation is that a partial date can supersede a complete date in the latter half of the year;
# label best_first_pos_dt = 'Date of earliest positive test result';
#
# days_first_pos_to_dx = hiv_aids_dx_dt_num - best_first_pos_dt;
# label days_first_pos_to_dx	= 'Days between first positive test and diagnosis'
# if have excludei, use that
# if have CaseDispo AND
# if CaseDispo not in ('','1' /*NEW*/,'6' /*Peri*/)
#   or days_first_pos_to_dx > 365
#   then EXCLUDEI = 1;
# else EXCLUDEI = 0;
# label EXCLUDEI  = 'Exclude from incident King Co. diagnoses';
# }
