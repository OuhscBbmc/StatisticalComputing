#This next line is run when the whole file is executed, but not when knitr calls individual chunks.
rm(list=ls(all=TRUE)) #Clear the memory for any variables set from any previous runs.

# ---- load-sources ------------------------------------------------------------
source("./2017-presentations/10-october/common-ellis.R")

# ---- load-packages -----------------------------------------------------------
library(magrittr                , quietly=TRUE)
requireNamespace("RODBC"                      )
requireNamespace("dplyr"                      )
requireNamespace("lubridate"                  )
requireNamespace("forcats"                    )

# ---- declare-globals ---------------------------------------------------------
range_date_taken          <- c(as.Date("2004-01-01"), Sys.Date())
range_child_dob           <- c(as.Date("1988-01-01"), Sys.Date())

col_types <- readr::cols_only(
  `CaseNumber_9231`                                             = readr::col_integer(),
  `Completing Program Unique Identifier_140`                    = readr::col_integer(),
  `Date Taken_140`                                              = readr::col_date("%Y/%m/%d %H:%M:%S"),
  `HA1. Not counting this pregnancy, how many times have you been pregnant?_4536` = readr::col_integer(),
  `HA2. How many live births have you had?_4537`                = readr::col_integer(),
  `HA3. What have you been told is your due date (EDD)?_4538`   = readr::col_date("%Y/%m/%d %H:%M:%S"),
  `Attributed Staff Name_140`                                   = readr::col_character(),
  `Last Updated By_140`                                         = readr::col_character()
)

# ---- load-data ---------------------------------------------------------------
path_in      <- "2017-presentations/10-october/maternal-health-01-fake.csv"

# readr::spec_csv(path_in)
ds_with_duplicates <- readr::read_csv(path_in, col_types=col_types)
rm(path_in, col_types)

# ---- tweak-data --------------------------------------------------------------

# OuhscMunge::column_rename_headstart(ds_with_duplicates)
ds_with_duplicates <- ds_with_duplicates %>%
  dplyr::select_(
    "case_number"                         = "`CaseNumber_9231`"
    , "program_code"                      = "`Completing Program Unique Identifier_140`"
    , "date_taken"                        = "`Date Taken_140`"
    , "previous_pregnancy_count"          = "`HA1. Not counting this pregnancy, how many times have you been pregnant?_4536`"
    , "live_birth_count"                  = "`HA2. How many live births have you had?_4537`"
    , "due_date"                          = "`HA3. What have you been told is your due date (EDD)?_4538`"
    , "staff_name_attributed"             = "`Attributed Staff Name_140`"
    , "staff_name_updated"                = "`Last Updated By_140`"
  ) %>%
  tidyr::drop_na(case_number) %>%   # There's an empty row at the bottom
  dplyr::arrange(case_number, program_code, date_taken) %>%
  dplyr::distinct() %>%
  dplyr::mutate(
    date_taken                            = dplyr::if_else(dplyr::between(date_taken, range_date_taken[1], range_date_taken[2]), date_taken, as.Date(NA_character_)),
    due_date                              = dplyr::if_else(dplyr::between(due_date, range_child_dob[1], range_child_dob[2]), due_date, as.Date(NA_character_)),
    due_month                             = OuhscMunge::clump_month_date(due_date),
    live_birth_count                      = dplyr::if_else(previous_pregnancy_count==0L, 0L, live_birth_count),
    worker_name                           = attribute_worker_name(staff_name_attributed, staff_name_updated)
  ) %>%
  tidyr::drop_na(date_taken) %>%   # Drop 10 records w/ bad dates
  dplyr::select(
    -due_date
  )

table(ds_with_duplicates$live_birth_count, useNA="always")

sum(duplicated(paste(ds_with_duplicates$case_number, ds_with_duplicates$program_code, ds_with_duplicates$date_taken)))


# ---- condense-client-program-date --------------------------------------------
colnames(ds_with_duplicates)

ds <- ds_with_duplicates %>%
  dplyr::mutate(
  ) %>%
  dplyr::group_by(case_number, program_code, date_taken) %>%
  dplyr::summarize(
    live_birth_count                  = OuhscMunge::first_nonmissing(live_birth_count               ),
    due_month                         = OuhscMunge::first_nonmissing(due_month                      ),
    worker_name                       = OuhscMunge::first_nonmissing(worker_name)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(
    maternal_health_id                = seq_len(n())
  )
# warnings()

sum(is.na(ds$live_birth_count) & is.na(ds$due_month))
purrr::map_int(ds, ~sum(is.na(.)))

# ---- verify-values -----------------------------------------------------------
head(sort(ds$date_taken))
# purrr::map(ds, ~range(., na.rm=T))
range(ds$due_month, na.rm=T)
# purrr::map(ds, ~table(., useNA="always"))

checkmate::assert_integer(ds$maternal_health_id               , lower=    1                 , upper= 9000               , any.missing=F, unique=T)
checkmate::assert_integer(ds$case_number                      , lower=10000                 , upper=50000               , any.missing=F, unique=F)
checkmate::assert_integer(ds$program_code                     , lower=  700                 , upper=  899               , any.missing=F)
checkmate::assert_date(   ds$date_taken                       , lower=range_date_taken[1]   , upper=range_date_taken[2] , any.missing=F)
# checkmate::assert_date( ds$due_month                       , lower=range_child_dob[1]    , upper=range_child_dob[2]  , any.missing=T)
checkmate::assert_date(   ds$due_month                                                                                  , any.missing=T)
checkmate::assert_integer(ds$live_birth_count                , lower=    0                 , upper=   20               , any.missing=T)
checkmate::assert_character(ds$worker_name    , min.chars=2, any.missing=F) # Max is 50 in DB

sum(duplicated(paste(ds$case_number, ds$program_code, ds$date_taken)))
checkmate::assert_character(paste(ds$case_number, ds$program_code, ds$date_taken), any.missing=F, unique=T)


# ---- specify-columns-to-upload -----------------------------------------------
# dput(colnames(ds))
columns_to_write <- c(
  "maternal_health_id", "case_number", "program_code", "date_taken",
  "due_month", "live_birth_count",
  "worker_name"
)
ds_slim <- ds %>%
  dplyr::select_(.dots=columns_to_write) %>%
  # dplyr::slice(1:200) %>%
  dplyr::mutate(
    # assistance_qualify                  = as.integer(assistance_qualify)
  )

# ---- upload-to-db ------------------------------------------------------------
# sapply(ds_slim, function(x)max(nchar(as.character(x)), na.rm=T))
OuhscMunge::upload_sqls_rodbc(
  d             = ds_slim,
  table_name    = "osdh.tbl_eto_touchpoint_maternal_health",
  dsn_name      = "MiechvEvaluation",
  clear_table   = T,
  create_table  = F
) # 0.176 minutes 2017-10-02
