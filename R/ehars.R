#' Return the path to the root directory for eHARS files
#'
#' @returns A character value specifying the path to the root directory for
#'   eHARS files
#' @export
#'
ehars_root_dir <- function() {
  return("R:/Epi/EXTRA SPACE/eHARS/Full eHARS")
}

#' Read eHARS' person-based dataset (AKA the person view) into R
#'
#' @param ... Optional parameters passed to haven::read_sas()
#'
#' @returns a data.frame
#' @export
#'
#' @examples
#' ehars_person(n_max = 10, col_select = c("stateno", "hiv_aids_dx_dt", "trans_categ"))

ehars_person <- function(...) {
  haven::read_sas(
    data_file = file.path(
      ehars_root_dir(),
      "Archive",
      getOption("kcHARS.ehars_dt"),
      "person_sas7bdat",
      "person.sas7bdat"
    ),
    catalog_file = "//dphcifs/prevention/HIV/Epi/surv/EHARS/Reference Documents/Current Reference Materials/eharsfmt_32.sas7bcat",
    ...
  )
}

#' Read an eHARS document-based dataset (e.g., document, lab) into R
#'
#' @param tbl character value specifying the name of one of eHARS document-based
#'   tables
#' @param ... Optional parameters passed to haven::read_sas()
#'
#' @returns a data.frame
#' @export
#'
#' @examples
#'ehars_doc("document", n_max = 10)
#'ehars_doc("document", n_max = 10, col_select = c("ehars_uid", "document_uid", "document_type_cd", "enter_dt"))

ehars_doc <- function(tbl, ...) {
  haven::read_sas(
    data_file = file.path(
      ehars_root_dir(),
      "Archive",
      getOption("kcHARS.ehars_dt"),
      "document_sas7bdat",
      paste0(tbl, ".sas7bdat")
    ),
    catalog_file = "//dphcifs/prevention/HIV/Epi/surv/EHARS/Reference Documents/Current Reference Materials/eharsfmt_32.sas7bcat",
    ...
  )
}
