# Assert a vector contains eHARS-tyle dates (YYYYMMDD with .. for missing date parts)

Assert a vector contains eHARS-tyle dates (YYYYMMDD with .. for missing
date parts)

## Usage

``` r
is.ehars_dt(x)
```

## Arguments

- x:

  A vector

## Value

A single boolean value indicating whether all elements of `x` are eHARS
dates

## Examples

``` r
is.ehars_dt(c("20260101", "202601..", "2026....", "........")) # TRUE
#> [1] TRUE
is.ehars_dt(c("20260..1")) # NOTE: ignores misplaced .. (since these do occur in eHARS on rare occasions)
#> [1] TRUE
is.ehars_dt(c("2026-01-01", "2026-02-02")) # FALSE
#> [1] FALSE
```
