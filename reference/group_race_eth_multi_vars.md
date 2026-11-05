# Group breakdowns by non-mutually exclusive race/ethnicity variables (e.g., natam_multi, black_multi, latino)

Group breakdowns by non-mutually exclusive race/ethnicity variables
(e.g., natam_multi, black_multi, latino)

## Usage

``` r
group_race_eth_multi_vars(x)
```

## Arguments

- x:

  gtsummary object of class 'tbl_summary' containing breakdowns by
  variables `black_multi`, `natam_multi`, `asian_multi`, `black_multi`,
  `latino`, `pacisl_multi`, and `white_multi`

## Value

a gtsummary table modified such that breakdowns by non-mutually
exclusive race/ethnicity variables display as though they are a
breakdown by a single race/ethnicity variable, with a footnote
clarifying that categories are not mutually exclusive

## Examples

``` r
x <- kcHARS::read_eoq_append(
date = "2026-07-01",
  col_select = c(ethnicity1, matches("race[0-9]"))
  ) |>
    kcHARS::calc_race_eth_vars() |>
    select(-ethnicity1, -matches("race[0-9]"))
#> Error in select(kcHARS::calc_race_eth_vars(kcHARS::read_eoq_append(date = "2026-07-01",     col_select = c(ethnicity1, matches("race[0-9]")))), -ethnicity1,     -matches("race[0-9]")): could not find function "select"

y <- x |> Misc.SHH.f::labelled_to_factor() |> gtsummary::tbl_summary()
#> Error: object 'x' not found
y # what the table looks like BEFORE applying group_race_eth_multi_vars()
#> Error: object 'y' not found
y |> group_race_eth_multi_vars() # and after
#> Error: object 'y' not found
```
