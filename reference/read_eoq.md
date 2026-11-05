# Read EOQ datasets (eoqrep\_\_newcr) into R

Read EOQ datasets (eoqrep\_\_newcr) into R

## Usage

``` r
read_eoq(YYYYMM = NULL, ...)
```

## Arguments

- YYYYMM:

  6-digit character value specifying the year and month of the dataset
  (e.g., "202607"). If NULL (the default), the latest EOQ dataset is
  read

- ...:

  Optional parameters passed to haven::read_sas()

## Value

A data frame

## Examples

``` r
read_eoq(col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#> Warning: no non-missing arguments, returning NA
#> Error in read_eoq(col_select = c(enter_dt)): Could not find an EOQ dataset for 
read_eoq(YYYYMM = "202607", col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#> Error in read_eoq(YYYYMM = "202607", col_select = c(enter_dt)): Could not find an EOQ dataset for 202607
read_eoq(YYYYMM = "202511", col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#> Error in read_eoq(YYYYMM = "202511", col_select = c(enter_dt)): Could not find an EOQ dataset for 202511
read_eoq(YYYYMM = "190001", col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#> Error in read_eoq(YYYYMM = "190001", col_select = c(enter_dt)): Could not find an EOQ dataset for 190001
```
