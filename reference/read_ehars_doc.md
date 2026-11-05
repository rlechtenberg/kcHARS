# Read an eHARS document-based dataset (e.g., document, lab) into R

Read an eHARS document-based dataset (e.g., document, lab) into R

## Usage

``` r
read_ehars_doc(tbl, date = getOption("kcHARS.ehars_dt"), ...)
```

## Arguments

- tbl:

  character value specifying the name of one of eHARS document-based
  tables

- date:

  Date of eHARS data to read; optional and defaults to
  getOption("kcHARS.ehars_dt")

- ...:

  Optional parameters passed to haven::read_sas()

## Value

a data.frame

## Examples

``` r
read_ehars_doc("document", n_max = 10)
#> Error: '//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/NA/document_sas7bdat/document.sas7bdat' does not exist.
read_ehars_doc("document", n_max = 10, col_select = c("ehars_uid", "document_uid", "document_type_cd", "enter_dt"))
#> Error: '//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/NA/document_sas7bdat/document.sas7bdat' does not exist.
```
