kcHARS
================

<!-- following ensures the air R code formatter doesn't format this document (since it doesn't support documents other than .R files)  -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

<!-- badges: end -->

The kcHARS R package provides functions for Public Health–Seattle & King
County epidemiologists to use for reading and working with eHARS data.

## Installation

You can install the development version of kcHARS from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("rlechtenberg/kcHARS")
```

## Reading eHARS data into R

kcHARS assumes eHARS SAS datasets reside in “R:/Epi/EXTRA
SPACE/eHARS/Full eHARS” (what `ehars_root_dir()` returns). Specifically,
it assumes that the Archive/ subdirectory contains folders named
‘YYYY-MM-DD’, each containing an extract from a different date, and that
each of those contains a person_sas7bdat/ subdirectory containing eHARS’
person-based dataset (AKA the person view) and a document_sas7bdat/
subdirectory containing the document-based datasets. When you load and
attach the kcHARS package using the `library()` function, R identifies
the date of the most recent archived eHARS extract, stores it in a
global option named kcHARS.ehars_dt, and notifies you of it via the
package start-up message. Calls to `ehars_person()` and `ehars_doc()`
will then read the requested data from the associated folder.

``` r
library(kcHARS)
#> Using eHARS data dated 2026-06-08. 
#> (You can specify a different date using `options(kcHARS.ehars_dt = '<YYYY-MM-DD>')`.

# print date of eHARS data being used
getOption("kcHARS.ehars_dt")
#> [1] "2026-06-08"

# get max document enter_dt
ehars_doc("document", col_select = c("enter_dt")) |>
  dplyr::pull(enter_dt) |>
  max() |>
  ehars_dt.as.Date()
#> [1] "2026-06-05"
```

If you want to use the data from a different/older extract, you can
simply update that kcHARS.ehars_dt global option using
`options(kcHARS.ehars_dt = '<YYYY-MM-DD>')`.

``` r
options(kcHARS.ehars_dt = "2025-12-30")

# print date of eHARS data being used
getOption("kcHARS.ehars_dt")
#> [1] "2025-12-30"

# get max document enter_dt
ehars_doc("document", col_select = c("enter_dt")) |>
  dplyr::pull(enter_dt) |>
  max() |>
  ehars_dt.as.Date()
#> [1] "2025-12-23"
```

<!-- You'll still need to render `README.Rmd` regularly, to keep `README.md` -->

<!-- up-to-date. `devtools::build_readme()` is handy for this.  -->
