# Confirm no stateno invalidly-formatted

Throws an error if the specified variable in the specified data frame
contains any values that do no adhere to Washington State's formatting
conventions for stateno and so appear to be invalid

## Usage

``` r
assert_stateno_format_valid(df, stateno_var = stateno)
```

## Arguments

- df:

  A data frame

- stateno_var:

  name (unquoted) of a variable in `df` containing stateno

## Value

The input data frame `df` (if no invalid stateno are found)

## Examples

``` r
read_ehars_person(col_select = stateno) |> assert_stateno_format_valid() |> View() # opens listing of stateno in R's Data Viewer
#> Error: '//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/NA/person_sas7bdat/person.sas7bdat' does not exist.
data.frame(stateno = c('12345')) |> assert_stateno_format_valid() |> View() # generates an error
#> Error in assert_stateno_format_valid(data.frame(stateno = c("12345"))): 1 distinct stateno appear to be invalid based on their format:  12345
```
