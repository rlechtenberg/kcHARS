.onAttach <- function(libname, pkgname) {
  # don't overwrite kcHARS.ehars_dt global option if already set (e.g., before
  # the call to library(kcHARS), incl. in their .Rprofile)
  if (is.null(getOption("kcHARS.ehars_dt"))) {
    # identify dates of archived eHARS extracts
    dirs <- list.dirs(
      file.path(ehars_root_dir(), "Archive"),
      recursive = FALSE
    ) |>
      stringr::str_remove_all(paste0(ehars_root_dir(), "/Archive/"))

    # identify directories to ignore (i.e., those whose names do not adhere to the
    # YYYY-MM-DD convention)
    ignore_dirs <- stringr::str_subset(
      dirs,
      pattern = "^[0-9]{4}\\-[0-9]{2}\\-[0-9]{2}$",
      negate = TRUE
    )
    if (length(ignore_dirs) > 0) {
      warning(paste(
        "Ignoring the following sub-directories of 'Full eHARS/Archive' (b/c not named per the convention of YYYY-MM-DD):",
        ignore_dirs
      ))
    }

    # identify the most recent extract
    rec_ehars_dt <- stringr::str_subset(
      dirs,
      pattern = "^[0-9]{4}\\-[0-9]{2}\\-[0-9]{2}$"
    ) |>
      max()

    # set global option storing ehars_dt
    if (is.null(getOption("kcHARS.ehars_dt"))) {
      options("kcHARS.ehars_dt" = rec_ehars_dt)
    }
  }

  # display start-up message notifying user of ehars_dt being used by default,
  # how to re-set it, and of directories ignored
  packageStartupMessage(
    paste0(
      "Using eHARS data dated ",
      getOption("kcHARS.ehars_dt"),
      ". \n(You can specify a different date using `options(kcHARS.ehars_dt = '<YYYY-MM-DD>')`."
    )
  )
}
