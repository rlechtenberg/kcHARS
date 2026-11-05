# Package index

## All functions

- [`add_req_vars()`](https://rlechtenberg.github.io/kcHARS/reference/add_req_vars.md)
  : Ensure a data.frame includes all vars required for calculation

- [`assert_stateno_format_valid()`](https://rlechtenberg.github.io/kcHARS/reference/assert_stateno_format_valid.md)
  : Confirm no stateno invalidly-formatted

- [`calc_KingCo_region()`](https://rlechtenberg.github.io/kcHARS/reference/calc_KingCo_region.md)
  : Calculate King County region

- [`calc_age_groups()`](https://rlechtenberg.github.io/kcHARS/reference/calc_age_groups.md)
  : Calculate age groups at diagnosis and currently

- [`calc_gender()`](https://rlechtenberg.github.io/kcHARS/reference/calc_gender.md)
  : Calculate 3- or 5-category gender variable

- [`calc_nativity()`](https://rlechtenberg.github.io/kcHARS/reference/calc_nativity.md)
  : Calculate nativity (US-born vs foreign-born vs unknown)

- [`calc_race_eth_vars()`](https://rlechtenberg.github.io/kcHARS/reference/calc_race_eth_vars.md)
  : Calculate non-mutually exclusive race/ethnicity variables

- [`calc_trans_categ()`](https://rlechtenberg.github.io/kcHARS/reference/calc_trans_categ.md)
  : Calculate transmission category variables

- [`construct_cache_file_path()`](https://rlechtenberg.github.io/kcHARS/reference/construct_cache_file_path.md)
  : Construct path to cached result for the calling function

- [`ehars_dt.as.Date()`](https://rlechtenberg.github.io/kcHARS/reference/ehars_dt.as.Date.md)
  : Convert eHARS-style dates from character to date values

- [`ehars_root_dir()`](https://rlechtenberg.github.io/kcHARS/reference/ehars_root_dir.md)
  : Return the path to the root directory for eHARS files

- [`filter_KC_PLWH()`](https://rlechtenberg.github.io/kcHARS/reference/filter_KC_PLWH.md)
  : Generate a logical expression for filtering to PLWH in King County
  at the end of some specified year

- [`fix_5digit_stateno()`](https://rlechtenberg.github.io/kcHARS/reference/fix_5digit_stateno.md)
  : Re-add leading 0 to stateno where dropped (e.g., by Excel)

- [`get_VLs()`](https://rlechtenberg.github.io/kcHARS/reference/get_VLs.md)
  : Derive an analysis-ready data set listing viral loads (VL)

- [`get_care_dts()`](https://rlechtenberg.github.io/kcHARS/reference/get_care_dts.md)
  : Compile a list of documented dates of HIV care (labs and optionally
  care_nolab and/or ARV use)

- [`group_race_eth_multi_vars()`](https://rlechtenberg.github.io/kcHARS/reference/group_race_eth_multi_vars.md)
  : Group breakdowns by non-mutually exclusive race/ethnicity variables
  (e.g., natam_multi, black_multi, latino)

- [`is.ehars_dt()`](https://rlechtenberg.github.io/kcHARS/reference/is.ehars_dt.md)
  : Assert a vector contains eHARS-tyle dates (YYYYMMDD with .. for
  missing date parts)

- [`read_ehars_doc()`](https://rlechtenberg.github.io/kcHARS/reference/read_ehars_doc.md)
  : Read an eHARS document-based dataset (e.g., document, lab) into R

- [`read_ehars_person()`](https://rlechtenberg.github.io/kcHARS/reference/read_ehars_person.md)
  : Read eHARS' person-based dataset (AKA the person view) into R

- [`read_eoq()`](https://rlechtenberg.github.io/kcHARS/reference/read_eoq.md)
  :

  Read EOQ datasets (eoqrep\_\_newcr) into R

- [`read_eoq_append()`](https://rlechtenberg.github.io/kcHARS/reference/read_eoq_append.md)
  :

  Read EOQ datasets (eoqrep\_\_newcr) into R

- [`write_to_cache()`](https://rlechtenberg.github.io/kcHARS/reference/write_to_cache.md)
  : Write/overwrite file in the cache
