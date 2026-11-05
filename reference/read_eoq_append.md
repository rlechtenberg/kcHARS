# Read EOQ datasets (eoqrep\_\_newcr) into R

Read EOQ datasets (eoqrep\_\_newcr) into R

## Usage

``` r
read_eoq_append(date = NULL, ...)
```

## Arguments

- date:

  Character string specifying the date of the eoq_append dataset to read
  (formatted as YYYY-MM-DD)

- ...:

  Optional parameters passed to haven::read_sas()

## Value

A data frame

## Examples

``` r
read_eoq_append(col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#> Warning: no non-missing arguments, returning NA
#> Error in read_eoq_append(col_select = c(enter_dt)): Could not find an EOQ_append dataset dated 
read_eoq_append(date = "2026-07-01", col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#> Error in read_eoq_append(date = "2026-07-01", col_select = c(enter_dt)): Could not find an EOQ_append dataset dated 2026-07-01
read_eoq_append(date = "2024-04-08", col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#> Error in read_eoq_append(date = "2024-04-08", col_select = c(enter_dt)): Could not find an EOQ_append dataset dated 2024-04-08
read_eoq_append(date = "1900-07-01", col_select = c(enter_dt)) |> dplyr::pull(enter_dt) |> max()
#> Error in read_eoq_append(date = "1900-07-01", col_select = c(enter_dt)): Could not find an EOQ_append dataset dated 1900-07-01
```
