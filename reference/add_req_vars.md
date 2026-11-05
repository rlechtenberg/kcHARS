# Ensure a data.frame includes all vars required for calculation

If the input data.frame does not include the specified vars, this
function joins them in from eHARS.

## Usage

``` r
add_req_vars(df, vars)
```

## Arguments

- df:

  a data.frame

- vars:

  a character vector listing the names of variables required in `df`

## Value

`df` with the addition of any variables from among `vars` that hadn't
originally been included

## Examples

``` r
x <- read_ehars_person(col_select = c("stateno"))
#> Error: '//kc/dph/prevention/hiv/Epi/EXTRA SPACE/eHARS/Full eHARS/Archive/NA/person_sas7bdat/person.sas7bdat' does not exist.
names(x) # only stateno
#> Error: object 'x' not found
y <- add_req_vars(df = x, vars = c("race", "ethnicity1"))
#> Error in add_req_vars(df = x, vars = c("race", "ethnicity1")): could not find function "add_req_vars"
names(y) # stateno AND race and ethnicity1
#> Error: object 'y' not found
rm(x, y)
#> Warning: object 'x' not found
#> Warning: object 'y' not found
```
