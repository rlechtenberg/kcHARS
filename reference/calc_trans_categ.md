# Calculate transmission category variables

Calculate transmission category variables

## Usage

``` r
calc_trans_categ(df)
```

## Arguments

- df:

  a data frame containing (at least) eHARS variables `trans_categ`,
  `sex`, `sex_male`, `sex_female`, `idu`, and variable `gender`
  calculated by
  [`kcHARS::calc_gender()`](https://rlechtenberg.github.io/kcHARS/reference/calc_gender.md)

## Value

Input data frame `df` with the addition of variables `trans_categ_exp`
and `msm`

## Examples

``` r
read_ehars_person(col_select = dplyr::any_of(c(
  'trans_categ',
  'sex',
  'sex_male',
  'sex_female',
  'idu',
  "LF_TRANS",
  "LF_GENDER",
  "LF_GENDER_OTHER"
))
) |> distinct() |> calc_gender() |> calc_trans_categ() |> View()
#> Error in distinct(read_ehars_person(col_select = dplyr::any_of(c("trans_categ",     "sex", "sex_male", "sex_female", "idu", "LF_TRANS", "LF_GENDER",     "LF_GENDER_OTHER")))): could not find function "distinct"
```
