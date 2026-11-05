# Calculate nativity (US-born vs foreign-born vs unknown)

Calculate nativity (US-born vs foreign-born vs unknown)

## Usage

``` r
calc_nativity(df)
```

## Arguments

- df:

  A data.frame containing (at least) eHARS variable birth_country_cd

## Value

Input data frame `df` with the addition of variable `nativity`

## Examples

``` r
read_ehars_person(col_select = birth_country_cd) |> dplyr::distinct() |> calc_nativity() |> View()
#> Error: '//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/NA/person_sas7bdat/person.sas7bdat' does not exist.
```
