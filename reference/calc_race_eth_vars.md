# Calculate non-mutually exclusive race/ethnicity variables

Calculate non-mutually exclusive race/ethnicity variables

## Usage

``` r
calc_race_eth_vars(df)
```

## Arguments

- df:

  A data.frame containing (at least) eHARS variables race1-race5 and
  ethnicity1

## Value

Input data frame `df` with the addition of variables (1) natam_multi,
(2) asian_multi, (3) black_multi, (4) pacisl_multi, (5) white_multi, and
(6) latino

## Examples

``` r
read_ehars_person(col_select = c(matches("race[0-9]"), all_of(c("ethnicity1")))) |> dplyr::distinct() |> calc_race_eth_vars() |> View()
#> Error: '//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/NA/person_sas7bdat/person.sas7bdat' does not exist.
```
