# Construct path to cached result for the calling function

Construct path to cached result for the calling function

## Usage

``` r
construct_cache_file_path(n_frames_up = 1)
```

## Arguments

- n_frames_up:

  Default is 1, which is to say: a path is constructed using the name
  and the arguments of the function calling
  `construct_cache_file_path()`. If `n_frames_up` = 2, a path is
  constructed using the name and the arguments of the function calling
  the function calling `construct_cache_file_path()`,.

## Value

A file path to a .rds file in the /derived subdirectory of the directory
in which are stored the eHARS data currently being used within the R
session. The file ame is constructed as
`<function name>__<function argument names and values separated by '_'/'__'>`

## Examples

``` r
test_fun <- function(x = 1, y = 2, z = 3){construct_cache_file_path()}
test_fun()
#> Error in construct_cache_file_path(): could not find function "construct_cache_file_path"
rm(test_fun)
```
