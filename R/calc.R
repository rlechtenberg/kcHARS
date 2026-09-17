#' Calculate 3- or 5-category gender variable
#'
#' @param df A data frame containing (at least) eHARS variables sex/birth_sex,
#'   LF_TRANS, LF_GENDER, and LF_GENDER_OTHER
#' @param n_cat Number of categories to output; if 3, then all non-cisgender
#'   people included in a single 'Gender Diverse' category
#'
#' @returns Input data frame `df` with the addition of variables (1) gender, and
#'   (2) transgender_ever
#' @export
#'
#' @examples
#' read_ehars_person(col_select = c(sex, LF_TRANS, LF_GENDER, LF_GENDER_OTHER)) |> dplyr::distinct() |> calc_gender() |> View()
calc_gender <- function(
  df,
  n_cat = 5 # 3 or 5
) {
  stopifnot(n_cat %in% c(3, 5))

  # confirm input variables are in `df`
  stopifnot(all(c('LF_TRANS', 'LF_GENDER', 'LF_GENDER_OTHER') %in% names(df)))
  # need at least one of these; was `birth_sex` until eHARS v4.17, when renamed to `sex`
  stopifnot(any(c('birth_sex', 'sex') %in% names(df)))

  # confirm no unexpected values of (birth_)sex variable
  if ('sex' %in% names(df)) {
    stopifnot(all(unique(df$sex) %in% c('F', 'M', 'U')))
  } else if ('birth_sex' %in% names(df)) {
    stopifnot(all(unique(df$birth_sex) %in% c('F', 'M', 'U')))
  }

  # confirm no unexpected values of LF_TRANS and LF_GENDER variables
  stopifnot(all(unique(df$LF_TRANS) %in% c('MF', 'FM', 'OTHER', '')))
  stopifnot(all(
    unique(df$LF_GENDER) %in% c('M', 'F', 'MF', 'FM', 'NB', 'GQ', 'O', '')
  ))

  y <- df

  if ('sex' %in% names(df)) {
    # rename sex to birth_sex (will rename back to sex before function ends)
    y <- y |>
      dplyr::rename(birth_sex = sex)
  }

  # calculate transgender_ever
  y <- y |>
    dplyr::mutate(
      transgender_ever = dplyr::case_when(
        LF_TRANS == 'MF' | LF_GENDER == 'MF' ~ 'MF',
        LF_TRANS == 'FM' | LF_GENDER == 'FM' ~ 'FM',
        LF_TRANS == 'OTHER' |
          LF_GENDER %in% c('NB', 'GQ', 'O') |
          dplyr::coalesce(LF_GENDER_OTHER, "") != "" ~ 'AD',
        TRUE ~ NA_character_
      ),
      gender = dplyr::coalesce(transgender_ever, birth_sex) |>
        dplyr::recode_values(
          "M" ~ "M",
          "F" ~ "F",
          "MF" ~ "MF",
          "FM" ~ "FM",
          "AD" ~ "AD",
          default = NA_character_
        ) |>
        labelled::labelled(
          labels = c(
            "Cisgender Man" = "M",
            "Cisgender Woman" = "F",
            "Transgender Woman" = "MF",
            "Transgender Man" = "FM",
            "Another Gender Identity" = "AD"
          )
        ) |>
        labelled::set_variable_labels("Gender")
    )

  if (n_cat == 3) {
    y <- y |>
      dplyr::mutate(
        gender = gender |>
          dplyr::recode_values(
            "M" ~ "M",
            "F" ~ "F",
            "MF" ~ "AD",
            "FM" ~ "AD",
            "AD" ~ "AD",
            default = NA_character_
          ) |>
          labelled::labelled(
            labels = c(
              "Cisgender Man" = "M",
              "Cisgender Woman" = "F",
              "Gender Diverse" = "AD"
            )
          ) |>
          labelled::set_variable_labels("Gender")
      )
  }

  # drop birth_sex if not in original dataset
  if ('sex' %in% names(df)) {
    y <- y |>
      dplyr::rename(sex = birth_sex)
  }

  return(y)
}

