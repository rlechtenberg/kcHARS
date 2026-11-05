# Calculate 3- or 5-category gender variable

Calculate 3- or 5-category gender variable

## Usage

``` r
calc_gender(df, n_cat = 5)
```

## Arguments

- df:

  A data frame containing (at least) eHARS variables sex/birth_sex,
  LF_TRANS, LF_GENDER, and LF_GENDER_OTHER

- n_cat:

  Number of categories to output; if 3, then all non-cisgender people
  included in a single 'Gender Diverse' category

## Value

Input data frame `df` with the addition of variables (1) gender, and (2)
transgender_ever

## Examples

``` r
read_ehars_person(col_select = c(sex, LF_TRANS, LF_GENDER, LF_GENDER_OTHER)) |> dplyr::distinct() |> calc_gender() |> View()
#> Error: '//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/NA/person_sas7bdat/person.sas7bdat' does not exist.
```
