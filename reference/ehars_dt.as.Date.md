# Convert eHARS-style dates from character to date values

Convert eHARS-style dates ('YYYYMMDD' with missing day/month+day/date
specified as '..'/'....'/'........') from character to date values.
'........' and zero-length strings (”) are converted to NAs.

## Usage

``` r
ehars_dt.as.Date(x, ..to = "15", ....to = "0630")
```

## Arguments

- x:

  A character vector of eHARS-style date values: 'YYYYMMDD' with missing
  day/month+day/date specified as '..'/'....'/'........'.

- ..to:

  Two-digit (zero-padded, as needed) character value specifying the day
  to impute, where missing. Defaults to '15'.

- ....to:

  Four-digit (zero-padded, as needed) character value specifying the
  month+day to impute, where missing. Defaults to '0630'.

## Value

A vector of class `Date`

## Examples

``` r
ehars_dt.as.Date("20191231")
#> [1] "2019-12-31"
ehars_dt.as.Date("201901..")
#> [1] "2019-01-15"
ehars_dt.as.Date("201901..", ..to = '01')
#> [1] "2019-01-01"
ehars_dt.as.Date("2019....")
#> [1] "2019-06-30"
ehars_dt.as.Date("2019....", ....to = '0615')
#> [1] "2019-06-15"
```