#' Calculate non-mutually exclusive race/ethnicity variables
#'
#' @param df A data.frame containing (at least) eHARS variables race1-race5 and ethnicity1
#'
#' @returns Input data frame `df` with the addition of variables (1)
#'   natam_multi, (2) asian_multi, (3) black_multi, (4) pacisl_multi, (5)
#'   white_multi, and (6) latino
#' @export
#'
#' @examples
#'read_ehars_person(col_select = c(matches("race[0-9]"), all_of(c("ethnicity1")))) |> dplyr::distinct() |> calc_race_eth_vars() |> View()
calc_race_eth_vars <- function(df) {
  stopifnot(all(
    c('race1', 'race2', 'race3', 'race4', 'race5', 'ethnicity1') %in% names(df)
  ))
  stopifnot(all(unique(df$ethnicity1) %in% c("E1", "E2", "UNK", '')))
  paste0("race", 1:5) |>
    purrr::map(.f = function(race_i) {
      stopifnot(all(
        unique(df[[race_i]]) %in% c("R1", "R2", 'R3', 'R4', 'R5', "UNK", '')
      ))
    })

  df |>
    dplyr::mutate(
      races = paste(race1, race2, race3, race4, race5), # calc concatenation of race vars to streamline the below
      natam_multi = ifelse(stringr::str_detect(races, "R1"), 1, 0) |>
        labelled::labelled(
          labels = c(
            "Native American/Alaskan Native" = 1,
            "Not Native American/Alaskan Native" = 0
          )
        ) |>
        labelled::set_variable_labels("Native American/Alaskan Native"),
      asian_multi = ifelse(stringr::str_detect(races, "R2"), 1, 0) |>
        labelled::labelled(labels = c("Asian" = 1, "Not Asian" = 0)) |>
        labelled::set_variable_labels("Asian"),
      black_multi = ifelse(stringr::str_detect(races, "R3"), 1, 0) |>
        labelled::labelled(labels = c("Black" = 1, "Not Black" = 0)) |>
        labelled::set_variable_labels("Black"),
      pacisl_multi = ifelse(stringr::str_detect(races, "R4"), 1, 0) |>
        labelled::labelled(
          labels = c(
            "Native Hawaiian or Pacific Islander" = 1,
            "Not Native Hawaiian or Pacific Islander" = 0
          )
        ) |>
        labelled::set_variable_labels("Native Hawaiian or Pacific Islander"),
      white_multi = ifelse(stringr::str_detect(races, "R5"), 1, 0) |>
        labelled::labelled(labels = c("White" = 1, "Not White" = 0)) |>
        labelled::set_variable_labels("White"),
      latino = dplyr::if_else(
        ethnicity1 == "E1",
        1,
        0,
        missing = 0
      ) |>
        labelled::labelled(
          labels = c("Latinx or Hispanic" = 1, "Not Latinx or Hispanic" = 0)
        ) |>
        labelled::set_variable_labels("Latinx or Hispanic"),
      races = NULL # drop it as no longer needed
    )
}

#'Calculate nativity (US-born vs foreign-born vs unknown)
#'
#'@param df A data.frame containing (at least) eHARS variable birth_country_cd
#'
#'@returns Input data frame `df` with the addition of variable `nativity`
#'@export
#'
#' @examples
#'read_ehars_person(col_select = birth_country_cd) |> dplyr::distinct() |> calc_nativity() |> View()
calc_nativity <- function(df) {
  stopifnot('birth_country_cd' %in% names(df))

  df |>
    dplyr::mutate(
      nativity = dplyr::case_when(
        birth_country_cd %in%
          c(
            "USA",
            "ASM", # American Samoa
            "GUM", # Guam
            "PRI", # Puerto Rico
            "VIR", # Virgin Islands, U.S.
            "MNP", # Northern Mariana Islands
            "UMI", # U.S. Minor Outlying Areas
            "XX1", # U.S. Misc Caribbean
            "XX2", # U.S. Misc Pacific #1
            "050", # Baker Island
            "074", # Swan Island
            "075", # Pacific Trust Territories
            "100", # Howland Island
            "150", # Jarvis Island
            "200", # Johnston Atoll
            "250", # Kingman Reef
            "300", # Midway Islands
            "350", # Navassa Island
            "400", # Palmyra Atoll
            "450" # Wake Island
          ) ~ 1,
        is.na(birth_country_cd) | birth_country_cd %in% c("", "X99") ~ 99,
        TRUE ~ 0
      ) |>
        labelled::labelled(
          labels = c("U.S.-born" = 1, "Foreign-Born" = 0, "Unknown" = 99)
        ) |>
        labelled::set_variable_labels("Nativity")
    )
}

