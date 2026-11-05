# Read eHARS' person-based dataset (AKA the person view) into R

Read eHARS' person-based dataset (AKA the person view) into R

## Usage

``` r
read_ehars_person(date = getOption("kcHARS.ehars_dt"), ...)
```

## Arguments

- date:

  Date of eHARS data to read; optional and defaults to
  getOption("kcHARS.ehars_dt")

- ...:

  Optional parameters passed to haven::read_sas()

## Value

a data frame

## Examples

``` r
read_ehars_person(n_max = 10, col_select = c("stateno", "hiv_aids_dx_dt", "trans_categ"))
#> Error: '//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/NA/person_sas7bdat/person.sas7bdat' does not exist.
```
