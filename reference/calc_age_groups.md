# Calculate age groups at diagnosis and currently

Calculate age groups at diagnosis and currently

## Usage

``` r
calc_age_groups(df, cur_age_as_of = as.Date(getOption("kcHARS.ehars_dt")))
```

## Arguments

- df:

  A data.frame containing (at least) eHARS variables `hiv_aids_age_yrs`
  and dob

- cur_age_as_of:

  A Date value specifying the date as of which to calculate each
  person's "current" age. Defaults to the date associated with the eHARS
  data being used.

## Value

Input data frame `df` with the addition of variables
`hiv_aids_age_group` and `cur_age_group`

## Examples

``` r
read_ehars_person(col_select = c(dob, hiv_aids_age_yrs)) |> calc_age_groups() |> View()
#> Error: '//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/NA/person_sas7bdat/person.sas7bdat' does not exist.
```