#' Calculate age groups at diagnosis and currently
#'
#' @param df A data.frame containing (at least) eHARS variables
#'   `hiv_aids_age_yrs` and dob
#' @param cur_age_as_of A Date value specifying the date as of to calculate each
#'   person's "current" age
#'
#' @returns Input data frame `df` with the addition of variables
#'   `hiv_aids_age_group` and `cur_age_group`
#' @export
#'
#' @examples
#'read_ehars_person(col_select = c(dob, hiv_aids_age_yrs)) |> calc_age_groups() |> View()
calc_age_groups <- function(
  df,
  cur_age_as_of = as.Date(getOption("kcHARS.ehars_dt"))
) {
  stopifnot(all(c("dob", "hiv_aids_age_yrs") %in% names(df)))
  stopifnot(is.ehars_dt(df[["dob"]]))

  df |>
    dplyr::mutate(
      tmp_hiv_aids_age_yrs_int = as.integer(hiv_aids_age_yrs),
      hiv_aids_age_group = dplyr::case_when(
        is.na(tmp_hiv_aids_age_yrs_int) ~ NA_character_,
        tmp_hiv_aids_age_yrs_int < 13 ~ "<13",
        tmp_hiv_aids_age_yrs_int < 25 ~ "13 - 24",
        tmp_hiv_aids_age_yrs_int < 35 ~ "25 - 34",
        tmp_hiv_aids_age_yrs_int < 45 ~ "35 - 44",
        tmp_hiv_aids_age_yrs_int < 55 ~ "45 - 54",
        tmp_hiv_aids_age_yrs_int < 65 ~ "55 - 64",
        TRUE ~ "65+"
      ) |>
        labelled::set_variable_labels("Age at HIV Diagnosis in Years"),
      tmp_dob_num = ehars_dt.as.Date(dob),
      tmp_cur_age_int = lubridate::interval(tmp_dob_num, cur_age_as_of) %/%
        lubridate::years(1),
      # NOTE: %/% performs integer division, discarding theany
      # remainder/decimal parts
      cur_age_group = dplyr::case_when(
        is.na(tmp_cur_age_int) ~ NA_character_,
        tmp_cur_age_int < 13 ~ "<13",
        tmp_cur_age_int < 20 ~ "13-19",
        tmp_cur_age_int < 25 ~ "20-24",
        tmp_cur_age_int < 35 ~ "25-34",
        tmp_cur_age_int < 45 ~ "35-44",
        tmp_cur_age_int < 55 ~ "45-54",
        tmp_cur_age_int < 65 ~ "55-64",
        tmp_cur_age_int < 75 ~ "65-74",
        TRUE ~ "75+"
      ) |>
        labelled::set_variable_labels(paste0(
          "Current Age in Years (as of ",
          format(cur_age_as_of, format = "%m/%d/%Y"),
          ")"
        ))
    ) |> # drop temp vars
    dplyr::select(-c(tmp_hiv_aids_age_yrs_int, tmp_dob_num, tmp_cur_age_int))
}

