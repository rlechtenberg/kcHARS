# Calculate King County region

Calculate King County region

## Usage

``` r
calc_KingCo_region(
  df,
  region_var,
  zip_cd_var,
  county_name_var,
  state_cd_var,
  hml_var = NA_character_
)
```

## Arguments

- df:

  A data frame

- region_var:

  quoted name of the output variable specifying region of King County

- zip_cd_var:

  quoted name of the variable specifying zip code of residence; can be
  \>5 digits but only the first five are used

- county_name_var:

  quoted name of the variable specifying county of residence (e.g.,
  'King Co.')

- state_cd_var:

  quoted name of the variable specifying the 2-letter code of the state
  of residence (e.g., 'WA')

- hml_var:

  optional 0/1 indicator for whether the person was homeless/unstably
  housed (H/UH); if specified, H/UH appear in their own category

## Value

Input data frame `df` with the addition of region_var

## Examples
