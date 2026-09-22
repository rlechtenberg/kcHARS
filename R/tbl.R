#'Group breakdowns by non-mutually exclusive race/ethnicity variables (e.g.,
#'natam_multi, black_multi, latino)
#'
#'@param x gtsummary object of class 'tbl_summary' containing breakdowns by
#'  variables `black_multi`, `natam_multi`, `asian_multi`, `black_multi`,
#'  `latino`, `pacisl_multi`, and `white_multi`
#'
#'@returns a gtsummary table modified such that breakdowns by non-mutually
#'  exclusive race/ethnicity variables display as though they are a breakdown by
#'  a single race/ethnicity variable, with a footnote clarifying that categories
#'  are not mutually exclusive
#'@export
#'
#' @examples
#' x <- kcHARS::read_eoq_append(
#' date = "2026-07-01",
#'   col_select = c(ethnicity1, matches("race[0-9]"))
#'   ) |>
#'     kcHARS::calc_race_eth_vars() |>
#'     select(-ethnicity1, -matches("race[0-9]"))
#'
#' y <- x |> Misc.SHH.f::labelled_to_factor() |> gtsummary::tbl_summary()
#' y # what the table looks like BEFORE applying group_race_eth_multi_vars()
#' y |> group_race_eth_multi_vars() # and after
group_race_eth_multi_vars <- function(x) {
  stopifnot(all(class(x) == c("tbl_summary", "gtsummary")))

  race_eth_multi_vars <- c(
    "black_multi",
    "natam_multi",
    "asian_multi",
    "black_multi",
    "latino",
    "pacisl_multi",
    "white_multi"
  )

  # confirm the`x` stratifies by the expected non-mutually exclusive
  # race/ethnicity variables
  race_eth_multi_vars |>
    purrr::walk(.f = function(var) {
      if (!var %in% unique(x$table_body$variable)) {
        stop(paste0("tbl `x` does not stratify by variable `", var, "`."))
      }
    })

  y <- x |>
    group_dichot_vars(
      variables = c(race_eth_multi_vars),
      header = "Race/Ethnicity"
    ) |>
    # add foonote
    gtsummary::modify_table_styling(
      columns = label, # Target the row header column
      rows = label == "Race/Ethnicity", # Select the specific row header text
      footnote = "Race/ethnicity categories are not mutually exclusive. Individuals reporting multiple racial and ethnic identities are represented in each group. Therefore percentages will sum >100%."
    )

  return(y)
}