#'Calculate transmission category variables
#'
#'@param df a data frame containing (at least) eHARS variables `trans_categ`,
#'  `sex`, `sex_male`, `sex_female`, `idu`, and variable `gender` calculated by
#'  `kcHARS::calc_gender()`
#'
#'@returns Input data frame `df` with the addition of variables
#'  `trans_categ_exp` and `msm`
#'@export
#'
#' @examples
#'read_ehars_person(col_select = dplyr::any_of(c(
#'   'trans_categ',
#'   'sex',
#'   'sex_male',
#'   'sex_female',
#'   'idu',
#'   "LF_TRANS",
#'   "LF_GENDER",
#'   "LF_GENDER_OTHER"
#' ))
#' ) |> distinct() |> calc_gender() |> calc_trans_categ() |> View()
calc_trans_categ <- function(df) {
  stopifnot(all(
    c('trans_categ', 'sex', 'sex_male', 'sex_female', 'idu', 'gender') %in%
      names(df)
  ))

  stopifnot(all(
    unique(df$trans_categ) %in%
      c(
        '01', # - Adult MSM
        '02', # - Adult IDU
        '03', # - Adult MSM & IDU
        '04', # - Adult received clotting factor
        '05', # - Adult heterosexual contact
        '06', # - Adult received transfusion/transplant
        '07', # - Perinatal exposure, HIV diagnosed at age 13 years or older
        '08', # - Adult with other confirmed risk
        '09', # - Adult with no identified risk (NIR)
        '10', # - Adult with no reported risk (NRR)
        '11', # - Child received clotting factor
        '12', # - Perinatal exposure
        '13', # - Child received transf/transplant
        '18', # - Child with other confirmed risk
        '19', # - Child with no indentified risk (NIR)
        '20', # - Child with no reported risk (NRR)
        '99' # - Risk factors selected with no age at diagnosis
      )
  ))

  trans_categ_labels <- c(
    '1MSM' = 'MSM',
    '2IDU' = 'PWID',
    '3MSM/IDU' = 'MSM and PWID',
    '4Hetero' = 'Heterosexual Sexual Contact',
    '6Peri' = 'Perinatal',
    '5Blood' = 'Transfusion/Transplant',
    '7NRR' = 'No Identified Risk',
    '7Other' = 'Other'
  )

  y <- df |>
    dplyr::mutate(
      tmp_trans_categ = dplyr::case_when(
        trans_categ == '01' ~ '1MSM', #01- Adult MSM
        trans_categ == '02' ~ '2IDU', # 02- Adult IDU
        trans_categ == '03' ~ '3MSM/IDU', # 03- Adult MSM & IDU
        trans_categ == '05' | # 05- Adult heterosexual contact
          (trans_categ %in%
            c(
              '09', # NIR
              '10' # NRR
            ) &
            sex == 'F' &
            sex_male == 'Y' &
            idu == 'N') ~ '4Hetero',
        trans_categ %in%
          c(
            '04', # 04- Adult received clotting factor
            '06', # 06- Adult received transfusion/transplant
            '11', # 11- Child received clotting factor
            '13' # 13- Child received transf/transplant
          ) ~ '5Blood',
        trans_categ %in%
          c(
            '07', # 07- Perinatal exposure, HIV diagnosed at age 13 years or older
            '12' # 12- Perinatal exposure
          ) ~ '6Peri',
        trans_categ %in%
          c(
            '09', # 09- Adult with no identified risk (NIR)
            '10', # 10- Adult with no reported risk (NRR)
            '19', # 19- Child with no indentified risk (NIR)
            '20' # 20- Child with no reported risk (NRR)
          ) ~ '7NRR',
        trans_categ %in%
          c(
            '08', # 08- Adult with other confirmed risk
            '18', # 18- Child with other confirmed risk
            '99' # 99- Risk factors selected with no age at diagnosis
          ) ~ '7Other'
      ),
      trans_categ_exp = dplyr::case_when(
        gender == 'AD' ~ '9AD',
        gender == 'MF' ~ '8TRANS',
        gender == 'FM' ~
          dplyr::case_when(
            sex_male == 'Y' ~ ifelse(idu == 'Y', '3MSM/IDU', '1MSM'),
            sex_female == 'Y' ~ ifelse(
              # getting to this point implies sex_male <> 'Y', so trans_categ
              # could not have been categorized as hetero given that they were AFAB),
              # could have classified as IDU, blood, peri, other, or NRR; check if
              # meet modified presumed hetero criteria and assign that if so
              idu == 'N' &
                trans_categ %in%
                  c(
                    '09', # NIR
                    '10' # NRR
                  ),
              '4Hetero',
              tmp_trans_categ
            ),
            TRUE ~ tmp_trans_categ
          ),
        TRUE ~ tmp_trans_categ
      ) |>
        labelled::labelled(labels = c(trans_categ_labels)) |>
        labelled::set_variable_labels("Transmission Category") |>
        Misc.SHH.f::set_notes_attr(
          "calculated from eHARS' trans_categ, with some categories collapsed\n-Ciswomen who endorse sex with males and deny IDU are reclassified as 'hetero'\n-transWOMEN and people who identify with an additional gender identity ('AD') are classified in their own categories and transMEN are classified into MSM, MSM/IDU, and hetero categories depending as appropriate"
        ),
      msm = ifelse(trans_categ_exp %in% c('1MSM', '3MSM/IDU'), 1, 0) |>
        labelled::labelled(
          labels = c("MSM & MSM/PWID" = 1, "Not MSM or MSM/PWID" = 0)
        ) |>
        labelled::set_variable_labels("MSM")
    )

  # y |> dplyr::distinct(tmp_trans_categ, trans_categ, sex, sex_male, idu) |> View()

  # y |>
  #   dplyr::distinct(
  #     trans_categ_exp,
  #     tmp_trans_categ,
  #     gender,
  #     sex_male,
  #     idu,
  #     sex_female,
  #     trans_categ
  #   ) |>
  #   dplyr::mutate(diff = ifelse(trans_categ_exp != tmp_trans_categ, 'X', '')) |>
  #   write.csv("temp.csv")

  y |>
    dplyr::select(-tmp_trans_categ)
}

