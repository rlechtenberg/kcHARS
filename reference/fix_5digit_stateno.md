# Re-add leading 0 to stateno where dropped (e.g., by Excel)

Re-add leading 0 to stateno where dropped (e.g., by Excel)

## Usage

``` r
fix_5digit_stateno(df, stateno_var = stateno)
```

## Arguments

- df:

  A data frame

- stateno_var:

  name (unquoted) of a variable in `df` containing stateno

## Value

The input data frame `df` with the leading 0 added back to 5-digit
values of column `stateno_var`

## Examples

``` r
data.frame(stateno = c("12345")) |> fix_5digit_stateno() # leading 0 added
#> Warning: 1 stateno appear to be missing a leading zero and will have it re-added: 12345
#>   stateno
#> 1  012345
```
