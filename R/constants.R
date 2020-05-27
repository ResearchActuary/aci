regions <- c(
  'ALA', 'CAR', 'CEA', 'CWP', 'MID'
  , 'NEA', 'NEF', 'NPL', 'NWP', 'SEA'
  , 'SPL', 'SWP', 'CAN', 'USA', 'USC'
)

tbl_sheets_monthly <- tibble::tribble(
  ~tab_name, ~value_name
  , 'Sea Level Monthly', 'sea_level'
  , 'Sea Level Unstandardized', 'sea_level_unstandardized'
  , 'CDD Monthly', 'consecutive_dry_days'
  , 'CDD Unstandardized', 'cdd_unstandardized'
  , 'Rx5Day Monthly', 'rx5_daily'
  , 'Rx5day Unstandardized', 'rx5_daily_unstandardized'
  , 'T10 Monthly', 't10'
  , 'T10 Unstandardized', 't10_unstandardized'
  , 'T90 Monthly', 't90'
  , 'T90 Unstandardized', 't90_unstandardized'
  , 'WP90 Monthly', 'wp90'
  , 'WP90 Unstandardized', 'wp90_unstandarized'
  , 'ACI Combined Monthly', 'aci'
)

url <- 'https://actuariesclimateindex.org/wp-content/uploads/2020/02/ACI_v1.1_Values_Through_Nov_2019_in_English.xlsx'

#' aci_regions
#'
#' @export
#'
aci_regions <- function() {
  regions
}