#' Calculate King County region
#'
#' @param df A data frame
#' @param region_var quoted name of the output variable specifying region of King County
#' @param zip_cd_var quoted name of the variable specifying zip code of residence; can be >5 digits but only the first five are used
#' @param county_name_var quoted name of the variable specifying county of residence (e.g., 'King Co.')
#' @param state_cd_var quoted name of the variable specifying the 2-letter code of the state of residence (e.g., 'WA')
#' @param hml_var optional 0/1 indicator for whether the person was homeless/unstably housed (H/UH); if specified, H/UH appear in their own category
#'
#' @returns Input data frame `df` with the addition of region_var
#' @export
#'
#' @examples
#' read_ehars_person(col_select = c()) |> calc_KingCo_region(region_var = "res_region_inc", zip_cd_var = "rsd_zip_cd", county_name_var = "rsd_county_name", state_cd_var = "rsd_state_cd") |>  View()
calc_KingCo_region <- function(
  df,
  region_var,
  zip_cd_var,
  county_name_var,
  state_cd_var,
  hml_var = NA_character_
) {
  stopifnot(is.data.frame(df))

  stopifnot(
    is.character(region_var) &
      length(region_var) == 1 &
      !is.na(region_var)
  )
  stopifnot(
    is.character(zip_cd_var) &
      length(zip_cd_var) == 1 &
      !is.na(zip_cd_var)
  )
  stopifnot(
    is.character(county_name_var) &
      length(county_name_var) == 1 &
      !is.na(county_name_var)
  )
  stopifnot(
    is.character(state_cd_var) &
      length(state_cd_var) == 1 &
      !is.na(state_cd_var)
  )

  stopifnot(
    is.character(hml_var) &
      length(hml_var) == 1
  )

  stopifnot(all(c(zip_cd_var, county_name_var, state_cd_var) %in% names(df)))
  if (!is.na(hml_var)) {
    stopifnot(all(hml_var %in% names(df)))
  }

  stopifnot(all(
    unique(df[[zip_cd_var]]) |> stringr::str_detect("([0-9]{5})|()")
  ))
  stopifnot(all(
    unique(df[[county_name_var]]) |> stringr::str_detect("(.+ CO\\.)|()")
  ))
  stopifnot(all(
    unique(df[[state_cd_var]]) |> stringr::str_detect("([A-Z]{2})|()")
  ))
  if (!is.na(hml_var)) {
    stopifnot(all(unique(df[[hml_var]]) %in% c(0, 1, NA_integer_)))
  }

  y <- df |>
    # calc temporary 5-digit zip code to join on
    dplyr::mutate(
      tmp_calc_zipcode = .data[[zip_cd_var]] |>
        stringr::str_trim() |>
        stringr::str_sub(1, 5)
    )

  # if `hml_var` argument not supplied, create one and set to 0 (effectively
  # treating everybody as housed and so ignoring 'homeless' as a category)
  if (is.na(hml_var)) {
    y <- y |>
      dplyr::mutate(tmp_calc_hml = 0)

    hml_var <- "tmp_calc_hml"
  }

  zip_region_xwalk <- read.csv(
    "//kc/dph/Prevention/HIV/Epi/surv/EOQ/EOQ_append/EOQ Zip Category.csv"
  ) |>
    dplyr::transmute(
      zipcode = zipcode |>
        as.character() |>
        stringr::str_sub(1, 5),
      tmp_calc_region = KC_reside
    )

  y <- y |>
    dplyr::left_join(
      zip_region_xwalk,
      by = dplyr::join_by(tmp_calc_zipcode == zipcode)
    ) |>
    dplyr::mutate(
      !!rlang::sym(paste0(region_var, "_ZIP_ONLY")) := tmp_calc_region
    )

  # make adjustments to classification based on zip alone
  y <- y |>
    dplyr::mutate(
      tmp_calc_region = tmp_calc_region |>
        dplyr::replace_when(
          .data[[hml_var]] == 1 &
            .data[[county_name_var]] ==
              'KING CO.' ~ 'Unstably housed in King Co.',
          .data[[county_name_var]] == 'KING CO.' &
            tmp_calc_region %in%
              c(
                'Other - WA', # where a zip overlaps King and another county, the crosswalk maps it to King Co.; so this mismatch only occurs when the data in eHARS are erroneous; assume the county_name_var is right (and zip_cd_var is wrong) and defer to that
                'Removed', #used for zips that don't acually exist (crosswalk based on a zip list that included some bad data)
                'Retired' # used for old zips (no longer exist, and unclear what the boundaries were so don't know which region to put in)
              ) ~ 'z - Unknown (King County)'
        )
    )

  # more adjustments
  if (stringr::str_detect(zip_cd_var, "n_PLWA_")) {
    y <- y |>
      dplyr::mutate(
        tmp_calc_region = tmp_calc_region |>
          dplyr::replace_when(
            dplyr::coalesce(tmp_calc_region, "") == "" &
              dplyr::coalesce(.data[[state_cd_var]], "") != 'WA' ~ 'z - OOS'
          )
      )
  } else {
    y <- y |>
      dplyr::mutate(
        tmp_calc_region = dplyr::if_else(
          condition = dplyr::coalesce(tmp_calc_region, "") == "",
          true = tmp_calc_region |>
            dplyr::replace_when(
              dplyr::coalesce(.data[[state_cd_var]], "") == '' ~ 'z-Unknown',
              .data[[state_cd_var]] == 'FC' ~ 'z - Out of country',
              .data[[state_cd_var]] != 'WA' ~ 'z - OOS'
            ),
          false = tmp_calc_region
        )
      )
  }

  # final adjustments
  y <- y |>
    dplyr::mutate(
      tmp_calc_region = dplyr::if_else(
        condition = dplyr::coalesce(tmp_calc_region, "") == "" &
          .data[[state_cd_var]] == "WA",
        true = dplyr::case_when(
          !dplyr::coalesce(.data[[county_name_var]], "") %in%
            c('', 'KING CO.') ~ "Other - WA",
          .data[[county_name_var]] == 'KING CO.' ~ "z - Unknown (King County)",
          TRUE ~ 'z-Unknown'
        ),
        false = tmp_calc_region
      )
    )

  # apply value labels and preliminary variable label
  y <- y |>
    dplyr::mutate(
      tmp_calc_region = tmp_calc_region |>
        labelled::labelled(
          labels = c(
            'Seattle' = 'Central Seattle / Downtown',
            'Seattle' = 'N West Seattle ( Queen Anne, Magnolia)',
            'Seattle' = 'Seattle Central',
            'Seattle' = 'Seattle North',
            'Seattle' = 'Seattle South',
            'Seattle' = 'Seattle West',
            'Seattle' = 'West Seattle/Vashon Island',
            'South King County' = 'KC South',
            'East King County' = 'KC East',
            'North King County' = 'KC North',
            'Outside of King County' = 'Other - WA'
          )
        ) |>
        labelled::set_variable_labels("Region of Residence")
    )

  # change name of output var to that specified by user and drop temp zip var
  y <- y |>
    dplyr::select(-tmp_calc_zipcode) |>
    dplyr::rename(!!rlang::sym(region_var) := tmp_calc_region)

  if (hml_var == "tmp_calc_hml") {
    y <- y |>
      dplyr::select(-tmp_calc_hml)
  }

  return(y)
}

