#' read_table
#'
#' @importFrom magrittr %>%
#' @importFrom readxl read_xlsx
#' @importFrom dplyr select
#' @importFrom dplyr slice
#' @importFrom stringr str_detect
#'
read_aci_table <- function(tab_name, value_name, file_name) {

  if (!file.exists(file_name)) {
    stop("The ACI file does not exist!")
  }

  tbl_out <- suppressMessages(
    read_xlsx(
      file_name
      , sheet = tab_name
      , skip = 6
    )
  )

  tbl_out <- tbl_out %>%
    select(-1) %>%          # First column is blank
    slice(-(2:3)) %>%       # Rows 2 and 3 are blank
    slice(-(17:18))         # So are rows 17 and 18

  # The unstandardized data repeats the year and month rows
  if (str_detect(tab_name, "Unstandardized")) {
    tbl_out <- tbl_out %>%
      slice(-(17:20))        # Rows 2 and 3 are blank
  }

  tbl_out
}

#' read_monthly
#'
#' @importFrom dplyr slice
#' @importFrom stringr str_sub
#' @importFrom dplyr mutate
#' @importFrom tidyr pivot_longer
#' @importFrom tidyr separate
#' @importFrom tidyr drop_na
#'
#' @export
#'
read_monthly <- function(tab_name, value_name, file_name, drop_na_rows = TRUE) {

  tbl_out <- read_aci_table(tab_name, value_name, file_name)

  # Alter the column names so that they are year/month values. We will pivot them in a moment
  names(tbl_out) <- names(tbl_out) %>%
    str_sub(1, 4) %>%
    paste0("_", tbl_out[1, ])

  tbl_out <- tbl_out %>%
    slice(-1) %>%          # We've got the month, so we can drop this row
    mutate(
      region = rep(regions, 2)
      , smoothed = c(rep(FALSE, length(regions)), rep(TRUE, length(regions)))
    )

  tbl_out <- tbl_out %>%
    pivot_longer(c(-region, -smoothed), names_to = "year_month", values_to = "value") %>%
    separate(year_month, into = c("year", "month"), sep = "_") %>%
    mutate(date = as.Date(paste(year, month, "01", sep = "-"))) %>%
    select(region, smoothed, date, value)

  if (drop_na_rows) {
    tbl_out <- drop_na(tbl_out, value)
  }

  names(tbl_out)[names(tbl_out) == "value"] <- value_name

  tbl_out
}

#' read_all_monthly
#'
#' @importFrom dplyr select
#' @importFrom dplyr everything
#' @importFrom dplyr full_join
#'
#' @export
#'
read_all_monthly <- function(file_name) {

  tbl_current <- read_monthly(tbl_sheets_monthly$tab_name[1], tbl_sheets_monthly$value_name[1], file_name)

  for (i in seq(2, nrow(tbl_sheets_monthly))) {
    tbl_next <- read_monthly(tbl_sheets_monthly$tab_name[i], tbl_sheets_monthly$value_name[i], file_name)
    tbl_current <- full_join(tbl_current, tbl_next, by = c('region', 'smoothed', 'date'))

  }

  tbl_current %>%
    select(region, smoothed, date, everything())
}