# df <- read_ehars_person(
#   col_select = c(rsd_zip_cd, rsd_county_name, rsd_state_cd)
# )
# region_var = "res_region_inc"
# zip_cd_var = "rsd_zip_cd"
# county_name_var = "rsd_county_name"
# state_cd_var = "rsd_state_cd"
# hml_var = NA_character_

# read_ehars_person(col_select = c(rsd_zip_cd, rsd_county_name, rsd_state_cd)) |>
#   calc_KingCo_region(
#     region_var = "res_region_inc",
#     zip_cd_var = "rsd_zip_cd",
#     county_name_var = "rsd_county_name",
#     state_cd_var = "rsd_state_cd"
#   ) |>
#   View()
#
# read_ehars_person(col_select = c(rsd_zip_cd, rsd_county_name, rsd_state_cd)) |>
#   dplyr::mutate(rsd_hml = 1) |>
#   calc_KingCo_region(
#     region_var = "res_region_inc",
#     zip_cd_var = "rsd_zip_cd",
#     county_name_var = "rsd_county_name",
#     state_cd_var = "rsd_state_cd",
#     hml_var = "rsd_hml"
#   ) |>
#   View()
#
#
# data.frame(x = c(letters[1:5], NA_character_, letters[6:10])) |>
#   dplyr::rowwise() |>
#   dplyr::mutate(
#     y = paste(rep(x, 3), collapse = ""),
#     y = y |>
#       dplyr::replace_when(
#         dplyr::coalesce(y, "") == "" ~ "XXXXX"
#       )
#   )
